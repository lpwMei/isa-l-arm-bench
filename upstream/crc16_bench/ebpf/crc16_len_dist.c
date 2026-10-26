// SPDX-License-Identifier: GPL-2.0
/*
 * crc16_len_dist.c — userspace loader for the crc16 len distribution tracer.
 *
 * Usage:
 *   sudo ./crc16_len_dist <path-to-binary> [function-name] [interval-sec]
 *
 * Examples:
 *   sudo ./crc16_len_dist ./crc16_xmodem_bench
 *   sudo ./crc16_len_dist ./crc16_xmodem_bench crc16_xmodem_pmull 5
 *   sudo ./crc16_len_dist /usr/lib/libfoo.so my_crc_func
 *
 * Requirements:
 *   - Linux >= 5.15 with BTF (CONFIG_DEBUG_INFO_BTF=y)
 *   - libbpf, libelf, zlib
 *   - Target binary must NOT be stripped (needs symbol table)
 *   - Run as root (CAP_SYS_ADMIN + CAP_BPF)
 */

#define _GNU_SOURCE
#include <argp.h>
#include <bpf/bpf.h>
#include <bpf/libbpf.h>
#include <elf.h>
#include <errno.h>
#include <fcntl.h>
#include <gelf.h>
#include <stdint.h>
#include <signal.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/stat.h>
#include <time.h>
#include <unistd.h>

#include "crc16_len_dist.skel.h"

/* ---- tunables ---- */
#define P2_BUCKETS      13
#define LIN_BUCKETS     12
#define LIN_BUCKET_SIZE 16
#define DEFAULT_INTERVAL 5

/* ---- globals ---- */
static volatile sig_atomic_t stopping;
static int verbose = 0;
static int summary_only = 0;

static const char *p2_labels[P2_BUCKETS] = {
    "      1", "      2", "   3- 4", "   5- 8",
    "   9- 16", "  17- 32", "  33- 64", "  65-128",
    " 129-256", " 257-512", "513-1K ", "  1K-4K ",
    "   4K+  "
};

/* ---- signal handling ---- */
static void sig_handler(int sig)
{
    (void)sig;
    stopping = 1;
}

/* ---- per-CPU map read helper ---- */

/*
 * Read a per-CPU array map element and sum across all CPUs.
 *
 * For BPF_MAP_TYPE_PERCPU_ARRAY the kernel stores one value per CPU.
 * A userspace bpf_map_lookup_elem copies ALL per-CPU values packed
 * into the output buffer — total = array->elem_size bytes, where
 * elem_size = round_up(value_size, 8) * num_possible_cpus().
 *
 * We allocate a generous static buffer (supports up to 512 CPUs)
 * and sum the individual per-CPU values.
 */
static __u64 read_percpu_sum(int map_fd, __u32 key, int ncpus)
{
    /* 4096 bytes → supports up to 512 CPUs (each slot = 8 bytes). */
    __u64 buf[512];
    memset(buf, 0, sizeof(buf));

    __u64 sum = 0;
    if (bpf_map_lookup_elem(map_fd, &key, buf) == 0) {
        for (int i = 0; i < ncpus && i < 512; i++)
            sum += buf[i];
    }
    return sum;
}

/* ---- ELF symbol lookup ---- */

/*
 * Resolve a symbol's file offset inside an ELF binary.
 * Returns 0 on failure.
 *
 * For uprobes the kernel expects a FILE OFFSET (not a virtual address).
 * We walk the symbol table to find st_value, then convert to a file
 * offset via the matching PT_LOAD segment: file_off = st_value - p_vaddr + p_offset.
 *
 * For non-PIE executables (ET_EXEC), the first PT_LOAD typically has
 * p_vaddr matching the load address, so this conversion is essential.
 * For PIE / shared libraries (ET_DYN), the first PT_LOAD often has
 * p_vaddr=0, in which case file_offset ≈ st_value.
 */
static unsigned long elf_find_func_offset(const char *binary_path,
                                          const char *func_name)
{
    int fd = -1;
    Elf *elf_handle = NULL;
    unsigned long offset = 0;
    Elf_Scn *scn = NULL;
    size_t shstrndx;

    if (elf_version(EV_CURRENT) == EV_NONE) {
        fprintf(stderr, "elf_version() failed\n");
        return 0;
    }

    fd = open(binary_path, O_RDONLY);
    if (fd < 0) {
        perror("open binary");
        return 0;
    }

    elf_handle = elf_begin(fd, ELF_C_READ, NULL);
    if (!elf_handle) {
        fprintf(stderr, "elf_begin: %s\n", elf_errmsg(-1));
        goto out;
    }

    if (elf_getshdrstrndx(elf_handle, &shstrndx) != 0) {
        fprintf(stderr, "elf_getshdrstrndx: %s\n", elf_errmsg(-1));
        goto out;
    }

    while ((scn = elf_nextscn(elf_handle, scn)) != NULL) {
        GElf_Shdr shdr;
        if (!gelf_getshdr(scn, &shdr))
            continue;
        if (shdr.sh_type != SHT_SYMTAB && shdr.sh_type != SHT_DYNSYM)
            continue;

        Elf_Data *data = elf_getdata(scn, NULL);
        if (!data)
            continue;

        int nsyms = shdr.sh_size / shdr.sh_entsize;
        for (int i = 0; i < nsyms; i++) {
            GElf_Sym sym;
            if (!gelf_getsym(data, i, &sym))
                continue;
            /* Only look at FUNC and NOTYPE symbols (assembly functions
             * sometimes have STT_NOTYPE in stripped-but-debuginfo ELF). */
            int stype = GELF_ST_TYPE(sym.st_info);
            if (stype != STT_FUNC && stype != STT_NOTYPE)
                continue;

            const char *name = elf_strptr(elf_handle, shdr.sh_link,
                                          sym.st_name);
            if (!name || strcmp(name, func_name) != 0)
                continue;

            /* Found the symbol — now convert vaddr → file offset. */
            offset = sym.st_value;

            size_t phnum;
            if (elf_getphdrnum(elf_handle, &phnum) == 0) {
                for (size_t p = 0; p < phnum; p++) {
                    GElf_Phdr phdr;
                    if (!gelf_getphdr(elf_handle, p, &phdr))
                        continue;
                    if (phdr.p_type != PT_LOAD)
                        continue;
                    if (offset >= phdr.p_vaddr &&
                        offset <  phdr.p_vaddr + phdr.p_memsz) {
                        offset = offset - phdr.p_vaddr + phdr.p_offset;
                        goto out;
                    }
                }
            }
            goto out;
        }
    }

    if (offset == 0)
        fprintf(stderr,
                "Symbol '%s' not found in %s\n"
                "  Hint: the binary must not be stripped (check: nm %s)\n",
                func_name, binary_path, binary_path);

out:
    if (elf_handle)
        elf_end(elf_handle);
    if (fd >= 0)
        close(fd);
    return offset;
}

/* ---- perf event callback ---- */
static __u64 sample_count;
static __u64 min_len = UINT64_MAX;
static __u64 max_len = 0;

static void handle_event(void *ctx, int cpu, void *data, __u32 data_sz)
{
    (void)ctx; (void)cpu; (void)data_sz;
    struct {
        __u64 len;
        __u32 tgid;
        __u32 pid;
    } *e = data;

    sample_count++;
    if (e->len < min_len) min_len = e->len;
    if (e->len > max_len) max_len = e->len;

    if (verbose) {
        printf("  [event %5llu]  cpu=%-2d  len=%-8llu"
               "  pid=%u  tgid=%u\n",
               (unsigned long long)sample_count, cpu,
               (unsigned long long)e->len, e->pid, e->tgid);
    }
}

static void handle_lost(void *ctx, int cpu, __u64 cnt)
{
    (void)ctx;
    fprintf(stderr, "WARNING: lost %llu events on CPU %d\n",
            (unsigned long long)cnt, cpu);
}

/* ---- histogram display ---- */

static __u64 print_histogram(struct crc16_len_dist_bpf *skel,
                              __u64 prev_total, int ncpus)
{
    int p2_fd  = bpf_map__fd(skel->maps.p2_hist);
    int lin_fd = bpf_map__fd(skel->maps.lin_hist);
    int tot_fd = bpf_map__fd(skel->maps.total_cnt);

    /* Read total count. */
    __u64 total = read_percpu_sum(tot_fd, 0, ncpus);
    __u64 delta = total - prev_total;

    if (delta == 0) {
        printf("\n[no new calls since last update]\n");
        return total;
    }

    printf("\n──── crc16_xmodem() len distribution ──── "
           "total: %llu (+%llu) ────\n\n",
           (unsigned long long)total, (unsigned long long)delta);

    /* ---- Power-of-2 histogram ---- */
    printf("  Power-of-2 buckets:\n");
    printf("  %-12s  %10s  %6s  %s\n", "Range", "Count", "Pct", "Bar");
    printf("  %-12s  %10s  %6s  %s\n", "────────────",
           "──────────", "──────",
           "────────────────────────────────────────────────────");

    __u64 p2_vals[P2_BUCKETS];
    __u64 p2_total = 0;
    for (__u32 i = 0; i < P2_BUCKETS; i++) {
        p2_vals[i] = read_percpu_sum(p2_fd, i, ncpus);
        p2_total  += p2_vals[i];
    }

    __u64 max_count = 0;
    for (int i = 0; i < P2_BUCKETS; i++)
        if (p2_vals[i] > max_count) max_count = p2_vals[i];

    for (int i = 0; i < P2_BUCKETS; i++) {
        double pct = p2_total ? (100.0 * p2_vals[i] / p2_total) : 0.0;
        /* Bar width: proportional to max (40 chars = max bucket). */
        int bar_w = max_count ? (int)(40.0 * p2_vals[i] / max_count) : 0;
        if (p2_vals[i] > 0 && bar_w == 0) bar_w = 1;  /* at least 1 char */
        char bar[64];
        memset(bar, '#', bar_w);
        bar[bar_w] = '\0';
        printf("  %-12s  %10llu  %5.1f%%  %s\n",
               p2_labels[i], (unsigned long long)p2_vals[i], pct, bar);
    }

    /* ---- Linear histogram ---- */
    printf("\n  Linear buckets (%d-byte steps):\n", LIN_BUCKET_SIZE);
    printf("  %-12s  %10s  %6s  %s\n", "Range", "Count", "Pct", "Bar");
    printf("  %-12s  %10s  %6s  %s\n", "────────────",
           "──────────", "──────",
           "────────────────────────────────────────────────────");

    __u64 lin_vals[LIN_BUCKETS];
    __u64 lin_total = 0;
    for (__u32 i = 0; i < LIN_BUCKETS; i++) {
        lin_vals[i]  = read_percpu_sum(lin_fd, i, ncpus);
        lin_total   += lin_vals[i];
    }

    __u64 lin_max = 0;
    for (int i = 0; i < LIN_BUCKETS; i++)
        if (lin_vals[i] > lin_max) lin_max = lin_vals[i];

    for (int i = 0; i < LIN_BUCKETS; i++) {
        char label[24];
        if (i == LIN_BUCKETS - 1)
            snprintf(label, sizeof(label), "  %3d+   ", i * LIN_BUCKET_SIZE);
        else
            snprintf(label, sizeof(label), " %3d - %-3d ",
                     i * LIN_BUCKET_SIZE,
                     (i + 1) * LIN_BUCKET_SIZE - 1);

        double pct = lin_total ? (100.0 * lin_vals[i] / lin_total) : 0.0;
        int bar_w  = lin_max ? (int)(40.0 * lin_vals[i] / lin_max) : 0;
        if (lin_vals[i] > 0 && bar_w == 0) bar_w = 1;
        char bar[64];
        memset(bar, '#', bar_w);
        bar[bar_w] = '\0';
        printf("  %-12s  %10llu  %5.1f%%  %s\n",
               label, (unsigned long long)lin_vals[i], pct, bar);
    }

    /* ---- Dispatch path analysis ---- */
    /*
     * crc16_xmodem dispatch:
     *   len < 16  → scalar (table-driven)
     *   16 ≤ len < 64 → short (NEON)
     *   len ≥ 64  → pmull (4-way PMULL)
     *
     * Compute from the power-of-2 buckets:
     *   bucket 0 (1), bucket 1 (2), bucket 2 (3-4), bucket 3 (5-8) → all scalar
     *   bucket 4 (9-16): partially scalar (len 9-15) + partially short (len 16)
     *   bucket 5 (17-32), bucket 6 (33-64) → mostly short
     *   bucket 6 has len 33-64 → partially short (33-63) + pmull (64)
     *   bucket 7+ (65+) → pmull
     *
     * For an approximate view we use: scalar = bucket 0-3,
     * short = bucket 4-5 + partial 6, pmull = bucket 7+ + partial 6.
     * Since we don't have exact per-value counts in BPF, this is best-effort.
     */
    __u64 scalar_cnt = 0, short_cnt = 0, pmull_cnt = 0;
    /* Buckets 0-3: all len < 16 → scalar */
    for (int i = 0; i <= 3; i++) scalar_cnt += p2_vals[i];
    /* Bucket 4 (9-16): ~87.5% scalar (9-15), ~12.5% short (16) */
    scalar_cnt += p2_vals[4] * 7 / 8;
    short_cnt  += p2_vals[4] / 8;
    /* Bucket 5 (17-32): all short */
    short_cnt += p2_vals[5];
    /* Bucket 6 (33-64): ~95% short (33-63), ~5% pmull (64) */
    short_cnt += p2_vals[6] * 31 / 32;
    pmull_cnt += p2_vals[6] / 32;
    /* Buckets 7+: all pmull */
    for (int i = 7; i < P2_BUCKETS; i++) pmull_cnt += p2_vals[i];

    printf("\n  Dispatch path estimate:\n");
    printf("    scalar  (len < 16)    %10llu  (%5.1f%%)\n",
           (unsigned long long)scalar_cnt, p2_total ? 100.0 * scalar_cnt / p2_total : 0.0);
    printf("    short   (16≤len<64)   %10llu  (%5.1f%%)\n",
           (unsigned long long)short_cnt,  p2_total ? 100.0 * short_cnt  / p2_total : 0.0);
    printf("    pmull   (len≥64)      %10llu  (%5.1f%%)\n",
           (unsigned long long)pmull_cnt,  p2_total ? 100.0 * pmull_cnt  / p2_total : 0.0);

    /* ---- Cumulative percentiles ---- */
    printf("\n  Cumulative percentiles (power-of-2):\n");
    __u64 cumul = 0;
    double pcts[] = {50.0, 90.0, 95.0, 99.0};
    int pi = 0;
    for (int i = 0; i < P2_BUCKETS && pi < 4; i++) {
        cumul += p2_vals[i];
        double cpct = 100.0 * cumul / p2_total;
        while (pi < 4 && cpct >= pcts[pi]) {
            printf("    P%-4.0f  ≤ %-12s  bytes\n", pcts[pi], p2_labels[i]);
            pi++;
        }
    }

    /* ---- Sample stats ---- */
    if (min_len != UINT64_MAX)
        printf("\n  Sample stats: min=%llu, max=%llu\n",
               (unsigned long long)min_len, (unsigned long long)max_len);

    printf("\n");
    return total;
}

/* ---- usage ---- */
static void usage(const char *prog)
{
    fprintf(stderr,
        "Usage: sudo %s [-v] [-s] [-c cpu] [-p pid] <binary> [function] [interval]\n"
        "\n"
        "  binary     Path to ELF binary containing the function\n"
        "  function   Symbol name to probe (default: crc16_xmodem)\n"
        "  interval   Histogram refresh interval in seconds (default: 5)\n"
        "  -v         Verbose: log each event as it arrives\n"
        "  -s         Summary only: print histogram once at exit (Ctrl+C)\n"
        "  -c <cpu>   Only record events on CPU N (default: all)\n"
        "  -p <pid>   Only trace calls from PID N (default: all)\n"
        "\n"
        "Examples:\n"
        "  sudo %s ./crc16_xmodem_bench\n"
        "  sudo %s -c 3 ./crc16_xmodem_bench          # only CPU 3\n"
        "  sudo %s -p 12345 ./crc16_xmodem_bench      # only PID 12345\n"
        "  sudo %s -c 3 -p 12345 -s ./crc16_xmodem_bench\n"
        "  sudo %s ./crc16_xmodem_bench crc16_xmodem_pmull 5\n",
        prog, prog, prog, prog, prog, prog);
}

/* ---- main ---- */
int main(int argc, char **argv)
{
    const char *binary   = NULL;
    const char *func     = "crc16_xmodem";
    int interval         = DEFAULT_INTERVAL;
    int target_cpu       = -1;      /* -1 = all CPUs */
    int target_pid       = -1;      /* -1 = all PIDs */
    int err              = 0;
    int argi             = 1;

    /* Parse flags: -v, -s, -c <cpu>, -p <pid>, or combined -vs/-sv etc. */
    while (argi < argc && argv[argi][0] == '-') {
        const char *f = argv[argi] + 1;
        if (*f == '\0') { argi++; break; }  /* bare "-" → stop flags */
        while (*f) {
            switch (*f) {
            case 'v': verbose = 1; f++; break;
            case 's': summary_only = 1; f++; break;
            case 'c':
                f++;
                if (*f) { target_cpu = atoi(f); f += strlen(f); }
                else if (argi + 1 < argc) { target_cpu = atoi(argv[++argi]); f = ""; }
                else { fprintf(stderr, "-c requires a CPU number\n"); return 1; }
                break;
            case 'p':
                f++;
                if (*f) { target_pid = atoi(f); f += strlen(f); }
                else if (argi + 1 < argc) { target_pid = atoi(argv[++argi]); f = ""; }
                else { fprintf(stderr, "-p requires a PID\n"); return 1; }
                break;
            default:
                fprintf(stderr, "Unknown option: -%c\n", *f);
                usage(argv[0]);
                return 1;
            }
        }
        argi++;
    }

    if (argi >= argc) {
        usage(argv[0]);
        return 1;
    }

    binary = argv[argi];
    if (argi + 1 < argc)
        func = argv[argi + 1];
    if (argi + 2 < argc)
        interval = atoi(argv[argi + 2]);
    if (interval < 1)
        interval = 1;

    /* Resolve real path — uprobe path must match what the kernel sees. */
    char real_path[4096];
    if (!realpath(binary, real_path)) {
        fprintf(stderr, "Cannot resolve path to '%s': %s\n",
                binary, strerror(errno));
        return 1;
    }

    /* Verify file exists and is readable. */
    struct stat st;
    if (stat(real_path, &st) != 0) {
        perror("stat");
        return 1;
    }

    /* Find function offset in ELF. */
    unsigned long offset = elf_find_func_offset(real_path, func);
    if (!offset) {
        fprintf(stderr, "Cannot find symbol '%s' in %s\n", func, real_path);
        return 1;
    }
    printf("Found '%s' at offset 0x%lx in %s\n", func, offset, real_path);

    /* ---- Open & load BPF skeleton ---- */
    struct crc16_len_dist_bpf *skel;
    skel = crc16_len_dist_bpf__open();
    if (!skel) {
        fprintf(stderr, "Failed to open BPF skeleton: %s\n", strerror(errno));
        return 1;
    }

    err = crc16_len_dist_bpf__load(skel);
    if (err) {
        fprintf(stderr, "Failed to load BPF program: %d (%s)\n",
                err, strerror(errno));
        goto cleanup;
    }

    /* ---- Set CPU filter in BPF map ---- */
    {
        __u32 key = 0;
        __u32 cpu_val = (__u32)target_cpu;  /* -1 → 0xFFFFFFFF = disabled */
        int cpu_fd = bpf_map__fd(skel->maps.target_cpu);
        if (bpf_map_update_elem(cpu_fd, &key, &cpu_val, BPF_ANY) != 0) {
            fprintf(stderr, "Failed to set target_cpu map: %s\n",
                    strerror(errno));
            err = 1;
            goto cleanup;
        }
    }

    /* ---- Attach uprobe ---- */
    struct bpf_uprobe_opts opts = {
        .sz = sizeof(opts),
    };
    struct bpf_link *link;
    link = bpf_program__attach_uprobe_opts(
                skel->progs.uprobe_crc16,
                target_pid,     /* -1 = all PIDs, or specific PID */
                real_path,
                offset,
                &opts);
    if (!link) {
        fprintf(stderr, "Failed to attach uprobe: %s\n", strerror(errno));
        err = 1;
        goto cleanup;
    }
    printf("Uprobe attached: %s+0x%lx  →  %s()\n", real_path, offset, func);
    {
        char cpu_str[16], pid_str[16];
        if (target_cpu >= 0) snprintf(cpu_str, sizeof(cpu_str), "%d", target_cpu);
        else                 snprintf(cpu_str, sizeof(cpu_str), "all");
        if (target_pid >= 0) snprintf(pid_str, sizeof(pid_str), "%d", target_pid);
        else                 snprintf(pid_str, sizeof(pid_str), "all");
        printf("Filters: cpu=%s, pid=%s\n", cpu_str, pid_str);
    }

    /* ---- Set up perf buffer ---- */
    struct perf_buffer *pb;
    pb = perf_buffer__new(
            bpf_map__fd(skel->maps.events),
            64,                 /* 256 KB per CPU (64 pages × 4 KB) */
            handle_event,
            handle_lost,
            NULL,               /* ctx  */
            NULL);              /* opts */
    if (!pb) {
        fprintf(stderr, "Failed to create perf buffer: %s\n", strerror(errno));
        err = 1;
        goto cleanup;
    }

    /* ---- Main loop ---- */
    signal(SIGINT,  sig_handler);
    signal(SIGTERM, sig_handler);

    int ncpus = libbpf_num_possible_cpus();
    printf("Monitoring %d CPUs, refresh every %ds.  Ctrl+C to stop.\n",
           ncpus, interval);
    if (summary_only)
        printf("(summary-only mode: histogram will print once at exit)\n");
    printf("\n");

    __u64 prev_total = 0;
    while (!stopping) {
        err = perf_buffer__poll(pb, interval * 1000);
        if (err < 0 && err != -EINTR) {
            fprintf(stderr, "perf_buffer__poll: %s\n", strerror(-err));
            break;
        }
        if (summary_only) {
            /* Lightweight progress: just show running total. */
            __u64 total = read_percpu_sum(
                    bpf_map__fd(skel->maps.total_cnt), 0, ncpus);
            printf("\r  [collecting...] total: %llu events",
                   (unsigned long long)total);
            fflush(stdout);
        } else {
            prev_total = print_histogram(skel, prev_total, ncpus);
        }
    }
    if (summary_only)
        printf("\r                                    \r");  /* clear progress line */

    /* ---- Final summary ---- */
    printf("\n═══ Final Summary ═══\n");
    printf("Total events via perf buffer: %llu\n", (unsigned long long)sample_count);
    print_histogram(skel, 0, ncpus);

    perf_buffer__free(pb);
cleanup:
    crc16_len_dist_bpf__destroy(skel);
    printf("Done.\n");
    return err ? 1 : 0;
}
