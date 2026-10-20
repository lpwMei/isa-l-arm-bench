# ISA-L native ARM benchmarks

使用 GitHub Actions 的 `ubuntu-24.04-arm` 免费标准 runner，运行公开 ISA-L 源码的官方 benchmark。虚拟机随作业启动，结束后自动释放。

## 已完成的实验

- [成功运行 #2](https://github.com/lpwMei/isa-l-arm-bench/actions/runs/39422044652)
- [完整结果与分析](RESULTS-2026-10-20.md)
- [35项基准汇总 CSV](summary.csv)
- [工作流](https://github.com/lpwMei/isa-l-arm-bench/blob/codex/isa-l-arm-benchmark/.github/workflows/isa-l-arm-benchmark.yml)

环境为 Neoverse-N2、4 vCPU、约16GB内存，支持 SVE/SVE2，默认向量长度128位。使用 GCC 13.3.0，固定 CPU 0，5轮交替运行稳定版与固定主干快照。

两版各17项 `make check` 全部通过；共取得350个吞吐值。主干的 EC 10+2 编码提高30.46%，EC 10+4/6/7 编码下降约13%~15%，CRC32C 64B下降21.84%，六项 inflate 基准基本持平。

以上是既有上游版本的比较，没有新增优化补丁；也不代表鲲鹏950的性能结果。下一步可针对 CRC 短包调度、EC 输出分组与寄存器压力、inflate 回溯复制进行专项实验。

## 范围

本轮覆盖 CRC、EC 编码/恢复、raw DEFLATE 解压。完整 ZIP 解包、EC update、Crypto 继承补丁与 Redis Cluster CRC16 需要专项测试。

原始环境、构建、正确性及性能日志见成功运行页面的 artifact（保留7天）。更完整的出处、版本 SHA、测量口径和局限见结果报告。
