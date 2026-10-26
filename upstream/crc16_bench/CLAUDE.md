# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Build and Test Commands

```bash
make          # Build all binaries
make test     # Run correctness tests
make bench    # Run performance benchmarks
make clean    # Clean build artifacts
```

The benchmark binary supports flags:
- `./crc16_xmodem_bench --test` — correctness tests only
- `./crc16_xmodem_bench` — performance benchmarks only
- `./crc16_bench` — original table-driven baseline

## Architecture Overview

This is an AARCH64 NEON/PMULL optimization benchmark for XMODEM CRC16 (polynomial 0x1021). The key architectural pattern is a **three-tier dispatch system** that routes based on input buffer size:

```
crc16_xmodem() [dispatch.c]
  ├─ len < 16    → scalar table-driven (inline, no function call)
  ├─ len < 64    → crc16_xmodem_short() [short.S]
  └─ len >= 64   → crc16_xmodem_pmull() [pmull.S]
```

The dispatch thresholds are tuned for the PMULL setup overhead — small buffers are faster with scalar, medium buffers use the short NEON path, large buffers use the full 4-way PMULL folding loop.

## Assembly Implementation Variants

Multiple PMULL implementations exist for benchmarking/comparison:

- **crc16_xmodem_pmull.S** — 4-way PMULL (production). Best for < 4KB.
- **crc16_xmodem_pmull_8way.S** — 8-way PMULL (experimental). Higher throughput at 64KB+, but worse at small sizes due to frontend pressure.
- **crc16_xmodem_pmull_opt.S** — 2× unrolled variant of 4-way. No benefit, kept for reference.
- **crc16_xmodem_short.S** — Lightweight NEON path for 16-63 byte buffers.

All assembly uses the same GF(2) polynomial folding algorithm: CRC16 is treated as a 32-bit polynomial (shifted left 16), then reduced via PMULL folding constants and Barrett reduction. Constants are precomputed in `crc16_xmodem_constants.h`.

## Key Technical Details

**Calling convention**: All assembly functions follow AAPCS64:
- `x0` = seed (uint16_t, upper bits ignored)
- `x1` = buffer pointer
- `x2` = length
- Returns CRC16 in `x0`

**Dispatch invariants**:
- `crc16_xmodem_short` assumes `len >= 16` (caller enforces)
- `crc16_xmodem_pmull` assumes `len >= 64` (caller enforces)
- `crc16_xmodem` is the only public entry point

**Platform requirements**: ARMv8.0-A with CRC + Crypto extensions (PMULL instruction). Use the pure C fallback (`crc16_bench.c`) on other platforms.
