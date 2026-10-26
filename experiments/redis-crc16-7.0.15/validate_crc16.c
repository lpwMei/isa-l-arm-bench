#define _GNU_SOURCE
#include <assert.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/mman.h>
#include <time.h>
#include <unistd.h>

uint16_t crc16(const char *, int);
uint16_t crc16_reference(const char *, int);
#ifdef CRC16_TEST_NO_PMULL
/* Exercise the exact production HWCAP fallback, including its constructor. */
unsigned long __wrap_getauxval(unsigned long type) { (void)type; return 0; }
#endif

static uint32_t rng = 0x950015;
static uint32_t random32(void) {
    rng ^= rng << 13; rng ^= rng >> 17; rng ^= rng << 5;
    return rng;
}
static uint16_t bitwise(const unsigned char *p, int len) {
    uint16_t c = 0;
    while (len-- > 0) {
        c ^= (uint16_t)*p++ << 8;
        for (int b = 0; b < 8; ++b)
            c = (uint16_t)((c << 1) ^ ((c & 0x8000) ? 0x1021 : 0));
    }
    return c;
}
static size_t cases;
static void check(const unsigned char *p, int len) {
    uint16_t got = crc16((const char *)p, len);
    uint16_t want = crc16_reference((const char *)p, len);
    if (got != want) {
        fprintf(stderr, "FAIL case=%zu len=%d address=%p got=%04x want=%04x\n",
                cases, len, (const void *)p, got, want);
        exit(1);
    }
    ++cases;
}
static double now(void) {
    struct timespec ts;
    assert(clock_gettime(CLOCK_MONOTONIC, &ts) == 0);
    return ts.tv_sec + ts.tv_nsec * 1e-9;
}
static void benchmark(const unsigned char *p) {
    const int sizes[] = {0, 9, 16, 63, 64, 65, 128, 256, 1024, 4096};
    volatile uint16_t sink = 0;
    puts("bytes,reference_ns,optimized_ns,speedup");
    for (size_t j = 0; j < sizeof(sizes) / sizeof(*sizes); ++j) {
        int len = sizes[j], iters = len < 256 ? 2000000 : 200000;
        double t = now();
        for (int i = 0; i < iters; ++i) sink = crc16_reference((const char *)p, len);
        double ref = now() - t;
        t = now();
        for (int i = 0; i < iters; ++i) sink = crc16((const char *)p, len);
        double opt = now() - t;
        printf("%d,%.3f,%.3f,%.3f\n", len, ref * 1e9 / iters,
               opt * 1e9 / iters, ref / opt);
    }
    (void)sink;
}
int main(int argc, char **argv) {
    const size_t size = 1024 * 1024;
    unsigned char *p = malloc(size + 64);
    assert(p);
    for (size_t i = 0; i < size + 64; ++i) p[i] = random32();
    if (argc > 1 && strcmp(argv[1], "--bench") == 0) {
        benchmark(p); free(p); return 0;
    }
    assert(crc16("123456789", 9) == 0x31c3);
    assert(crc16(NULL, 0) == 0);
    assert(crc16(NULL, -1) == 0);
    for (int v = 0; v < 65536; ++v) {
        unsigned char pair[2] = {(unsigned char)(v >> 8), (unsigned char)v};
        assert(crc16((char *)pair, 2) == bitwise(pair, 2));
        check(pair, 2);
    }
    for (int offset = 0; offset < 64; ++offset)
        for (int len = 0; len <= 4096; ++len) check(p + offset, len);
    for (int i = 0; i < 10000; ++i)
        check(p + (random32() % 64), random32() % 16385);
    check(p, size);
    for (int pattern = 0; pattern < 4; ++pattern) {
        memset(p, pattern == 0 ? 0 : pattern == 1 ? 255 : pattern == 2 ? 128 : 85, size);
        for (int len = 0; len <= 4096; ++len) check(p, len);
    }
    /* Both edges abut PROT_NONE pages: detect overreads as well as underreads. */
    size_t page = (size_t)sysconf(_SC_PAGESIZE), area = page * 4;
    unsigned char *mem = mmap(NULL, area, PROT_NONE, MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
    assert(mem != MAP_FAILED);
    assert(mprotect(mem + page, page * 2, PROT_READ | PROT_WRITE) == 0);
    for (size_t i = 0; i < page * 2; ++i) mem[page + i] = random32();
    for (int len = 0; len <= 4096; ++len) {
        check(mem + page, len);
        check(mem + page * 3 - len, len);
    }
    assert(munmap(mem, area) == 0);
    free(p);
    printf("PASS %zu differential cases; known vector; negative length; binary data; "
           "64 alignments; two guard pages\n", cases);
    return 0;
}
