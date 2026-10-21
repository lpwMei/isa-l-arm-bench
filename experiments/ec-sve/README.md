# ISA-L EC 优化实验

首项需求选择 **EC 编码**，基线为 ISA-L 主干
`8fa1e72fee7338fcfbf829b00f2f407631bd2dba`。验收定义见
[ACCEPTANCE.md](ACCEPTANCE.md)。

选择理由：先前同一台免费 ARM 上的稳定版/主干对比，10+4、10+6、10+7
编码出现约13%至15%的回退；SVE内核统一四倍展开会增加同时存活的向量，
系数全1快路还增加了循环内判定。存在明确的代码线索、官方工具和正确性对照。

其他需求的顺序：CRC（尤其64字节CRC32C）适合下一项；Redis Cluster CRC16
单独建基线；ZIP须补充容器解析及DEFLATE解码的联合测试；Crypto继承是兼容性
验证，需要已有补丁，不能把通过验证等同于提升10%。

## 筛选实测

原生Neoverse-N2，SVE/SVE2，向量宽度16字节，GCC13.3.0、`-O3 -g`，
固定CPU、同机交替三轮。命令保持官方驱动：

```sh
taskset -c "$CPU" ./erasure_code/erasure_code_perf -k 10 -p 4 -e 1 -s 64K
```

| 候选 | 10+4编码 | 10+6编码 | 10+7编码 | 结论 |
|---|---:|---:|---:|---|
| 单倍展开独立helper | -16.64% | -11.17% | -18.97% | 排除 |
| 两倍展开独立helper | +10.96% | +7.22% | +7.35% | 未完全达标 |
| 仅改为两行分组 | +7.11% | +4.61% | +0.19% | 未达标 |

四个版本的完整`make check`均通过。不能把筛选阶段的单项成功当作整体验收。

实验：[39430645982](https://github.com/lpwMei/isa-l-arm-bench/actions/runs/39430645982)
，工作流提交`3107c67dac82adf071df66d4ae8397a0f575cd06`。
原始artifact SHA256：`38d69c805eb2596572b59f752ebb950b0ba834231711b524f741d06cb5c7d5a5`。

## 精简候选

`adaptive`在原函数内采用编译期可确定的批次数：1/2路保留4倍，3路及以上
使用2倍。只保留前两批存储使编译器删除后两批不用的数据流；提前计算是否
需要GF查表，1/2路保持原有判定方式。此外将系数半表读取限定为16字节，适应
更宽的SVE向量。高层分组、接口、GF系数、驱动和吞吐计算方式均保持原样。

本地Clang23.1.3、freestanding AArch64静态分析显示，3/4路向量溢出消失，
函数静态指令数减少；这些数字不等同于Linux GCC动态指令数或性能收益。

独立验证工作流：
[39431742695](https://github.com/lpwMei/isa-l-arm-bench/actions/runs/39431742695)，
固定提交`c6c43138258ee500f09085b41b18e3c6b898c967`，七轮主验收、三轮扩展配置。

该轮已完成，正确性检查通过，但性能验收失败：10+4编码+11.38%、
10+6为+6.91%、10+7为+6.57%。保护项均在3%回退限内；七轮原始结果保留。
原生保护页检查5,544组、21,816次调用通过。
artifact SHA256：`4041e3ec305588f70f988e86883f8788cf8bf358079d6d4d13cbcf4ea80e7680`。

因此继续比较两条方向：`adaptive_fused`使用6/7路内核一次完成校验块；
`table4`仅在1/2路保留全1系数分支，3路及以上恢复连续的GF查表计算，
让SVE2编译器重新合并三输入异或。后者改动很小，但是否有效由实测决定。

融合版本[39434411466](https://github.com/lpwMei/isa-l-arm-bench/actions/runs/39434411466)
的七轮结果为10+4编码+10.86%、10+6为+9.54%、10+7为+12.36%；未满足三项
分别至少10%的门限，因此不作为最终补丁。

`table4`版本[39434973237](https://github.com/lpwMei/isa-l-arm-bench/actions/runs/39434973237)
的七轮结果为+17.95%、+11.13%、+15.99%，已通过主验收。其余性能保护项
见最终[结果报告](https://github.com/lpwMei/isa-l-arm-bench/blob/main/EC-RESULTS-2026-10-20.md)。最终候选不改变展开量和高层分组，
仅改动一个源文件中的4行。

最终工作流全部成功。扩展配置也通过检查；数据与原始证据见最终报告。

## 鲲鹏950的适用范围

鲲鹏官方[sonic-cpp优化文档](https://www.hikunpeng.com/document/detail/zh/kunpengaccel/kserl/soniccpp/docs/zh/quick_start.md)
列明950支持SVE/SVE2，并提供SVE2-256补丁。因此另做128/256/512位保护页
正确性检查；更宽向量使用QEMU，不产生性能结论。

向量宽度检查[39432334525](https://github.com/lpwMei/isa-l-arm-bench/actions/runs/39432334525)
已通过：16、32、64字节宽度各2,244组矩阵/长度组合、8,748次编码调用。
artifact SHA256：`fe87cd7b8d5b232070f3267876fd01dc6570198dbcf8dee9cb6325f9237c4308`。

免费ARM上的任何成功均需在950实机上使用同样方法复验。最终生产工具链
（GCC/毕昇/Clang）、向量宽度、缓存、内存及CPU频率均可能影响收益。

## 复现

在本实验仓库的指定工作流提交上运行GitHub Actions即可重放。手动操作时，
先获取基线的干净源码，再生成候选：

```sh
git clone https://github.com/intel/isa-l.git baseline
git -C baseline checkout 8fa1e72fee7338fcfbf829b00f2f407631bd2dba
python3 experiments/ec-sve/generate_candidates.py baseline candidate adaptive
cd candidate
./autogen.sh
./configure CFLAGS='-O3 -g'
make -j"$(nproc)"
make erasure_code/erasure_code_perf
make check
```

请在同一台机器相同CPU上交替运行baseline/candidate，不能比较两次云实例的
绝对MB/s。完整命令及原始日志命名见`run_validation.sh`。
