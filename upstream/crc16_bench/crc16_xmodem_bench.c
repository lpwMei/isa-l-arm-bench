/**
 * XMODEM CRC16 Benchmark - comparing PMULL-optimized vs table-driven
 *
 * Build:
 *   gcc -O2 -o crc16_xmodem_bench crc16_xmodem_bench.c crc16_xmodem_pmull.S
 *
 * Test correctness:
 *   ./crc16_xmodem_bench --test
 *
 * Benchmark:
 *   ./crc16_xmodem_bench
 */
#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include <string.h>
#include <time.h>

/* ------------------------------------------------------------------ */
/* PMULL-optimized assembly function                                  */
/* ------------------------------------------------------------------ */
extern uint16_t crc16_xmodem_pmull(uint16_t seed, const uint8_t *buf, uint64_t len);
extern uint16_t crc16_xmodem_pmull_opt(uint16_t seed, const uint8_t *buf, uint64_t len);
extern uint16_t crc16_xmodem_pmull_8way(uint16_t seed, const uint8_t *buf, uint64_t len);
extern uint16_t crc16_xmodem(uint16_t seed, const uint8_t *buf, uint64_t len);
extern uint16_t crc16_xmodem_short(uint16_t seed, const uint8_t *buf, uint64_t len);

/* ------------------------------------------------------------------ */
/* Reference: table-driven XMODEM CRC16 (poly=0x1021, MSB-first)      */
/* ------------------------------------------------------------------ */
static const uint16_t crc16_xmodem_table[256] = {
    0x0000, 0x1021, 0x2042, 0x3063, 0x4084, 0x50A5, 0x60C6, 0x70E7,
    0x8108, 0x9129, 0xA14A, 0xB16B, 0xC18C, 0xD1AD, 0xE1CE, 0xF1EF,
    0x1231, 0x0210, 0x3273, 0x2252, 0x52B5, 0x4294, 0x72F7, 0x62D6,
    0x9339, 0x8318, 0xB37B, 0xA35A, 0xD3BD, 0xC39C, 0xF3FF, 0xE3DE,
    0x2462, 0x3443, 0x0420, 0x1401, 0x64E6, 0x74C7, 0x44A4, 0x5485,
    0xA56A, 0xB54B, 0x8528, 0x9509, 0xE5EE, 0xF5CF, 0xC5AC, 0xD58D,
    0x3653, 0x2672, 0x1611, 0x0630, 0x76D7, 0x66F6, 0x5695, 0x46B4,
    0xB75B, 0xA77A, 0x9719, 0x8738, 0xF7DF, 0xE7FE, 0xD79D, 0xC7BC,
    0x48C4, 0x58E5, 0x6886, 0x78A7, 0x0840, 0x1861, 0x2802, 0x3823,
    0xC9CC, 0xD9ED, 0xE98E, 0xF9AF, 0x8948, 0x9969, 0xA90A, 0xB92B,
    0x5AF5, 0x4AD4, 0x7AB7, 0x6A96, 0x1A71, 0x0A50, 0x3A33, 0x2A12,
    0xDBFD, 0xCBDC, 0xFBBF, 0xEB9E, 0x9B79, 0x8B58, 0xBB3B, 0xAB1A,
    0x6CA6, 0x7C87, 0x4CE4, 0x5CC5, 0x2C22, 0x3C03, 0x0C60, 0x1C41,
    0xEDAE, 0xFD8F, 0xCDEC, 0xDDCD, 0xAD2A, 0xBD0B, 0x8D68, 0x9D49,
    0x7E97, 0x6EB6, 0x5ED5, 0x4EF4, 0x3E13, 0x2E32, 0x1E51, 0x0E70,
    0xFF9F, 0xEFBE, 0xDFDD, 0xCFFC, 0xBF1B, 0xAF3A, 0x9F59, 0x8F78,
    0x9188, 0x81A9, 0xB1CA, 0xA1EB, 0xD10C, 0xC12D, 0xF14E, 0xE16F,
    0x1080, 0x00A1, 0x30C2, 0x20E3, 0x5004, 0x4025, 0x7046, 0x6067,
    0x83B9, 0x9398, 0xA3FB, 0xB3DA, 0xC33D, 0xD31C, 0xE37F, 0xF35E,
    0x02B1, 0x1290, 0x22F3, 0x32D2, 0x4235, 0x5214, 0x6277, 0x7256,
    0xB5EA, 0xA5CB, 0x95A8, 0x8589, 0xF56E, 0xE54F, 0xD52C, 0xC50D,
    0x34E2, 0x24C3, 0x14A0, 0x0481, 0x7466, 0x6447, 0x5424, 0x4405,
    0xA7DB, 0xB7FA, 0x8799, 0x97B8, 0xE75F, 0xF77E, 0xC71D, 0xD73C,
    0x26D3, 0x36F2, 0x0691, 0x16B0, 0x6657, 0x7676, 0x4615, 0x5634,
    0xD94C, 0xC96D, 0xF90E, 0xE92F, 0x99C8, 0x89E9, 0xB98A, 0xA9AB,
    0x5844, 0x4865, 0x7806, 0x6827, 0x18C0, 0x08E1, 0x3882, 0x28A3,
    0xCB7D, 0xDB5C, 0xEB3F, 0xFB1E, 0x8BF9, 0x9BD8, 0xABBB, 0xBB9A,
    0x4A75, 0x5A54, 0x6A37, 0x7A16, 0x0AF1, 0x1AD0, 0x2AB3, 0x3A92,
    0xFD2E, 0xED0F, 0xDD6C, 0xCD4D, 0xBDAA, 0xAD8B, 0x9DE8, 0x8DC9,
    0x7C26, 0x6C07, 0x5C64, 0x4C45, 0x3CA2, 0x2C83, 0x1CE0, 0x0CC1,
    0xEF1F, 0xFF3E, 0xCF5D, 0xDF7C, 0xAF9B, 0xBFBA, 0x8FD9, 0x9FF8,
    0x6E17, 0x7E36, 0x4E55, 0x5E74, 0x2E93, 0x3EB2, 0x0ED1, 0x1EF0
};

static uint16_t crc16_xmodem_ref(uint16_t seed, const uint8_t *buf, uint64_t len)
{
    uint64_t i;
    uint16_t crc = seed;
    for (i = 0; i < len; i++)
        crc = (crc << 8) ^ crc16_xmodem_table[((crc >> 8) ^ buf[i]) & 0xFF];
    return crc;
}

/* ------------------------------------------------------------------ */
/* Timing utility                                                    */
/* ------------------------------------------------------------------ */
static double now_ms(void)
{
    struct timespec ts;
    clock_gettime(CLOCK_MONOTONIC, &ts);
    return ts.tv_sec * 1000.0 + ts.tv_nsec / 1e6;
}

/* ------------------------------------------------------------------ */
/* Correctness tests                                                  */
/* ------------------------------------------------------------------ */
static int run_tests(void)
{
    int failures = 0;
    const uint16_t seed = 0;

    printf("=== XMODEM CRC16 Correctness Tests ===\n\n");

    /* Test 1: Known answer "123456789" */
    {
        const uint8_t *data = (const uint8_t *)"123456789";
        uint16_t ref = crc16_xmodem_ref(seed, data, 9);
        uint16_t pmull = crc16_xmodem_pmull(seed, data, 9);
        uint16_t opt   = crc16_xmodem_pmull_opt(seed, data, 9);
        uint16_t way8  = crc16_xmodem_pmull_8way(seed, data, 9);
        printf("Test 1: '123456789' (9 bytes)\n");
        printf("  ref   = 0x%04X (expected 0x31C3)\n", ref);
        printf("  pmull = 0x%04X  opt = 0x%04X  8way = 0x%04X\n", pmull, opt, way8);
        printf("  %s\n\n", (ref == pmull && pmull == way8 && ref == 0x31C3) ? "PASS" : "FAIL");
        if (ref != pmull || pmull != way8 || ref != 0x31C3) failures++;
    }

    /* Test 2: Various lengths (covers scalar and PMULL paths) */
    const int test_lengths[] = {0, 1, 3, 7, 15, 16, 31, 32, 63, 64, 65,
                                127, 128, 129, 255, 256, 257, 511, 512, 513,
                                1023, 1024, 4095, 4096, 8192};
    int n_lens = sizeof(test_lengths) / sizeof(test_lengths[0]);
    uint8_t *buf = (uint8_t *)malloc(8192);
    if (!buf) { perror("malloc"); return 1; }

    for (int i = 0; i < 8192; i++)
        buf[i] = (uint8_t)(i * 7 + 13);  /* deterministic pattern */

    printf("Test 2: Various lengths (0-8192 bytes, deterministic pattern)\n");
    for (int t = 0; t < n_lens; t++) {
        int len = test_lengths[t];
        uint16_t ref = crc16_xmodem_ref(seed, buf, len);
        uint16_t pmull = crc16_xmodem_pmull(seed, buf, len);
        uint16_t opt   = crc16_xmodem_pmull_opt(seed, buf, len);
        uint16_t way8  = crc16_xmodem_pmull_8way(seed, buf, len);
        if (ref != pmull || pmull != way8) {
            printf("  len=%5d: REF=0x%04X PMULL=0x%04X OPT=0x%04X 8WAY=0x%04X FAIL\n", len, ref, pmull, opt, way8);
            failures++;
        }
    }
    printf("  %d lengths tested, %d failures\n\n", n_lens, failures);

    /* Test 3: Random data with non-zero seeds */
    printf("Test 3: Random data + random seeds (1000 iterations)\n");
    srand(42);
    for (int i = 0; i < 1000; i++) {
        int len = rand() % 8192;
        uint16_t s = (uint16_t)(rand() & 0xFFFF);
        for (int j = 0; j < len; j++)
            buf[j] = (uint8_t)(rand() & 0xFF);
        uint16_t ref = crc16_xmodem_ref(s, buf, len);
        uint16_t pmull = crc16_xmodem_pmull(s, buf, len);
        uint16_t way8  = crc16_xmodem_pmull_8way(s, buf, len);
        if (ref != pmull || pmull != way8) {
            printf("  iter=%d len=%d seed=0x%04X: REF=0x%04X PMULL=0x%04X 8WAY=0x%04X FAIL\n",
                   i, len, s, ref, pmull, way8);
            failures++;
            if (failures > 10) { printf("  (too many failures, stopping)\n"); break; }
        }
    }
    if (failures == 0)
        printf("  All 1000 tests PASS\n");
    printf("\n");

    /* Test 4: All zeros / all ones */
    printf("Test 4: Edge case buffers\n");
    memset(buf, 0x00, 1024);
    uint16_t r0_ref = crc16_xmodem_ref(seed, buf, 1024);
    uint16_t r0_pmull = crc16_xmodem_pmull(seed, buf, 1024);
    uint16_t r0_way8  = crc16_xmodem_pmull_8way(seed, buf, 1024);
    printf("  All zeros (1024B): ref=0x%04X pmull=0x%04X 8way=0x%04X %s\n",
           r0_ref, r0_pmull, r0_way8, (r0_ref == r0_pmull && r0_pmull == r0_way8) ? "PASS" : "FAIL");
    if (r0_ref != r0_pmull || r0_pmull != r0_way8) failures++;

    memset(buf, 0xFF, 1024);
    uint16_t r1_ref = crc16_xmodem_ref(seed, buf, 1024);
    uint16_t r1_pmull = crc16_xmodem_pmull(seed, buf, 1024);
    uint16_t r1_opt   = crc16_xmodem_pmull_opt(seed, buf, 1024);
    uint16_t r1_way8  = crc16_xmodem_pmull_8way(seed, buf, 1024);
    printf("  All 0xFF (1024B): ref=0x%04X pmull=0x%04X 8way=0x%04X %s\n",
           r1_ref, r1_pmull, r1_way8, (r1_ref == r1_pmull && r1_pmull == r1_way8) ? "PASS" : "FAIL");
    if (r1_ref != r1_pmull || r1_pmull != r1_way8) failures++;

    printf("\n=== Total: %d failures ===\n", failures);
    free(buf);
    return failures;
}

/* ------------------------------------------------------------------ */
/* Benchmark                                                         */
/* ------------------------------------------------------------------ */
static void bench_one(const char *name,
                      uint16_t (*fn)(uint16_t, const uint8_t *, uint64_t),
                      int data_size, int iterations, uint8_t *buf)
{
    volatile uint16_t sink = 0;
    double start = now_ms();
    for (int i = 0; i < iterations; i++)
        sink = fn(0, buf, data_size);
    double elapsed = now_ms() - start;

    long total_bytes = (long)data_size * iterations;
    double throughput_mbs = (total_bytes / (1024.0 * 1024.0)) / (elapsed / 1000.0);
    double ns_per_call = (elapsed * 1e6) / iterations;

    printf("  %-12s size=%7d  iters=%8d  elapsed=%8.2f ms  "
           "throughput=%10.1f MB/s  ns/call=%8.1f  (sink=%u)\n",
           name, data_size, iterations, elapsed,
           throughput_mbs, ns_per_call, (unsigned)sink);
}

static void run_benchmarks(void)
{
    printf("=== XMODEM CRC16 Performance Benchmark ===\n");
    printf("CPU: AARCH64 with PMULL/NEON\n\n");

    struct {
        int size;
        int iters_ref;
        int iters_pmull;
    } cases[] = {
        {      9, 20000000, 20000000 },
        {     16,  5000000,  5000000 },
        {     64,  2000000,  5000000 },
        {    128,  1000000,  5000000 },
        {    256,   500000,  2000000 },
        {    512,   200000,  2000000 },
        {   1024,   100000,  1000000 },
        {   4096,    20000,   500000 },
        {  16384,     5000,   200000 },
        {  65536,     1000,    50000 },
        { 262144,      200,    10000 },
        {1048576,       50,     2000 },
    };
    int n = sizeof(cases) / sizeof(cases[0]);

    int max_size = 0;
    for (int i = 0; i < n; i++)
        if (cases[i].size > max_size) max_size = cases[i].size;

    uint8_t *buf = (uint8_t *)malloc(max_size);
    if (!buf) { perror("malloc"); return; }
    for (int i = 0; i < max_size; i++)
        buf[i] = (uint8_t)(i & 0xFF);

    printf("%-12s %7s  %8s  %9s  %16s  %12s\n",
           "impl", "size", "iters", "elapsed", "throughput", "ns/call");
    printf("%-12s %7s  %8s  %9s  %16s  %12s\n",
           "------------", "-------", "--------", "---------",
           "----------------", "--------");

    for (int i = 0; i < n; i++) {
        bench_one("ref (table)", crc16_xmodem_ref,
                  cases[i].size, cases[i].iters_ref, buf);
        bench_one("pmull v1", crc16_xmodem_pmull,
                  cases[i].size, cases[i].iters_pmull, buf);
        bench_one("pmull v2", crc16_xmodem_pmull_opt,
                  cases[i].size, cases[i].iters_pmull, buf);
        bench_one("pmull 8w", crc16_xmodem_pmull_8way,
                  cases[i].size, cases[i].iters_pmull, buf);
        bench_one("dispatch", crc16_xmodem,
                  cases[i].size, cases[i].iters_pmull, buf);
        if (cases[i].size >= 16)
            bench_one("short", crc16_xmodem_short,
                      cases[i].size, cases[i].iters_pmull, buf);
        printf("\n");
    }

    free(buf);

    /* Speedup summary */
    printf("%-12s %7s  %8s  %9s  %16s  %12s\n",
           "------------", "-------", "--------", "---------",
           "----------------", "--------");
    printf("\nNote: ref uses more iters for small sizes, pmull uses more for large.\n");
    printf("Compare MB/s at each size for fair throughput comparison.\n");
}

/* ------------------------------------------------------------------ */
/* Main                                                              */
/* ------------------------------------------------------------------ */
int main(int argc, char *argv[])
{
    if (argc > 1 && strcmp(argv[1], "--test") == 0) {
        return run_tests();
    }

    run_benchmarks();
    return 0;
}
