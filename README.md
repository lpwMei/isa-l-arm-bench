# ISA-L native ARM benchmarks

本仓库分别保存Neoverse-N2上的ISA-L EC实验，以及鲲鹏950上的Redis CRC16实验；两类机器、工作负载和测量口径分开记录。

## 2026-10-26：鲲鹏950 Redis CRC16阶段成果

当前实现为Redis 7.0.15接入指定上游的完整dispatch，保留上游分发规则，仅增加经确认的short尾部正确性修复。

- [阶段索引与验收边界](CHECKPOINT-2026-10-26.md)
- [当前完整dispatch复测报告](experiments/redis-crc16-7.0.15/dispatch/完整dispatch复测报告.md)
- [当前组合补丁](experiments/redis-crc16-7.0.15/dispatch/redis-7.0.15-crc16-dispatch-fixed.patch)
- [独立short尾部修复](experiments/redis-crc16-7.0.15/dispatch/redis-7.0.15-crc16-short-tail-fix.patch)
- [手动复测步骤及固定短命令](experiments/redis-crc16-7.0.15/手动测试步骤.md)
- [完整交付ZIP](experiments/redis-crc16-7.0.15-delivery.zip)
- [950实测二进制及测试程序](deliverables/redis-crc16-kp950-20261026/github-checkpoint-binaries.tar.gz)
- [全部文件SHA256清单](CHECKPOINT-MANIFEST-2026-10-26.json)

当前验证：各362,327个PMULL/硬件回退/标量差分用例、65,792个多seed用例、129个分发路由用例、34个实际Redis槽位用例及原生cluster/string/keyspace回归通过。同一固定短命令的原版/新版本SET/GET各1亿请求已完成。

| 当前一轮带perf复测 | 原版ops/s | 完整dispatch修复版ops/s | 原版CRC用户态cycles | 修复版CRC相关栈用户态cycles |
|---|---:|---:|---:|---:|
| SET | 1,086,791.12 | 1,303,237.25 | 25.24% | 0.45% |
| GET | 1,227,189.62 | 1,481,591.12 | 30.15% | 0.60% |

以上是单轮、包含perf采样开销的结果，不作为多轮稳定收益结论。100亿请求旧负载已因切换口径终止；ICIT指定镜像、64GB DIMM、双100GE外部压测尚未完成验收。

火焰图：[原版SET PNG](experiments/redis-crc16-7.0.15/dispatch/test-results/dispatch-work/profile-results/baseline-set.png)、[原版GET PNG](experiments/redis-crc16-7.0.15/dispatch/test-results/dispatch-work/profile-results/baseline-get.png)、[修复版SET PNG](experiments/redis-crc16-7.0.15/dispatch/test-results/dispatch-work/profile-results/optimized-set.png)、[修复版GET PNG](experiments/redis-crc16-7.0.15/dispatch/test-results/dispatch-work/profile-results/optimized-get.png)。同目录保留交互SVG、原始perf.data、解码栈和折叠栈；SVG可下载到浏览器中交互查看。

## EC 编码优化已完成云端验收

相对固定ISA-L主干，官方benchmark、同机交替七轮的编码吞吐中位数：

| 配置 | 提升 |
|---|---:|
| 10+4，64 KiB/块 | **17.95%** |
| 10+6，64 KiB/块 | **11.13%** |
| 10+7，64 KiB/块 | **15.99%** |

最终只改动一个C源文件中的4行。p=2及恢复保护项、两版各17项官方测试、
保护页reference检查、128/256/512位正确性检查均通过。4 KiB、1 MiB及额外
源数量的编码检查也超过10%。收益按重复试验中位数计算，单轮仍有波动。

- [完整EC报告](EC-RESULTS-2026-10-20.md)
- [可应用补丁](ec-sve-table4.patch)
- [EC主验收CSV](ec-summary.csv)
- [原始日志与环境证据](EC-EVIDENCE-2026-10-20.json)
- [预先固定的验收门限](ACCEPTANCE.md)
- [成功工作流](https://github.com/lpwMei/isa-l-arm-bench/actions/runs/39434973237)
- [实验代码及950复验脚本](https://github.com/lpwMei/isa-l-arm-bench/tree/codex/ec-sve-opt/experiments/ec-sve)

950须运行同样脚本重新验收，不能直接外推N2收益。更宽向量检查使用QEMU，
只用于正确性，不产生性能结果。ZIP解包、Crypto继承补丁尚未实施；Redis Cluster CRC16已进入上述独立的950阶段验证。

## 最初的上游版本对比

- [稳定版/固定主干成功实验](https://github.com/lpwMei/isa-l-arm-bench/actions/runs/39422044652)
- [完整结果与分析](RESULTS-2026-10-20.md)
- [35项基准汇总CSV](summary.csv)
- [原工作流](https://github.com/lpwMei/isa-l-arm-bench/blob/codex/isa-l-arm-benchmark/.github/workflows/isa-l-arm-benchmark.yml)

最初的350个吞吐值是既有上游版本之间的比较。当时观察到EC多路编码回退，
因此选为本次首项优化。该对比与本次补丁验收采用不同基线，不能混合计算提升。
