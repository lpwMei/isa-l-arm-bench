"""Render the report from raw measurements; never infer an endurance PASS."""
import argparse
import hashlib
import json
from pathlib import Path
import statistics
from datetime import datetime, timezone, timedelta


def median(rows, variant, command, field):
    return statistics.median(r[field] for r in rows
                             if r["variant"] == variant and r["command"] == command)


def table(rows):
    text = ["| 操作 | 原版吞吐中位数（ops/s） | 优化版吞吐中位数（ops/s） | 提升 |",
            "|---|---:|---:|---:|"]
    for command in ["SET", "GET"]:
        base = median(rows, "baseline", command, "rps")
        opt = median(rows, "candidate", command, "rps")
        text.append(f"| {command} | {base:,.2f} | {opt:,.2f} | {(opt / base - 1) * 100:.2f}% |")
    return "\n".join(text)


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--results", type=Path, default=Path(__file__).parent / "results")
    args = parser.parse_args()
    results = args.results
    rows = json.loads((results / "repeated/measurements.json").read_text())
    assert (results / "repeated/status.txt").read_text().strip() == "PASS"
    assert len(rows) == 24 and all(r["requests"] == 10000000 for r in rows)
    now = datetime.now(timezone(timedelta(hours=8))).isoformat(timespec="seconds")
    endurance = results / "endurance/status.txt"
    full_pass = endurance.exists() and endurance.read_text().strip() == "PASS"
    full_status = "已完成，结果见 results/endurance/measurements.json。" if full_pass else (
        "尚未完成，不能判定 100 亿请求验收通过。服务器已配置逐项执行原版 SET、原版 GET、"
        "优化版 SET、优化版 GET，每项 100 亿请求；状态以 results/endurance/status.txt 的 PASS 为准。")
    if (results / 'endurance-cancel-reason.txt').exists():
        full_status = "旧负载长测已按用户切换工况要求终止，未完成100亿请求验收。当前指定短命令的独立复测见短命令复测报告.md。"
    fallback_ok = (results / "fallback-build.status").exists()
    regression_ok = (results / "redis-regression.status").exists()
    report = f"""# Redis 7.0.15 CRC16 / 鲲鹏 950 实测报告

生成时间：{now}。服务器：192.168.90.158。

## 结论与验收状态

已在 Kunpeng 950 7592C 的 openEuler 24.03 LTS SP3 单容器中，完成 CRC16 优化集成、正确性检查及单节点集群端到端对比。下列数字来自每项 1,000 万请求、6 轮交替测试，不能替代尚未完成的 100 亿请求长测。

{table(rows)}

100 亿请求长测：{full_status}

指定 ICIT 镜像未提供；本次使用服务器已有的 openEuler C++ 镜像，容器内系统确认为同版 SP3。该结果可证明所列实测环境下的功能与吞吐，完整典配验收仍有下列差异。

## 环境与典配差异

| 项目 | 实测配置 |
|---|---|
| CPU | 2 × HiSilicon Kunpeng 950 7592C；192 物理核 / 384 逻辑 CPU；PMULL 可用 |
| 宿主 OS | openEuler 24.03 LTS SP3；内核 6.6.0-132.0.0.111.oe2403sp3.aarch64 |
| 容器 OS / 镜像 | openEuler 24.03 LTS SP3；openeuler-cpp:24.03，完整镜像 ID 见 container-image.txt |
| 编译器 | 容器 GCC 12.3.1，openEuler 12.3.1-105.oe2403sp3 |
| Redis | 7.0.15；默认 -O2；jemalloc 5.2.1；两版构建参数一致，仅 CRC16 优化不同 |
| 内存 | 24 × 32 GB，5600 MT/s；与需求的 64 GB DIMM 不同 |
| 磁盘 | HWE72P457T6L004N NVMe，约 7 TiB；测试关闭持久化 |
| 网路 | 本机 127.0.0.1 TCP，host network；活动物理接口当前链路 10 Gb/s，未验证 2 × 100GE |
| 身份 | root 仅启动容器；编译、Redis 和客户端均 UID/GID 1007；未修改 docker 组权限 |
| 容器资源 | cpuset 320,322,324,326,328,330,332,334；8 GiB；pids-limit 256 |
| 绑核 | Redis CPU 320；客户端允许 CPU 322,324,326,328；相邻 SMT 线程未由本测试使用 |
| 并行负载 | 共享服务器存在其他业务；没有独占物理核或锁定全机频率 |

原始硬件证据见 results/environment.txt、dimm-summary.txt、cpu-load-sample.txt。此测试不覆盖跨机网络吞吐或 NVMe 持久化性能。

## 源码与集成

- Redis 基线：官方 7.0.15，提交 f35f36a265403c07b119830aa4bb3b7d71653ec9。
- 优化来源：https://gitee.com/chenxuqiang2022/crc16_bench ，提交 f8e9dbea5bd065823f0f77532136851e1d25dd0c。
- 导入推荐的 crc16_xmodem_pmull.S 四路折叠实现，算法代码保持上游内容，补充其注明的 Arm BSD 来源声明和 GNU-stack 标记。
- Linux AArch64 小端构建默认启用，启动时读取 HWCAP_PMULL；长度 >= 64 且支持 PMULL 时进入汇编，其余保持 Redis 原表算法。没有全局增加 crypto 编译选项。
- 接口仍为 uint16_t crc16(const char *, int)，初始值 0，多项式 0x1021；哈希标签及槽位映射逻辑不变。负长度仍返回 0。
- make CRC16_PMULL=no 可关闭；其他平台保留原版路径。切换编译选项后由 Redis 原有构建机制重建。
- 不导入实验 8-way 或短缓冲汇编路径。本需求 64B key 使用四路实现；短 hash tag 继续走原算法，收益不能直接外推。

## 测试方法

单 Redis 实例开启 cluster-enabled，独占全部 0–16383 槽，cluster_known_nodes=1、cluster_state=ok。正式重复测量固定 127.0.0.1:36380（总线 46380）。初测使用 16380，一次后续启动遇到瞬态端口占用，失败日志保留在 repeated-attempt1；该次未产生吞吐样本，未纳入统计。

每版服务端相同绑核、端口、配置及预热；轮次顺序 AB / BA 交替。客户端始终使用同一个基线 CRC16 的二进制，避免客户端优化混入服务端收益。

并发连接 200，pipeline 16；key 严格为 64B，无 hash tag；value 64B。随机 keyspace 10,000，SET 后进行 GET；验证数据库中实际 key/value 长度及 GET 命中。默认单线程客户端，不设置 --cluster：Redis 7.0.15 的该选项拒绝单节点集群，且会用短 hash tag；直接连接持有全部槽的单实例仍真实执行服务端集群 CRC16 路径。

原生 -d 64 设置 value 长度，不能满足 key 64B。故使用原生自定义命令模式分别执行 SET / GET，完整参数记录在每项 .command.json：

```bash
KEY=$(printf 'k%.0s' {{1..52}})__rand_int__  # 52 + 12 = 64 bytes
VALUE=$(printf 'v%.0s' {{1..64}})
taskset -c 322,324,326,328 baseline/src/redis-benchmark \\
  -h 127.0.0.1 -p 36380 -c 200 -P 16 -n 10000000 -r 10000 --csv SET "$KEY" "$VALUE"
taskset -c 322,324,326,328 baseline/src/redis-benchmark \\
  -h 127.0.0.1 -p 36380 -c 200 -P 16 -n 10000000 -r 10000 --csv GET "$KEY"
```

每轮每版每项 1,000 万请求，共 24 个计时样本、2.4 亿计时请求；每项另有 20 万预热请求，不计入吞吐样本。统计量为两组吞吐中位数的比值减一。server INFO 计数交叉核验实际命令数，并断言计时阶段无新增错误回复。

## 功能与回归

- PMULL 路径、屏蔽 HWCAP_PMULL 的真实调度回退、完全不编译 PMULL 的标量路径，各 362,327 个差分用例通过，共 1,086,981 个。
- 验证 XMODEM 标准向量 123456789 → 0x31c3，全部 65,536 个双字节组合，0–4096 全长度 × 64 种偏移，随机及 1MiB 输入，固定二进制模式、零/负长度；缓冲区前后 PROT_NONE 页面检查越界读。
- 每次实例启动验证 1,039 个 key 的 CLUSTER KEYSLOT，与 Python binascii.crc_hqx 参考结果一致；覆盖空 key、NUL/高位字节、长 key、空/嵌套/不完整 hash tag。
- 二进制 key/value 的 pipeline SET/GET、GET miss、同槽多 key 操作、CROSSSLOT 错误语义通过。计时阶段没有新增错误回复，Redis 正常退出。
- 可执行栈检查 GNU_STACK 为 RW；关键反汇编、二进制 SHA256、编译日志已保存。
- 完整 CRC16_PMULL=no 构建：{'PASS（符号表中未链接 PMULL 实现）' if fallback_ok else '未确认完成'}。
- Redis 原生 unit/cluster、unit/type/string、unit/keyspace 回归：{'全部通过' if regression_ok else '未确认完成'}；详细输出见 redis-regression.log。原生 cluster 回归按 Redis 测试框架创建多个临时节点，仅用于回归检查；上述性能测试始终是单节点集群。

CRC16 微基准（同一 CPU，独立函数调用）：64B 原版 139.127ns，优化版 8.370ns，约 16.62 倍。该数字仅描述 CRC16 函数，与主表 Redis 端到端吞吐分开统计。

## 100 亿请求计数修复

Redis 7.0.15 原生客户端的 requests、issued、finished、previous 为 int，且 -n 使用 atoi；10000000000 会溢出。独立 client-only 补丁将请求计数及局部副本改为 long long，使用带范围校验的 strtoll，修改完成数输出格式；服务端优化补丁不包含此改动。

实际解析 -n 10000000000、issued 越过 INT32_MAX、finished 越过 UINT32_MAX、previous 接近 100 亿的原子计数测试均通过，非法值 0、负数、超界数和尾随非数字输入拒绝。两组正式测量共用修复后的同一个客户端。短样本的初测使用未修改计数的原生客户端，仅作为 pilot 保留，不并入正式 6 轮统计。

## 可复现与交付

服务器工作目录：/home/liupengwei/redis-crc16-20261026；本地包目录：experiments/redis-crc16-7.0.15。

```bash
# 在干净的 Redis 7.0.15 源码目录
git apply --check redis-7.0.15-kp950-crc16-pmull.patch
git apply redis-7.0.15-kp950-crc16-pmull.patch
make -j8
# 压测客户端另外应用 client-only 补丁；两组共用此客户端
git apply redis-7.0.15-benchmark-64bit.patch
make -j8
```

主补丁与工具补丁均以干净 7.0.15 为基准；原始源码压缩包、完整脚本及 SHA256 清单随包提供。服务器 results/endurance.log 记录长测进度，results/endurance/measurements.json 在每个 100 亿请求项目完成后写入；PASS 文件仅在全部 4 项完成且功能、错误数检查通过后生成。

## 适用范围

实测支持本次 64B key、64B value、200 连接、pipeline 16、本机 TCP、单节点集群、单线程 Redis 场景的吞吐改善。CRC16 微基准加速比不是 Redis 端到端收益。正式典配的 ICIT 镜像、64GB DIMM、双 100GE 外部压测及 100 亿请求长测，在相应证据齐备前均保留为未完成项。
"""
    client4 = results / "client4/measurements.json"
    if client4.exists() and (results / "client4/status.txt").exists():
        extra = json.loads(client4.read_text())
        report += "\n## 客户端四线程补充测量\n\n为检查单线程客户端限制，另做 2 轮四线程客户端对比；不并入主表。\n\n" + table(extra) + "\n"
    report += "\n## 主测量逐轮数据与波动\n\n所有有效样本均保留；未剔除回退轮次。共享服务器上没有实施独占 CPU 或频率控制，因此中位数收益不代表每轮都提高。\n\n"
    report += "| 轮次 | 操作 | 原版 ops/s | 优化版 ops/s | 变化 |\n|---|---|---:|---:|---:|\n"
    for roundnum in range(1, 7):
        for command in ["SET", "GET"]:
            pair = [r for r in rows if r["round"] == roundnum and r["command"] == command]
            base = median(pair, "baseline", command, "rps")
            opt = median(pair, "candidate", command, "rps")
            report += f"| {roundnum} | {command} | {base:,.2f} | {opt:,.2f} | {(opt / base - 1) * 100:+.2f}% |\n"
    report += "\n服务端每命令 CPU 时间由两次 INFO cpu 差值计算，包含主进程和后台线程，不是硬件 cycles。\n\n"
    report += "| 操作 | 原版 CPU µs/命令中位数 | 优化版 CPU µs/命令中位数 |\n|---|---:|---:|\n"
    for command in ["SET", "GET"]:
        values = []
        for variant in ["baseline", "candidate"]:
            values.append(statistics.median(
                (r["server_user_seconds"] + r["server_sys_seconds"]) * 1e6 / r["requests"]
                for r in rows if r["command"] == command and r["variant"] == variant))
        report += f"| {command} | {values[0]:.3f} | {values[1]:.3f} |\n"
    review = Path(__file__).parent / "收益与绑核复核.md"
    if review.exists():
        report += "\n## 后续复核：理论收益、采样与绑核\n\n" + review.read_text(encoding="utf-8").split("\n", 1)[1]
    flamegraph_review = Path(__file__).parent / "采样与火焰图.md"
    if flamegraph_review.exists():
        report += "\n## 参数对齐与带调用栈采样\n\n" + flamegraph_review.read_text(encoding="utf-8").split("\n", 1)[1]
    out = Path(__file__).parent / "测试报告.md"
    out.write_text(report, encoding="utf-8", newline="\n")
    print(table(rows))
    print("Endurance completed:", full_pass)
    manifest = {}
    for path in Path(__file__).parent.rglob("*"):
        if path.is_file() and path.name != "sha256.json" and "__pycache__" not in path.parts:
            manifest[path.relative_to(Path(__file__).parent).as_posix()] = hashlib.sha256(path.read_bytes()).hexdigest()
    (Path(__file__).parent / "sha256.json").write_text(json.dumps(manifest, indent=2, ensure_ascii=False), encoding="utf-8")


if __name__ == "__main__":
    main()
