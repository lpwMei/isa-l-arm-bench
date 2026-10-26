# ARM 云端实验准备

准备日期：2026-10-20。已在用户的 Mei（`lpwMei`）账户创建公有实验仓库，并启动原生 ARM 云端作业。

- 仓库：[lpwMei/isa-l-arm-bench](https://github.com/lpwMei/isa-l-arm-bench)
- 实验分支：`codex/isa-l-arm-benchmark`
- 运行记录：[ARM baseline #2](https://github.com/lpwMei/isa-l-arm-bench/actions/runs/39422044652)
- 工作流提交：`d25e0debbc0a3efba6cff911218ec6d21147bf20`
- 本地汇总器：`python cloud/summarize_results.py <解包后的results目录>`
- 完整实测报告：[ARM云端基准结果_2026-10-20.md](D:/codex/ISA-L/cloud/ARM云端基准结果_2026-10-20.md)
- 本轮已成功完成：Neoverse-N2 / 128位SVE，双版本各17项正确性测试通过，共350个性能测量值。

优先方案为 GitHub Actions 的 `ubuntu-24.04-arm` 标准 runner。官方列出公有仓库为真实 ARM64 虚拟机、4 vCPU / 16GB RAM，标准运行免费；私有仓库适用不同额度与计费规则。来源：[GitHub 官方 runner 说明](https://docs.github.com/en/actions/reference/runners/github-hosted-runners)。

`isa-l-arm-benchmark.yml` 是可审查的单文件工作流，需放到用户指定公有仓库的 `.github/workflows/isa-l-arm-benchmark.yml`，在 `codex/isa-l-arm-benchmark` 分支推送后运行。已有仓库的默认分支和业务代码无需修改。若目标仓库本身是 fork，可能需要用户先启用 Actions；还需仓库策略允许 ARM runner 和官方 artifact action。

运行内容：

- 使用原生 AArch64 Ubuntu；架构不符即停止。
- 只拉取公开的 ISA-L 两个固定 SHA：v2.32.1 和 2026-09-30 master 快照。
- 相同 GCC / `-O3 -g` 构建；每个版本先运行 `make check`。
- 自动选取进程允许使用的一个 CPU，5 轮交替运行官方 CRC、EC encode/decode、inflate benchmark。
- 记录 CPU 指令特性、NUMA、工具链、固定语料 SHA256、构建日志、正确性结果和全部性能原始输出。
- 作业最长 60 分钟；输出 artifact 保留 7 天。工作流仅在公有仓库运行，避免未经确认消耗私有 runner 付费额度。

这是第一轮 ARM 基线实验，未包含新的优化补丁、Crypto 继承补丁、完整 ZIP 解析或 Redis Cluster 测试。SVE/SVE2 路径是否可用由 VM 实测的指令特性决定；任何其他 ARM CPU 的结果都不能替代鲲鹏950验收。

其他可租用平台：

| 平台 | 已核实配置 | 使用条件 |
| --- | --- | --- |
| [华为云 kC2](https://support.huaweicloud.com/productdesc-ecs/zh-cn_topic_0178844867.html) | 鲲鹏920新型号；例如 `kc2.xlarge.2` 为 4vCPU/8GiB | 需要云账号、区域与库存；价格需在具体订单中核定，不能标作950 |
| [AWS C8g](https://aws.amazon.com/ec2/instance-types/c8g/) | Graviton4；例如 `c8g.xlarge` 为 4vCPU/8GiB | 需要 AWS 账号；按区域核价，另外核算磁盘/公网等资源 |
| [OCI Ampere A1](https://docs.oracle.com/en-us/iaas/Content/FreeTier/freetier_topic-Always_Free_Resources.htm) | 当前文档免费额度为每月1500 OCPU小时、9000 GB小时，约2 OCPU/12GB | 需要已验证账号及主区域可用容量；不能沿用旧宣传中的4核24GB额度 |

已确认当前 GitHub 连接可用，仓库、工作流和本轮 ARM 实测均已完成，结果已下载并校验。暂未配置 EC2/ECS 付费云资源连接。

使用付费云主机前应把区域、系统、机型、磁盘、公网、运行时长及预计费用整理成具体订单，再确认预算和创建；本草案无需购买云主机。
