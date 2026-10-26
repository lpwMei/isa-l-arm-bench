# 2026-10-26 阶段性工作全量快照

本提交以既有EC阶段主分支为基准，补齐本地ISA-L项目已有工作。固定版本源码、多个候选实现、通过和失败的结果、报告、交付包、脚本、汇编及原始性能证据均保留。

## 当前Redis实现与入口

- [当前报告](experiments/redis-crc16-7.0.15/dispatch/完整dispatch复测报告.md)
- [当前完整dispatch＋short修复组合补丁](experiments/redis-crc16-7.0.15/dispatch/redis-7.0.15-crc16-dispatch-fixed.patch)
- [Redis侧实际接入代码](upstream/redis-7.0.15/src/crc16.c)
- [原样dispatcher](upstream/redis-7.0.15/src/crc16_xmodem_dispatch.c)
- [修复后的short汇编](upstream/redis-7.0.15/src/crc16_xmodem_short.S)
- [4way](upstream/redis-7.0.15/src/crc16_xmodem_pmull.S)、[8way](upstream/redis-7.0.15/src/crc16_xmodem_pmull_8way.S)、[opt](upstream/redis-7.0.15/src/crc16_xmodem_pmull_opt.S)
- [完整SHA256与上游版本](experiments/redis-crc16-7.0.15/dispatch/selected-import-manifest.json)
- [所有来源的Git提交与本地改动状态](maintenance/source-revisions.json)

上游来源为chenxuqiang2022/crc16_bench，提交f8e9dbea5bd065823f0f77532136851e1d25dd0c。dispatcher保持字节一致；原分支为<16B查表、16–63B short、>=64B 4way。8way/opt保留编译，上游dispatcher未选择8way。

原样short会对不足16B尾部补零后继续计算，造成部分输入CRC和槽位错误。17个a：正确CRC0xce74/槽3700，上游原样结果0x0217/槽535。已保留[原样失败日志](experiments/redis-crc16-7.0.15/dispatch/test-results/dispatch-results/upstream-dispatch-probe.txt)、[复现源码](experiments/redis-crc16-7.0.15/dispatch_probe.c)、[单独最小修复](experiments/redis-crc16-7.0.15/dispatch/redis-7.0.15-crc16-short-tail-fix.patch)和[修复后日志](experiments/redis-crc16-7.0.15/dispatch/test-results/dispatch-results/fixed-dispatch-probe.txt)。

## 当前复测口径

Redis单节点集群，全部槽位；固定64B key，200连接，pipeline16。原版/完整dispatch修复版共用客户端，只切换服务端；CPU340运行Redis，CPU342运行客户端。计时负载仅以下两条，扩大-n延长运行：

```bash
KEY=$(printf 'k%.0s' {1..64})
taskset -c 342 /manual/bin/redis-benchmark -p 36381 -c 200 -n 100000000 -P 16 SET "$KEY" xxx
taskset -c 342 /manual/bin/redis-benchmark -p 36381 -c 200 -n 100000000 -P 16 GET "$KEY"
```

四项各1亿请求完整结束，每项采集30秒DWARF调用栈。无额外预热、随机key空间或其他benchmark参数。当前结果仅针对本机TCP、共享主机、单轮带采样测试；不是完整典配或100亿请求验收通过。

原始证据：[构建与验证](experiments/redis-crc16-7.0.15/dispatch/test-results/dispatch-work/build-results/)、[原生benchmark输出](experiments/redis-crc16-7.0.15/dispatch/test-results/dispatch-work/short-command-results/)、[全部perf与火焰图](experiments/redis-crc16-7.0.15/dispatch/test-results/dispatch-work/profile-results/)。

## 历史演进与完整工作范围

| 目录 | 保存内容 |
|---|---|
| analysis | 初始950源码分析、固定来源清单、汇编分析输出 |
| cloud | 原生ARM云端基线工作流、汇总、原始日志、报告和截图 |
| experiments/ec-sve | EC候选实现、生成器、边界测试、多个版本源码、全部成功/失败实验、反汇编、向量长度检查及压缩归档 |
| experiments/redis-crc16-7.0.15 | 最初4way-only接入、不同负载的历史测量、固定短命令测量、完整dispatcher接入、所有报告/脚本/补丁/源码归档与原始perf |
| experiments/redis-crc16-7.0.15-delivery.zip | CRC16当前完整交付包 |
| deliverables/redis-crc16-kp950-20261026 | 950上实际测试的原版、旧4way版、完整dispatch版、共享CLI/benchmark、正确性验证可执行程序归档 |
| tools | 环境采集工具和固定版本FlameGraph源码（含原许可证） |
| downloads、releases、upstream | 当时保存的上游版本归档、完整源码参考；redis-7.0.15目录为当前已应用补丁的源码 |
| maintenance | 快照整理工具、来源Git提交和变更状态 |

历史报告按原样保留，因此含当时的绝对路径和已过时状态。当前实现与测试结论以本索引和dispatch报告为准，原始版本的证据不因新结论而删除。旧随机key负载的100亿请求长测已明确记为终止；旧19.21%/18.74%与旧吞吐中位数不混入当前工况。

## 复现与校验

[文件清单](CHECKPOINT-MANIFEST-2026-10-26.json)记录12,858个被归档文件、728,814,038字节及每个文件的SHA256；其余本次新写的索引和维护文件由Git对象校验。另保留CRC交付包自身的sha256.json。Git属性关闭换行归一化，以保持既有校验值有效。

完整Redis源码可以直接在目标AArch64环境编译。也可解压experiments/redis-crc16-7.0.15/redis-7.0.15-pristine.tar.gz，再应用当前组合补丁。100亿请求客户端需要单独的redis-7.0.15-benchmark-64bit.patch，历史和当前实测客户端已经使用该修复。

prepare_patch.py/prepare_dispatch_patch.py等历史重生成器依赖原环境中固定版本的Git checkouts。快照不复制嵌套.git数据库；需要重生成时，按source-revisions.json在独立目录恢复相应Git checkouts。直接编译已接入源码、或向原始归档应用组合补丁不需要这些嵌套Git数据库。

Git元数据、Python字节码和验证时临时安装的Python依赖缓存未归档。归档文件及直接压缩包成员已做凭据模式检查，未发现命中；未收录任何SSH账号凭据或私钥。
