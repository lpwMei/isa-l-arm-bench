# eBPF Tracer — crc16_xmodem() len Distribution

实时追踪 `crc16_xmodem()` 函数的 `len` 参数分布，帮助理解工作负载
特征、验证 dispatch 阈值（16 / 64 字节切分）是否合理。

## 两种使用方式

| 方式 | 命令 | 适用场景 |
|------|------|----------|
| **bpftrace（快速）** | `sudo bpftrace crc16_len_dist.bt ./crc16_xmodem_bench` | 快速验证，无需编译 |
| **C + libbpf（完整）** | `make && sudo ./crc16_len_dist ./crc16_xmodem_bench` | 完整直方图 + 百分位 |

## 前提条件

### 内核要求
- Linux ≥ 5.15（推荐 6.0+）
- 启用 BTF: `CONFIG_DEBUG_INFO_BTF=y`（检查：`ls /sys/kernel/btf/vmlinux`）
- 启用 BPF uprobe: `CONFIG_UPROBES=y`

### AARCH64 依赖安装（Debian / Ubuntu）
```bash
sudo apt install -y \
    clang llvm \
    libbpf-dev \
    linux-tools-$(uname -r) \
    linux-headers-$(uname -r) \
    libelf-dev zlib1g-dev \
    bpftrace   # 可选，用于快速脚本
```

### 验证 BTF 支持
```bash
ls /sys/kernel/btf/vmlinux   # 应存在
bpftool btf dump file /sys/kernel/btf/vmlinux format c | head  # 应输出 C 类型定义
```

## 编译与运行

### 方式一：编译版（推荐）

```bash
# 编译（自动生成 vmlinux.h）
cd ebpf/
make

# 运行（需要 root 权限）
sudo ./crc16_len_dist ../crc16_xmodem_bench
```

输出示例：
```
Found 'crc16_xmodem' at offset 0x1234 in /path/to/crc16_xmodem_bench
Uprobe attached: /path/to/crc16_xmodem_bench+0x1234 → crc16_xmodem
Monitoring 8 CPUs, refresh every 2s.  Ctrl+C to stop.

──── crc16_xmodem() len distribution ──── total: 123456 (+45678) ────

  Power-of-2 buckets:
  Range            Count    Pct  Bar
  ────────────  ──────────  ──────  ────────────────────────────────────────
        1              45   0.0%
        2             120   0.1%
     3- 4            890   0.7%
     5- 8           2345   1.9%  █
    9- 16          12300  10.0%  █████
   17- 32          23400  19.0%  █████████
   33- 64          34500  28.0%  ██████████████
  65-128          28000  22.7%  ███████████
 129-256          12000   9.7%  ████
 257-512           6000   4.9%  ██
 513-1K            2000   1.6%
   1K-4K           1500   1.2%
    4K+             356   0.3%
  ...
```

### 方式二：bpftrace 快速版

```bash
sudo bpftrace crc16_len_dist.bt ./crc16_xmodem_bench
```

按 Ctrl+C 退出时打印汇总。

## 命令行参数

```
sudo ./crc16_len_dist <binary> [function] [interval]

  binary     ELF 二进制文件路径（需包含符号表，不能 strip）
  function   要探测的函数名（默认: crc16_xmodem）
  interval   刷新间隔，秒（默认: 2）
```

### 探测不同函数

```bash
# 只追踪 PMULL 路径
sudo ./crc16_len_dist ../crc16_xmodem_bench crc16_xmodem_pmull

# 只追踪 short NEON 路径
sudo ./crc16_len_dist ../crc16_xmodem_bench crc16_xmodem_short

# 同时追踪（需要两个终端窗口分别运行）
```

## 输出说明

### Power-of-2 直方图
按 2 的幂次分桶：1, 2, 3-4, 5-8, 9-16, 17-32, …, 4K+

**用途**：快速定位 len 的数量级分布，识别主要工作负载区间。

### Linear 直方图
按 16 字节步进分桶：0-15, 16-31, 32-47, …, 176-191, 192+

**用途**：精细观察 dispatch 边界（16 和 64 字节）附近的分布。

### Dispatch 统计（bpftrace 版）
直接显示走 scalar / short / pmull 路径的调用比例。

**用途**：验证 dispatch 阈值是否合理——如果 >90% 走 scalar，
可能需要降低 PMULL 的最小长度阈值。

### 百分位（P50/P90/P95/P99）
**用途**：SLA 分析，了解大多数请求的 len 落在什么范围。

## 实现原理

```
                   ┌─────────────────────────────────┐
                   │          用户空间               │
                   │                                 │
                   │  crc16_len_dist (loader)        │
                   │    ├─ ELF 解析找函数偏移         │
                   │    ├─ libbpf 加载 BPF 程序       │
                   │    ├─ uprobe attach              │
                   │    └─ perf_buffer__poll() 读取   │
                   │       采样 → 刷新直方图          │
                   └──────────────┬──────────────────┘
                                  │ perf event
                   ┌──────────────▼──────────────────┐
                   │          内核空间 (eBPF)         │
                   │                                 │
                   │  uprobe_crc16 (uprobe handler)  │
                   │    ├─ 读取 pt_regs.regs[2] (x2) │
                   │    │  → 得到 len 参数            │
                   │    ├─ 更新 p2_hist (percpu)      │
                   │    ├─ 更新 lin_hist (percpu)     │
                   │    ├─ 更新 total_cnt (percpu)    │
                   │    └─ perf_event_output (采样)   │
                   └─────────────────────────────────┘
```

**关键点**：
- AARCH64 AAPCS64 调用约定：第 3 个参数（`len`）在 `x2` 寄存器
- uprobe 触发时，`pt_regs` 保存了用户态寄存器快照
- `BPF_CORE_READ(regs, regs[2])` 通过 CO-RE 重定位读取 `x2`
- per-CPU 数组避免锁竞争，用户态读取时自动求和

## 常见问题

### Q: `Failed to load BPF program: Permission denied`
需要 root 或 `CAP_BPF + CAP_PERFMON` 能力：
```bash
sudo setcap cap_bpf,cap_perfmon,cap_sys_admin+ep ./crc16_len_dist
```

### Q: `Symbol 'crc16_xmodem' not found`
二进制被 strip 了，需要保留符号表：
```bash
# 重新编译，不加 -s 或 strip
make clean && make
# 验证符号存在
nm ./crc16_xmodem_bench | grep crc16_xmodem
```

### Q: `Cannot resolve path` 或 `uprobe attach failed`
确保使用绝对路径（`realpath` 会自动处理）：
```bash
sudo ./crc16_len_dist $(realpath ../crc16_xmodem_bench)
```

### Q: bpftrace 报 `Unknown variable: arg2`
某些 bpftrace 版本在 uprobe 上对 `argN` 支持不完整，
改用寄存器直接读取（脚本里已有注释行，取消注释即可）。

### Q: 看不到任何事件
确认目标函数实际被调用了：
```bash
# 一边跑 benchmark，一边观察
sudo ./crc16_len_dist ./crc16_xmodem_bench &
./crc16_xmodem_bench   # 在另一个终端触发
```
