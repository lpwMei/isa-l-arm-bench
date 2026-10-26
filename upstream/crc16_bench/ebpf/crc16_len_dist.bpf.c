// SPDX-License-Identifier: GPL-2.0
/*
 * crc16_len_dist.bpf.c — eBPF uprobe: capture `len` distribution
 *                         from crc16_xmodem(seed, buf, len).
 *
 * On AARCH64, the 3rd argument (len) is passed in register x2.
 * We build two histograms in-kernel:
 *   1. Power-of-2 buckets  (1, 2, 4, …, 4096, 4096+)
 *   2. Linear 16-byte buckets (0–15, 16–31, …, 176–191, 192+)
 *
 * A perf-event stream sends sampled (len, tgid, pid) tuples so
 * userspace can also show per-process breakdowns or raw traces.
 */

#include "vmlinux.h"
#include <bpf/bpf_helpers.h>
#include <bpf/bpf_tracing.h>
#include <bpf/bpf_core_read.h>

/* ---- tunables ---- */
#define P2_BUCKETS      13          /* 2^0 … 2^12, plus overflow       */
#define LIN_BUCKETS     12          /* 16-byte steps up to 192+        */
#define LIN_BUCKET_SIZE 16

/* ---- maps ---- */

/*
 * Power-of-2 histogram (per-CPU → no atomics needed).
 * The uprobe handler runs to completion on one CPU without preemption,
 * so a plain increment on the per-CPU slot is safe.
 */
struct {
    __uint(type, BPF_MAP_TYPE_PERCPU_ARRAY);
    __uint(max_entries, P2_BUCKETS);
    __type(key,   __u32);
    __type(value, __u64);
} p2_hist SEC(".maps");

/* Linear histogram (per-CPU). */
struct {
    __uint(type, BPF_MAP_TYPE_PERCPU_ARRAY);
    __uint(max_entries, LIN_BUCKETS);
    __type(key,   __u32);
    __type(value, __u64);
} lin_hist SEC(".maps");

/* Total invocation count (single-element per-CPU array). */
struct {
    __uint(type, BPF_MAP_TYPE_PERCPU_ARRAY);
    __uint(max_entries, 1);
    __type(key,   __u32);
    __type(value, __u64);
} total_cnt SEC(".maps");

/* Perf-event buffer — sampled (len, pid, tgid) per call. */
struct {
    __uint(type,        BPF_MAP_TYPE_PERF_EVENT_ARRAY);
    __uint(key_size,    sizeof(__u32));
    __uint(value_size,  sizeof(__u32));
} events SEC(".maps");

/*
 * CPU filter — single-element array.
 *   target_cpu[0] = N   → only record events on CPU N
 *   target_cpu[0] = -1  → record on all CPUs (default, no filter)
 *
 * Written by userspace before the uprobe starts firing.
 */
struct {
    __uint(type, BPF_MAP_TYPE_ARRAY);
    __uint(max_entries, 1);
    __type(key,   __u32);
    __type(value, __u32);
} target_cpu SEC(".maps");

/* ---- event payload ---- */
struct sample {
    __u64 len;
    __u32 tgid;
    __u32 pid;
};

/* ---- helpers ---- */

/*
 * Power-of-2 bucket index: floor(log2(len)).
 *
 *   len=0 → bucket 0
 *   len=1 → 0,  len=2 → 1,  len=3 → 1,  len=4 → 2, …
 *   len >= 4096 → last bucket (overflow)
 *
 * Implemented as a binary-search ladder to keep BPF instruction count low.
 * __always_inline is mandatory — BPF does not support function calls from
 * kprobe/uprobe programs (unless the kernel supports BPF-to-BPF calls and
 * the verifier can follow them, but inlining is always safer here).
 */
static __always_inline __u32 p2_bucket(__u64 len)
{
    if (len == 0)
        return 0;
    if (len >= (1ULL << 12))
        return P2_BUCKETS - 1;       /* 4096+ → overflow bucket */

    __u32 idx = 0;
    if (len >= (1ULL << 8)) { idx += 8; len >>= 8; }
    if (len >= (1ULL << 4)) { idx += 4; len >>= 4; }
    if (len >= (1ULL << 2)) { idx += 2; len >>= 2; }
    if (len >= (1ULL << 1)) { idx += 1;             }
    return idx < P2_BUCKETS ? idx : P2_BUCKETS - 1;
}

static __always_inline __u32 lin_bucket(__u64 len)
{
    __u32 idx = (__u32)(len / LIN_BUCKET_SIZE);
    return idx < LIN_BUCKETS ? idx : LIN_BUCKETS - 1;
}

/* ---- uprobe handler ---- */

/*
 * Attach this to the ENTRY of crc16_xmodem() via uprobe.
 *
 * BPF_KPROBE gives us `ctx` — the BPF program context, which for
 * kprobe/uprobe programs is `struct pt_regs *` from the kernel's
 * perspective.  We use PT_REGS_PARM3_CORE to read x2 (the third
 * argument = len) with CO-RE relocation safety.
 *
 * Register mapping (AAPCS64):
 *   x0 = seed (uint16_t, upper bits ignored)
 *   x1 = buf  (const uint8_t *)
 *   x2 = len  (uint64_t)         ← we read this
 */
SEC("uprobe/crc16_xmodem")
int BPF_KPROBE(uprobe_crc16)
{
    __u64 len;
    __u32 key;
    __u64 *val;

    /* ---- CPU filter ---- */
    key = 0;
    __u32 *cpu_filter = bpf_map_lookup_elem(&target_cpu, &key);
    if (cpu_filter && *cpu_filter != (__u32)-1) {
        if (bpf_get_smp_processor_id() != *cpu_filter)
            return 0;   /* skip: not on the target CPU */
    }

    /* Read x2 (len) via CO-RE.  PT_REGS_PARM3_CORE maps to:
     *   ARM64:  ((struct pt_regs *)ctx)->regs[2]
     *   x86_64: ((struct pt_regs *)ctx)->di  (third arg = rdx, but
     *           libbpf uses the pt_regs accessor which handles this)
     *
     * The BPF verifier resolves the actual offset from vmlinux BTF
     * at load time, so this is portable across kernel versions.
     */
    len = PT_REGS_PARM3_CORE(ctx);

    /* ---- update power-of-2 histogram ---- */
    key = p2_bucket(len);
    val = bpf_map_lookup_elem(&p2_hist, &key);
    if (val)
        (*val)++;

    /* ---- update linear histogram ---- */
    key = lin_bucket(len);
    val = bpf_map_lookup_elem(&lin_hist, &key);
    if (val)
        (*val)++;

    /* ---- increment total count ---- */
    key = 0;
    val = bpf_map_lookup_elem(&total_cnt, &key);
    if (val)
        (*val)++;

    /* ---- send sample to userspace via perf buffer ---- */
    struct sample s = {
        .len  = len,
        .tgid = bpf_get_current_pid_tgid() >> 32,
        .pid  = bpf_get_current_pid_tgid() & 0xFFFFFFFF,
    };
    bpf_perf_event_output(ctx, &events, BPF_F_CURRENT_CPU, &s, sizeof(s));

    return 0;
}

char LICENSE[] SEC("license") = "GPL";
