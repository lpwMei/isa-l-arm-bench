# ISA-L native ARM benchmarks

使用免费的GitHub Actions `ubuntu-24.04-arm`运行原生AArch64实验。
当前机器为Neoverse-N2、SVE/SVE2 128位；本仓库不宣称鲲鹏950已经达标。

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
只用于正确性，不产生性能结果。ZIP解包、Crypto继承补丁与Redis Cluster CRC16
尚未实施；建议下一项先处理CRC短包路径。

## 最初的上游版本对比

- [稳定版/固定主干成功实验](https://github.com/lpwMei/isa-l-arm-bench/actions/runs/39422044652)
- [完整结果与分析](RESULTS-2026-10-20.md)
- [35项基准汇总CSV](summary.csv)
- [原工作流](https://github.com/lpwMei/isa-l-arm-bench/blob/codex/isa-l-arm-benchmark/.github/workflows/isa-l-arm-benchmark.yml)

最初的350个吞吐值是既有上游版本之间的比较。当时观察到EC多路编码回退，
因此选为本次首项优化。该对比与本次补丁验收采用不同基线，不能混合计算提升。
