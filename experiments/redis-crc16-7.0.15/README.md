# Redis 7.0.15 CRC16 优化交付

当前主补丁为 `dispatch/redis-7.0.15-crc16-dispatch-fixed.patch`，当前验证报告为 `dispatch/完整dispatch复测报告.md`。按用户要求统一进入上游原样dispatch，仅追加已获同意的short尾部正确性修复；8way保留，但上游dispatch本身没有选择8way的规则。950手测目录manual/bin/redis-server-optimized已更新为此版本，旧4way版本备份为redis-server-optimized.4way-previous。

当前指定口径：以 `手动测试步骤.md` 的两条短命令为准，只用-n延长运行。`manual_test.sh` 已同步改为固定64B key，去掉额外预热和随机key空间。旧6轮吞吐结果和旧火焰图保留为历史工况，不与当前口径混用；旧负载长测已停止，未完成验收。

旧4way-only补丁：`redis-7.0.15-kp950-crc16-pmull.patch`，仅为历史对照。
客户端独立补丁：`redis-7.0.15-benchmark-64bit.patch`，用于正确执行 `-n 10000000000`。
结论、原始结果及尚未完成项见 `测试报告.md`；`sha256.json` 对源码归档、补丁、脚本及原始结果快照提供校验。

## 应用补丁

```bash
mkdir redis-7.0.15
tar -xzf redis-7.0.15-pristine.tar.gz -C redis-7.0.15
cd redis-7.0.15
git apply --check ../dispatch/redis-7.0.15-crc16-dispatch-fixed.patch
git apply ../dispatch/redis-7.0.15-crc16-dispatch-fixed.patch
make -j8
# 如需 100 亿请求客户端：
git apply ../redis-7.0.15-benchmark-64bit.patch
make -j8
# 编译关闭优化：
make -j8 CRC16_PMULL=no
```

PMULL只在Linux AArch64小端构建启用；运行时检查HWCAP_PMULL。支持时所有非负长度进入上游dispatch：<16查表、16–63走short、>=64走4way；其他平台回退原算法。Redis配置文件不新增开关。

## 实测目录与进度

服务器：`192.168.90.158`。
工作目录：`/home/liupengwei/redis-crc16-20261026`。
当前复测容器：`redis-crc16-dispatch-20261026`，完成后停止。
当前Redis测试端口36381，总线端口46381，仅监听本机。完整dispatch构建与复测工作目录为`/home/liupengwei/redis-crc16-20261026/dispatch-work`。

root 只启动了专用容器，未改变账号组权限；镜像为机器已有的 openEuler 24.03 LTS SP3，执行身份 UID/GID 1007。容器只读根目录，仅绑定本次工作目录，丢弃全部 capabilities，未挂载 Docker socket。

```bash
ssh 192.168.90.158 'cat /home/liupengwei/redis-crc16-20261026/dispatch-work/build-results/status.txt'
ssh 192.168.90.158 'cat /home/liupengwei/redis-crc16-20261026/dispatch-work/profile-results/status.txt'
```

`results/endurance/status.txt` 为 PASS 才代表四项 100 亿请求长测全部完成；`endurance.exit` 非零表示长测失败，`final-run.exit` 非零表示构建、回归或长测链路失败。长测未结束前不会生成 PASS。

`fetch_results.ps1` 手动刷新本地原始数据并重生成报告，需要已配置的 SSH 密钥与 Python；它不创建自动化或定时任务。

原始数据以 `results/repeated/measurements.json` 为主表，`pilot` 为初测，`client4` 为四线程客户端补充。第一次启动因端口占用失败的日志保留在 `repeated-attempt1`；未纳入有效样本。所有六轮有效样本，包括出现回退的一轮，都保留在报告中。

## 复现脚本

- `prepare_dispatch_patch.py`：重生成当前完整dispatch组合补丁、原样对照补丁及独立尾部修复，需要相邻upstream源码树。
- `build_dispatch.sh`：构建当前版本、运行完整正确性/路由/槽位/原生回归验证，随后执行指定短命令。
- `dispatch/summarize_dispatch.py`：验证新复测输出并生成当前报告。
- `prepare_patch.py`：仅用于重现旧4way-only历史补丁，不用于当前版本。
- `build_validate.sh` / `validate_crc16.c`：构建并运行差分、保护页、硬件回退、微基准。
- `benchmark_counter_test.c`：直接编译实际客户端源文件，验证 100 亿请求解析和跨 32 位计数边界。
- `run_e2e.py`：独立端口单节点集群、功能检查、交替 A/B 测量和 INFO 计数核验。
- `run_container.sh` / `run_measurements.sh`：初测和正式 6 轮主测量，以及四线程客户端补充。
- `run_final.sh`：关闭优化完整构建、原生回归、100 亿请求长测。
- `run_endurance.sh`：原版 SET/GET、优化版 SET/GET，各 100 亿请求。

当前dispatch脚本约定容器目录/manual，源码为source，构建验证在build-results，短命令输出在short-command-results，perf在profile-results。历史脚本使用/work及baseline/candidate目录。CPU编号固定为本次950的绑核选择；迁移机器应相应调整。

交付快照可能早于服务器长测结束。实测存在 32GB DIMM、当前 10Gb/s 链路、本机 TCP、未指定 ICIT 镜像等与完整典配的差异，详见报告。
