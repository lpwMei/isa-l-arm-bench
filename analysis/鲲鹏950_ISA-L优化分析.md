# 鲲鹏 950：ISA-L 与 Redis CRC16 优化分析

分析日期：2026-10-20。以下“已确认”来自下载的上游源码和官方文档；“候选方案”是待实机验证的工程判断。当前环境为 Windows，未连接鲲鹏 950，尚无性能提升实测结果。

用户已确认：**10% 以 ISA-L 自带 benchmark 的最终输出数值验收；解压对象是 ZIP 文件。** 因此内核局部提速必须反映到相应 benchmark 的完整计时路径上。此处不将目标解释为 Redis 或存储业务整体吞吐提高 10%。

后续进展：已在用户 GitHub 账户的免费 ARM runner 上完成第一轮基准，实机为 Neoverse-N2 / 128位SVE。两版各17项正确性测试通过，已保存350个吞吐测量值。见 [ARM云端实测报告](D:/codex/ISA-L/cloud/ARM云端基准结果_2026-10-20.md)。该结果补充 ARM 验证，鲲鹏950仍待实机验收。

## 1. 已下载的版本与目录

| 项目 | 当前最新稳定版 | 稳定版提交 | 最新开发分支快照 |
| --- | --- | --- | --- |
| ISA-L | [v2.32.1，2026-07-01](https://github.com/intel/isa-l/releases/tag/v2.32.1) | `7c3479e0a9dac17f448603ec1ad64c7c625f530c` | master：`8fa1e72fee7338fcfbf829b00f2f407631bd2dba`，2026-09-30 |
| ISA-L Crypto | [v2.26.1，2026-06-12](https://github.com/intel/isa-l_crypto/releases/tag/v2.26.1) | `c353c2d021c03cfc6180ddf9e28a24b3b61e9760` | master：`f22c49aef162d7632bde4f22dc7491b22f0a7fc2`，2026-07-23 |
| Redis | [8.10.2，2026-09-17](https://github.com/redis/redis/releases/tag/8.10.2) | `498ecd0d6d007db11ddb3aea9428552598a78622` | unstable：`559d143b4e0409c452f7d229ba420954b6b647a2`，2026-10-20 |

开发分支 Git 仓库位于 `D:/codex/ISA-L/upstream/`，采用浅克隆，并补取了以上稳定标签。稳定版完整源码位于 `D:/codex/ISA-L/releases/`。未修改三个上游工作区。

可直接传到 Linux 服务器解包的源码归档：

- [ISA-L v2.32.1](D:/codex/ISA-L/downloads/isa-l-v2.32.1.tar)
- [ISA-L Crypto v2.26.1](D:/codex/ISA-L/downloads/isa-l_crypto-v2.26.1.tar)
- [Redis 8.10.2](D:/codex/ISA-L/downloads/redis-8.10.2.tar)

归档由对应上游 Git 标签导出，保留 Linux 源文件换行。完整 SHA 和归档 SHA256 见 [source-manifest.json](D:/codex/ISA-L/analysis/source-manifest.json)。

## 2. 建议优先级

| 顺序 | 工作项 | 首个可验证改动 | 对 10% 目标的判断 |
| --- | --- | --- | --- |
| P0 | 冻结 benchmark 和基线 | 稳定版、当前 master、优化版使用相同输入和计时口径 | 必须先做；升级上游的收益与新增补丁收益分别列出 |
| P1 | CRC32C | 对照主干新内核，优化短包入口、分段阈值及融合比例 | 候选明确；已有上游改动可能覆盖部分需求 |
| P1 | EC | 调整 SVE 展开倍数和输出分组，减少循环内向量寄存器溢出 | 有源代码与交叉编译汇编证据，值得优先投入 |
| P1 | ZIP 的 DEFLATE 解码 | 回溯复制快路、非重叠宽复制、减少展开代码体积 | 有明确低效路径；需同时明确官方 inflate 分数和 ZIP 验证的关系 |
| P2 | Redis Cluster CRC16 | slicing-by-4/8 与短 key 路径，连同 hash tag 扫描一起测试 | CRC16 本身可优化；Redis QPS 收益另测 |
| 并行验证工作 | Crypto 继承 | 在 v2.26.1 与 master 上重放已有补丁、正确性及性能回归 | 作为继承验证验收，不预设新增 10% 优化任务 |

这里没有给出未经测量的“预计提升 15%/30%”。应先选定验收 case，再确认候选改动能否达到 10%。

## 3. 首先把 benchmark 的计时范围固定下来

### 3.1 官方 benchmark 不等于整个业务

CRC 用 `crc/crc_funcs_perf`；EC 用 `erasure_code/erasure_code_perf` 及 update perf；inflate 用 `igzip/igzip_perf`。应固定具体输出行、参数、输入文件 SHA256、编译器及版本。

吞吐验收公式为 `T_after / T_before >= 1.10`。对同一工作量，这相当于运行时间降至原来的 `1/1.10 ≈ 90.91%`。不能把“局部循环少 10% 指令”当作 benchmark 已提速 10%。

EC 上游输出也有自己的字节口径：当前 encode 使用 `len*(k+p)`，decode 使用 `len*(k+nerrs)`。其计时循环主要是 `ec_encode_data()`；矩阵生成、求逆、表初始化和正确性比较并非都在计时区内。跨 k/p 横向比较时应另记有效输入字节，优化前后比较则固定同一 case。证据：[EC benchmark](https://github.com/intel/isa-l/blob/8fa1e72fee7338fcfbf829b00f2f407631bd2dba/erasure_code/erasure_code_perf.c#L202)。

### 3.2 ZIP 与官方 inflate benchmark 的关键差别

**不能把一个 `.zip` 文件直接作为 `igzip_perf` 的输入，就把输出称为 ZIP 解压成绩。** 这个程序读取输入文件，将它当作原始内容压缩，再反复解压所生成的 DEFLATE 流。

`igzip_perf` 的 stateless round 明确设置 `state->crc_flag = ISAL_DEFLATE`；stateful round 初始化后使用默认 raw DEFLATE。计时包含相应 round 的设置/初始化及解码调用，文件读取和初次数据一致性比较位于计时循环之外。默认这两条路径不包含 ZIP 目录解析、ZIP CRC32 校验或文件落盘。证据：[round](https://github.com/intel/isa-l/blob/8fa1e72fee7338fcfbf829b00f2f407631bd2dba/igzip/igzip_perf.c#L395)、[计时区](https://github.com/intel/isa-l/blob/8fa1e72fee7338fcfbf829b00f2f407631bd2dba/igzip/igzip_perf.c#L678)。

建议保留两组结果：

1. **正式 ISA-L 指标**：固定 `igzip_perf` 的 inflate 输出和原始语料，目标提高 10%。优先改解码和复制路径；只改 CRC 不会提高默认 raw inflate 分数。
2. **ZIP 需求验证**：由 ZIP 层读取条目，把 method 8 条目的 raw DEFLATE 数据交给 ISA-L；比较条目输出及 CRC32。另列完整 ZIP 解包用时，标明是否包含目录解析、校验与磁盘 I/O。若这组也要作为 10% 验收，需要增补 ZIP 驱动，当前上游没有现成的完整 ZIP benchmark。

ZIP 可以含多种压缩方法。method 8 为 DEFLATE，可复用 ISA-L inflate；method 0 是存储，主要走复制和校验；其他方法及加密条目不应直接送进 inflate。ZIP 层还需处理中央目录、ZIP64、data descriptor 等。参见 [PKWARE ZIP 规范](https://pkware.cachefly.net/webdocs/casestudies/APPNOTE.TXT)。

ISA-L 的 `ISAL_GZIP_NO_HDR` 可以在解 raw DEFLATE 时累计 gzip/ZIP 使用的 CRC32，然后由 ZIP 层比较期望 CRC；不能用需要紧随 gzip trailer 的 `ISAL_GZIP_NO_HDR_VER` 直接替代 ZIP 校验。也可在 ZIP 层显式调用 `crc32_gzip_refl()`。证据：[inflate API 说明](https://github.com/intel/isa-l/blob/8fa1e72fee7338fcfbf829b00f2f407631bd2dba/include/igzip_lib.h#L965)。

仓库还提供 [实验性 zlib shim](https://github.com/intel/isa-l/blob/8fa1e72fee7338fcfbf829b00f2f407631bd2dba/igzip/shim/README.md)。若现有 ZIP 程序通过兼容的动态 zlib 接口解码，可作为接入实验；它本身不提供 ZIP 解析，具体 API、流复位、错误码和实际加载路径仍需验证。

## 4. CRC 性能优化

### 已确认的现状

- CRC32C 对应 `crc32_iscsi()`；gzip/ZIP 使用的反射 IEEE CRC32 对应 `crc32_gzip_refl()`。二者多项式不同。
- 稳定版已有 CRC 指令、PMULL 和 3CRC fold；CRC16/T10-DIF、CRC64 也已有 ARM PMULL 实现。
- master 相比 v2.32.1 新增 `crc32_iscsi_x6` 和 `crc32_iscsi_fusion_p8_c10_asm`，并修改 CRC32C 调度。p8c10 使用 416 字节块，入口检查当前线程 SVE VL 为 32 字节，其他 VL 回退 x6。
- gzip CRC32 的调度仍以原有 3CRC fold 等实现为主，不能把 CRC32C 的新增收益直接算到 ZIP CRC 上。

证据：[调度器](https://github.com/intel/isa-l/blob/8fa1e72fee7338fcfbf829b00f2f407631bd2dba/crc/aarch64/crc_aarch64_dispatcher.c#L134)、[p8c10](https://github.com/intel/isa-l/blob/8fa1e72fee7338fcfbf829b00f2f407631bd2dba/crc/aarch64/crc32_iscsi_p8c10.S#L187)、[x6 入口](https://github.com/intel/isa-l/blob/8fa1e72fee7338fcfbf829b00f2f407631bd2dba/crc/aarch64/crc32_iscsi_x6.S#L155)。

### 候选方案

| 项目 | 具体做法 | 验证重点 |
| --- | --- | --- |
| 短包快路 | x6 当前先保存 160 字节栈帧，再检查长度；尝试在保存大批寄存器前进入少寄存器短包路径 | 0/1/8/16/32/64/128 字节；冷启动与稳态分开 |
| 分段和融合比例 | 对比旧 3CRC、x6、p8c10；搜索短/中/大块切换点、CRC/PMULL 并行比例 | 950 上实测指令延迟、吞吐、load 带宽，而非按型号猜最优实现 |
| gzip/ZIP CRC32 | 为反射 IEEE 多项式生成对应折叠常数，尝试更多独立 CRC 链和 PMULL 融合 | 独立 CRC 分数与带校验 ZIP 路径分别验收 |
| CRC64/T10-DIF | 调整折叠路数、加载顺序、尾部处理及预取距离 | 先测实际使用算法，避免把未使用多项式列为主任务 |
| copy+CRC | 使用或优化现有 `crc16_t10dif_copy()` 的融合路径 | 同时说明复制字节量与 CRC 字节量，不能删除必要复制来改变工作量 |

优先做稳定版与 master 的 A/B，确认新增内核在 950 上的实际收益，再决定移植或继续优化。若要求“在最新 master 上再提高 10%”，已在 master 的内核不能算新成果。

主干 p8c10 使用 SVE 的 128 位结果 PMULLB/PMULLT，但当前选择条件主要检查 CRC32 与 SVE2。还应核对 `HWCAP2_SVEPMULL` 等实际指令要求；SVE2 与 SVE PMULL 能力应分别确认。此项是新内核可用性验证，不是已测性能收益。[Linux HWCAP 文档](https://www.kernel.org/doc/html/latest/arch/arm64/elf_hwcaps.html)。

## 5. EC 性能优化

### 已确认的现状

当前已支持 NEON、SVE 和 SVE2 调度。SVE 点积由 C intrinsics 生成多个输出版本，内部按 4 倍向量长度展开；SVE2 版本希望编译器合并 XOR。高层对 6 路输出用 `4+2`、7 路用 `4+3`，并不是简单地把路数加到最大。

master 又增加了全 1 系数行识别：这类校验行直接 XOR，跳过 GF 查表。稳定版没有这项改动。它对相应编码矩阵有利，对任意恢复矩阵不能一概套用。

证据：[SVE 内核](https://github.com/intel/isa-l/blob/8fa1e72fee7338fcfbf829b00f2f407631bd2dba/erasure_code/aarch64/gf_nvect_dot_prod_sve.c#L38)、[输出分组](https://github.com/intel/isa-l/blob/8fa1e72fee7338fcfbf829b00f2f407631bd2dba/erasure_code/aarch64/ec_aarch64_highlevel_func.c#L218)。

### 候选方案

1. **按输出路数调整展开倍数。** 比较 1x/2x/4x，缩短源数据、nibble、表及累加器的同时存活时间。已使用本机 Clang 23.1.3 生成 ARM 汇编，3/4 路版本可见循环内 Z 寄存器向栈溢出与重载。这比仅凭源码猜测更有依据，但仍须用服务器实际编译器确认。见 [编译说明](D:/codex/ISA-L/analysis/asm/README.md)。
2. **联合搜索输出分组。** 对比 `4+2`、`3+3`、单 6 路，以及 `4+3`、单 7 路。更多输出可以减少源数据重复读取，也可能因寄存器压力退化。避免只看调用次数。
3. **改进全 1 行快路。** 对小块评估每次调用扫描 `k*rows` 系数的成本；把特殊行判断尽可能移到数据循环之外，比较“单独 XOR 行+普通 GF 行”与当前混合分支。任意系数矩阵和 decode 路径必须保持等价。
4. **检查最终生成指令。** 确认目标编译器实际产生 EOR3、预期的 TBL/加载调度，必要时对热点路数使用专门的 SVE2 内核。不能把函数名含 `sve2` 当作自动取得更高吞吐的证据。
5. **单独优化 update。** `ec_encode_data_update()` 使用 MAD 内核，已有每次处理多输出的 SVE 汇编。其读改写流量与完整 encode 不同，应独立调展开、预取和输出分组。

另有与调优直接相关的正确性检查：当前 SVE 点积用全真 predicate 加载每个 16 字节半表；当 VL>16 字节时，会读取超过对应半表的数据，末条记录可能越过表分配边界。建议用保护页复现并比较“仅加载低 16 字节”或 16 字节复制加载方案。本分析未在 950 上复现故障，不把它当作已证实的运行时崩溃。

EC 建议矩阵：`k+p = 4+2、6+3、8+3、10+4、12+4、16+4`，另加 `p=5/6/7` 专门覆盖分组；长度 4KiB/16KiB/64KiB/256KiB/1MiB。encode、decode、update 各自输出结果；正确性还要覆盖任意矩阵、单/多丢失和非整向量尾部。

## 6. ZIP/DEFLATE 解压性能优化

### 最明确的热点候选：回溯复制

ARM 解码汇编中，当 `look_back_dist <= repeat_length` 时进入逐字节复制；其余分支主要用 4 字节复制，并有 `.rept 62` 展开。重叠回溯在可压缩内容中常见，值得实测其耗时比例。

证据：[回溯分支与 4 字节复制](https://github.com/intel/isa-l/blob/8fa1e72fee7338fcfbf829b00f2f407631bd2dba/igzip/aarch64/igzip_decode_huffman_code_block_aarch64.S#L555)、[逐字节循环](https://github.com/intel/isa-l/blob/8fa1e72fee7338fcfbf829b00f2f407631bd2dba/igzip/aarch64/igzip_decode_huffman_code_block_aarch64.S#L662)。

建议首先实现并逐项比较：

- distance=1 的重复字节广播；distance=2/4/8 的周期模式填充。
- distance>=16 时采用顺序的 16 字节 load/store；必要时对更大距离展开成 32 字节。即使总体区间重叠，也要保证每次读取的字节已生成、块宽不超过安全距离。
- 确认完全不重叠的区间用 8/16/32 字节复制；对尾部精确收敛，禁止越过输入历史或输出容量。
- 比较紧凑循环与当前较大展开的 I-cache、分支和吞吐成本。

LZ 回溯复制需要让本轮新生成的字节成为后续输入，不能普遍用 `memcpy` 或 `memmove` 替代。对 distance=3/5/7 等周期、length=3..258、输出容量不足以及跨调用续拷贝必须保留正确语义。

### 后续候选

Huffman 解码存在 bit buffer、查表和分支依赖；先用 perf 确认复制、解码或建表谁是主要瓶颈，再决定优化查表布局、补位和 literal 连续输出。许多小 ZIP 条目还会放大初始化、动态 Huffman 建表、流式临时历史缓冲搬移的成本。`igzip_inflate.c` 中已有动态表构造和 `tmp_out_buffer` 搬移路径，可作为第二阶段对象。

ZIP 验证语料至少分为：大文本、JSON/日志、二进制、重复内容、接近不可压缩内容、数千小条目；压缩方法和生成器固定。官方 `igzip_perf` 用同一原始内容和相同压缩策略；真实 ZIP 则记录每个条目的方法、压缩长度、原始长度和 CRC。ZIP64、data descriptor、空条目等是接入正确性用例，不能通过忽略这些处理改变基线工作量。

如果后续允许多核解包，独立 ZIP 条目可以并行处理；这属于新的并发维度，应与单核 ISA-L benchmark 10% 分开报告。KAE/UADK 硬件卸载也属于独立比较项：官方 KAE 已列出 950 支持，但它不能直接当作 ISA-L CPU 内核优化结果。[KAE 官方说明](https://github.com/kunpengcompute/KAE/blob/kae2/README.md)。

## 7. Crypto：已有需求在新版本上的继承验证

ISA-L Crypto 是独立仓库。v2.26.1 与本次 master 快照的差异只有 CI、AES 参数测试、configure 和 x86 寄存器宏等四个文件，未见 ARM 算法内核变化。这有助于控制回归范围，但不能代替已有补丁和调用方的实测。

建议比较四列：旧交付版、旧版+已有补丁、新版原生、新版+继承补丁。若旧需求已被上游覆盖，则记录对应实现和结果，避免重复叠补丁。当前没有收到已有补丁/分支，因此本次尚未完成其继承验证。

验证范围：

- 用实际调用的 AES-GCM/CBC/XTS、SHA256/512、SM3、MD5 等算法限定清单，不把所有算法自动纳入需求。
- v2.25 起新增 `isal_` 前缀 API 与参数检查，核对调用签名、返回码和旧符号兼容；保存导出符号列表及程序链接结果。
- 确认 HWCAP 调度：GCM 检查 AES/PMULL/ASIMD；SHA256 检查 SHA2；SM3 在专用 SM3、SVE/SVE2、ASIMD 路径间选择。
- 运行 `make check`，按算法补跑随机 OpenSSL 对照测试；GCM 比较输出和标签及调用层验签行为，XTS 覆盖非整块尾部，hash 覆盖流式 submit/flush 和不同并行 job 数。
- 保持 SAFE_PARAM、SAFE_DATA、FIPS 模式、密钥展开计时策略与原交付要求一致，不通过关闭已有检查取得性能分数。
- Crypto 性能按原有验收阈值做回归；若还要求新增 10%，需要另设明确 case。

源码入口：[GCM 调度](https://github.com/intel/isa-l_crypto/blob/f22c49aef162d7632bde4f22dc7491b22f0a7fc2/aes/aarch64/gcm_aarch64_dispatcher.c#L33)、[SM3 调度](https://github.com/intel/isa-l_crypto/blob/f22c49aef162d7632bde4f22dc7491b22f0a7fc2/sm3_mb/aarch64/sm3_mb_aarch64_dispatcher.c#L28)、[测试列表](https://github.com/intel/isa-l_crypto/blob/f22c49aef162d7632bde4f22dc7491b22f0a7fc2/aes/Makefile.am#L129)。

## 8. Redis Cluster CRC16 优化

### 已确认的现状

Redis 使用 CRC16/XMODEM：poly=0x1021、init=0、输入/输出不反射、xorout=0；`123456789` 结果为 `0x31C3`。当前 `src/crc16.c` 逐字节查 256 项表，形成串行依赖链。8.10.2 与本次 unstable 的该文件无差异。

`keyHashSlot()` 先寻找首个 `{` 和其后的首个 `}`，符合规则时只哈希中间的非空子串，否则哈希整个 key，最终保留低 14 位。不能改变 hash tag 规则或现有槽位。

**不能直接使用 ISA-L `crc16_t10dif()` 替换，也不能用 ARM CRC32 指令算完截断为 CRC16。** 多项式及状态变换不等价。

证据：[CRC16](https://github.com/redis/redis/blob/559d143b4e0409c452f7d229ba420954b6b647a2/src/crc16.c#L32)、[hash tag](https://github.com/redis/redis/blob/559d143b4e0409c452f7d229ba420954b6b647a2/src/cluster.h#L54)。

### 候选方案与顺序

| 顺序 | 方案 | 适用范围与代价 |
| --- | --- | --- |
| 1 | slicing-by-4/8 | 一次处理多个字节，降低 CRC 串行依赖；表约 2KiB/4KiB，衡量 L1 占用及短 key 开销 |
| 2 | 短 key 专门路径 | 常见 8~64 字节场景，比较少分支展开、内联和调用成本；短 key 可能不适合向量初始化 |
| 3 | hash tag 扫描 | 比较 memchr、当前循环以及扫描/CRC 融合；按无 tag、有 tag、空/未闭合 tag 分别测 |
| 4 | 长 key PMULL 折叠 | 使用 XMODEM 专用常数，设置标量/向量切换阈值；不先假定 PMULL 对普通短 key 更快 |
| 5 | 已有计算复用审计 | 最新代码已有当前命令的 slot 缓存，先定位仍重复计算的位置，再考虑额外缓存 |

已有 slot 缓存证据：[db.c 的 calculateKeySlot/getKeySlot](https://github.com/redis/redis/blob/559d143b4e0409c452f7d229ba420954b6b647a2/src/db.c#L491)。不建议第一步给每个 key 对象新增 slot 字段，其内存开销、生命周期和已有缓存覆盖面均需另评估。

基准应分三层：`crc16()` 的 ns/key、完整 `keyHashSlot()` 的 ns/key、真正 Cluster 模式 GET/SET/MGET 的 QPS 与延迟。测试完整 key 长度和实际被哈希的 tag 长度；覆盖二进制 key、内嵌 NUL、嵌套花括号、首个空 tag、未闭合 tag。对全部短输入及大量随机输入比较原实现槽位，并跑 Cluster 路由/跨槽回归。

ISA-L 不提供 Redis CRC16 benchmark，因此这一项需要单独建立测试工具，不能拿 ISA-L T10-DIF 分数代替。若同时要求 Redis QPS 提高 10%，需先看服务端 profile 的 CRC/hash-slot 耗时占比：例如 CRC 占 5%，即使消除全部 CRC 耗时，理论整体收益也只有约 5.26%。这是 CPU 受限、其他条件不变时的上限分析，不是本次实测。

## 9. 鲲鹏 950 实机验证与实施安排

### 实机先采集的信息

运行 [collect_kp950_env.sh](D:/codex/ISA-L/tools/collect_kp950_env.sh)：

```bash
bash collect_kp950_env.sh | tee kp950-env.txt
```

脚本只读，采集 CPU/MIDR、Features、NUMA、编译器及库版本、频率策略、auxv 和探测线程当前 SVE VL。不根据“950”名称预设 SVE/SVE2、256 位 VL 或某个 GCC `-mcpu` 名称。SVE VL 属于线程状态，benchmark 若修改 VL，还应在其实际工作线程内记录。[Linux SVE 文档](https://docs.kernel.org/arch/arm64/sve.html)。

### 构建与初始 benchmark 命令

下列是 Linux 上的待执行步骤，尚未在本机执行。需要 make、autoconf、automake、libtool、可用 AArch64 编译工具链；igzip perf 依赖 zlib 开发包，Crypto 的部分对照测试依赖 OpenSSL 开发包。ISA-L 当前 README 要求 AArch64 GCC>=10.1；主干新增汇编还须确认汇编器识别其指令。

```bash
# 在解包后的 ISA-L 源码目录中；稳定版/master/优化版分别独立构建。
./autogen.sh
./configure CFLAGS='-O3 -g'
make -j"$(nproc)"
make check
make -j"$(nproc)" perfs
make igzip/igzip_perf

# CPU、NODE 由 lscpu/numactl 确定，以下仅为示例。
CPU=2
NODE=0
numactl --physcpubind="$CPU" --membind="$NODE" \
  ./crc/crc_funcs_perf -t iscsi -s 16,64,256,1024,4096,16384,65536,1048576 -c
numactl --physcpubind="$CPU" --membind="$NODE" \
  ./crc/crc_funcs_perf -t gzip -s 16,64,256,1024,4096,65536,1048576 -c
numactl --physcpubind="$CPU" --membind="$NODE" \
  ./erasure_code/erasure_code_perf -k 10 -p 4 -e 1 -s 64K

# corpus/sample.bin 是原始未压缩内容，不是把 ZIP 容器当作待解码流。
numactl --physcpubind="$CPU" --membind="$NODE" \
  ./igzip/igzip_perf -l 1 -d 0 -i 3 -t -s -b 4096 corpus/sample.bin

# 对单独选定的 case 定位热点；perf 权限由服务器现状决定。
perf stat -e cycles,instructions,branches,branch-misses,cache-misses \
  numactl --physcpubind="$CPU" --membind="$NODE" \
  ./erasure_code/erasure_code_perf -k 10 -p 4 -e 1 -s 64K
```

上游 CRC 的 `--cold` 路径有最小长度等限制；EC 的 `--cold` 是本次 master 相比稳定版新增的 benchmark 能力。对比冷缓存时使用同一套驱动/工作集设置，不能把两个版本不同的默认测试配置当作库性能差异。官方 perf 也不覆盖所有 seed、偏移和尾长，正确性边界需由现有测试与增补专项测试覆盖。

### 建议的验收方法

- 固定服务器、CPU/NUMA、频率策略、编译器、优化选项、安全选项、语料和线程数。先使用当前发布配置与同编译器 A/B；若比较 GCC/毕昇/Clang，单列编译器收益。
- 基线采用优化后的默认 API，不采用 `_base` 标量函数。保存稳定版→master、master→新增补丁两组结果，明确 10% 是相对哪组基线。
- A/B 交替运行，预热后至少 7 组独立进程；记录每个 case 中位数、离散程度及异常原因。需要汇总时预先固定用例与权重，避免只挑提升项。
- CRC 按实际使用的多项式、尺寸验收；EC 分 encode/decode/update；inflate 分 stateless/stateful 与语料；Crypto 做原交付要求回归；Redis 单列 CRC16/hash-slot 和 Cluster 指标。
- 每个候选先通过正确性，再读取最终 benchmark 结果；ASan/UBSan、保护页等用于正确性构建，不用其性能数值验收。

实施顺序建议为：先固定基线和 ZIP 计时范围；第一轮做 CRC 新旧内核对比、EC 展开/分组、inflate 回溯复制；随后只对 profile 证明仍占主要耗时的路径继续优化。Crypto 继承验证可在拿到已有补丁后独立开展。当前已完成源码下载、稳定版/主干静态对比和 EC 交叉编译分析，尚未进行 ARM 实机测试、修改性能内核或完成 Crypto 补丁回归。
