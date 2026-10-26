# CRC16 XMODEM — AARCH64 NEON PMULL 优化实现

XMODEM CRC16（多项式 `0x1021`）的多种实现及性能对比，基于 ARM AARCH64 NEON/PMULL 指令集。

## 快速开始

```bash
make          # 编译所有目标
make test     # 正确性测试
make bench    # 性能基准测试
make clean    # 清理
```

## 实现版本

| 文件 | 算法 | 1MB 吞吐 | 说明 |
|------|------|----------|------|
| `crc16_bench.c` | 逐字节查表 | ~354 MB/s | 原始参考实现 |
| `crc16_xmodem_pmull.S` | 4-way PMULL 折叠 | **~20.4 GB/s** | ✅ 推荐生产版 |
| `crc16_xmodem_pmull_opt.S` | 2× 展开实验版 | ~20.4 GB/s | 无额外收益，仅供参考 |
| `crc16_xmodem_pmull_8way.S` | 8-way PMULL 折叠 | **~26.1 GB/s** | 实验版，小数据不如 4-way |

## 性能数据

测试平台：HiSilicon Kunpeng 920G, 2.3 GHz, AARCH64 (NEON/PMULL)

| 数据大小 | 原始查表 | 4-way PMULL | 8-way PMULL | 4-way 加速比 |
|----------|----------|-------------|-------------|-------------|
| 64 B | 454 MB/s | 7,366 MB/s | 7,187 MB/s | 16× |
| 256 B | 371 MB/s | 12,997 MB/s | 9,764 MB/s | 35× |
| 1 KB | 358 MB/s | 17,091 MB/s | 15,106 MB/s | 48× |
| 4 KB | 354 MB/s | 19,374 MB/s | 22,189 MB/s | 55× |
| 64 KB | 353 MB/s | 20,322 MB/s | 25,961 MB/s | 58× |
| 1 MB | 354 MB/s | 20,376 MB/s | 26,138 MB/s | 58× |

## API

```c
#include <stdint.h>

/* 4-way PMULL（推荐） */
uint16_t crc16_xmodem_pmull(uint16_t seed, const uint8_t *buf, uint64_t len);

/* 8-way PMULL（大数据更高吞吐） */
uint16_t crc16_xmodem_pmull_8way(uint16_t seed, const uint8_t *buf, uint64_t len);
```

- `seed`：初始 CRC 值（0 表示标准 XMODEM）
- `buf`：数据缓冲区
- `len`：缓冲区长度（字节）
- 返回值：16 位 CRC 值

## 算法原理

### 多项式

XMODEM CRC16 多项式：`x^16 + x^12 + x^5 + 1`（`0x1021`），MSB-first，无反射。

### PMULL 折叠

利用 ARM NEON `PMULL`/`PMULL2` 指令（GF⁡(2) 域上的无进位乘法）实现 CRC 计算的并行化：

1. **16→32 位扩展**：CRC16 左移 16 位视为 32 位多项式
2. **并行折叠**：将输入数据按 128-bit 块折叠，每次 `PMULL` 相当于 64-bit × 多项式常数
3. **Barrett 归约**：用预计算常数 `floor(x^48 / P)` 将 32 位结果规约为 16 位

### 4-way vs 8-way

- **4-way**：4 条独立累加器链，每次处理 64 字节。每条链的 PMULL 延迟由 3 条其他链部分隐藏。
- **8-way**：8 条独立累加器链，每次处理 128 字节。更多独立链更好地隐藏 PMULL 延迟，但循环体更大（前端取指压力增加）。

`perf stat` 微架构对比（1 MB 缓冲区）：

| 指标 | 4-way | 8-way |
|------|-------|-------|
| IPC | 3.21 | 3.64 |
| 后端停顿 | 9.15% | 0.97% |
| 前端停顿 | 0.44% | 18.46% |

4-way 瓶颈在 PMULL 执行后端，8-way 解决了后端瓶颈但引入前端取指压力。

## 文件结构

```
crc16_bench/
├── crc16_bench.c              # 原始逐字节查表实现
├── crc16_xmodem_pmull.S       # 4-way PMULL 汇编（推荐）
├── crc16_xmodem_pmull_opt.S   # 2× 循环展开实验版
├── crc16_xmodem_pmull_8way.S  # 8-way PMULL 汇编
├── crc16_xmodem_bench.c       # 正确性测试 + 性能基准
├── crc16_xmodem_constants.h   # GF(2) 预计算常数
├── Makefile
└── README.md
```

## 目标环境要求

- ARMv8.0-A + CRC + Crypto 扩展
- PMULL 指令（`FEAT_PMULL`）
- 已在 Kunpeng 920G 测试通过

如需在不支持 PMULL 的平台上运行，使用 `crc16_bench.c` 中的纯 C 查表实现。

## 参考

- [Fast CRC Computation for Generic Polynomials Using PCLMULQDQ](https://www.intel.com/content/dam/www/public/us/en/documents/white-papers/fast-crc-computation-generic-polynomials-pclmulqdq-paper.pdf)
- [ISA-L (Intel Intelligent Storage Acceleration Library)](https://github.com/intel/isa-l)
