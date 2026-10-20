/* Directed correctness checks for public dispatch and both SVE EC paths.
 * Tables and data end at inaccessible guard pages to catch tail overreads.
 */
#define _GNU_SOURCE
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/auxv.h>
#include <sys/mman.h>
#include <sys/prctl.h>
#include <unistd.h>
#include <asm/hwcap.h>
#include "erasure_code.h"

typedef unsigned char u8;
typedef void (*encode_fn)(int, int, int, u8 *, u8 **, u8 **);
extern void ec_encode_data_sve(int, int, int, u8 *, u8 **, u8 **);
extern void ec_encode_data_sve2(int, int, int, u8 *, u8 **, u8 **);
typedef void (*dot_fn)(int, int, u8 *, u8 **, u8 **);
#define DECL(N, S) extern void gf_##N##vect_dot_prod_##S(int, int, u8 *, u8 **, u8 **)
DECL(2, sve); DECL(3, sve); DECL(4, sve); DECL(5, sve); DECL(6, sve); DECL(7, sve);
DECL(2, sve2); DECL(3, sve2); DECL(4, sve2); DECL(5, sve2); DECL(6, sve2); DECL(7, sve2);

struct guarded { u8 *map, *data; size_t size; };
static struct guarded alloc_guard(size_t bytes)
{
        const size_t page = (size_t) sysconf(_SC_PAGESIZE);
        const size_t usable = (bytes + 32 + page - 1) / page * page;
        struct guarded g = { .size = usable + page };
        g.map = mmap(NULL, g.size, PROT_READ | PROT_WRITE, MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
        if (g.map == MAP_FAILED || mprotect(g.map + usable, page, PROT_NONE)) {
                perror("guard allocation"); exit(2);
        }
        g.data = g.map + usable - bytes;
        memset(g.data - 32, 0xa5, bytes + 32);
        return g;
}

static uint32_t rng = 0x950ec;
static u8 next_byte(void)
{
        rng ^= rng << 13; rng ^= rng >> 17; rng ^= rng << 5;
        return (u8) rng;
}

int main(void)
{
        if (!(getauxval(AT_HWCAP) & HWCAP_SVE) || !(getauxval(AT_HWCAP2) & HWCAP2_SVE2)) {
                fprintf(stderr, "Both SVE and SVE2 required for this test\n"); return 2;
        }
        printf("SVE vector length: %d bytes\n", prctl(PR_SVE_GET_VL) & PR_SVE_VL_LEN_MASK);
#ifdef EC_BOUNDARY_QUICK
        const int lengths[] = {0, 1, 15, 16, 17, 31, 32, 33, 47, 63, 64, 65, 127, 128, 129, 255, 257};
        const int ks[] = {1, 2, 10};
#else
        const int lengths[] = {0, 1, 15, 16, 17, 31, 32, 33, 47, 63, 64, 65,
                               127, 128, 129, 255, 257, 4095, 4096, 4097, 65536};
        const int ks[] = {1, 2, 3, 10, 16, 31};
#endif
        encode_fn encoders[] = {ec_encode_data, ec_encode_data_sve, ec_encode_data_sve2};
        const char *names[] = {"dispatch", "sve", "sve2"};
        dot_fn direct[2][6] = {
                {gf_2vect_dot_prod_sve, gf_3vect_dot_prod_sve, gf_4vect_dot_prod_sve,
                 gf_5vect_dot_prod_sve, gf_6vect_dot_prod_sve, gf_7vect_dot_prod_sve},
                {gf_2vect_dot_prod_sve2, gf_3vect_dot_prod_sve2, gf_4vect_dot_prod_sve2,
                 gf_5vect_dot_prod_sve2, gf_6vect_dot_prod_sve2, gf_7vect_dot_prod_sve2}};
        unsigned cases = 0, calls = 0;
        for (unsigned l = 0; l < sizeof(lengths) / sizeof(lengths[0]); l++)
        for (unsigned ki = 0; ki < sizeof(ks) / sizeof(ks[0]); ki++)
        for (int rows = 1; rows <= 11; rows++) {
                const int len = lengths[l], k = ks[ki];
                struct guarded src[31], dst[11], tbl = alloc_guard((size_t) k * rows * 32);
                u8 *input[31], *output[11], *reference[11], coefficients[31 * 11];
                for (int v = 0; v < k; v++) {
                        src[v] = alloc_guard(len); input[v] = src[v].data;
                        for (int p = 0; p < len; p++) input[v][p] = next_byte();
                }
                for (int d = 0; d < rows; d++) {
                        dst[d] = alloc_guard(len); output[d] = dst[d].data;
                        reference[d] = malloc(len ? (size_t) len : 1);
                        if (!reference[d]) return 2;
                }
                for (int mode = 0; mode < 4; mode++) {
                        for (int d = 0; d < rows; d++)
                        for (int v = 0; v < k; v++)
                                coefficients[d * k + v] = mode == 1 ? 1 : mode == 3 ? 0 :
                                        mode == 2 && d == (int)(l % rows) ? 1 : next_byte();
                        ec_init_tables(k, rows, coefficients, tbl.data);
                        ec_encode_data_base(len, k, rows, tbl.data, input, reference);
                        const int count = 3 + (len >= 16 && rows >= 2 && rows <= 7 ? 2 : 0);
                        for (int f = 0; f < count; f++) {
                                for (int d = 0; d < rows; d++) memset(output[d], 0x5a, len);
                                if (f < 3) encoders[f](len, k, rows, tbl.data, input, output);
                                else direct[f - 3][rows - 2](len, k, tbl.data, input, output);
                                for (int d = 0; d < rows; d++) {
                                        if (memcmp(output[d], reference[d], len)) {
                                                fprintf(stderr, "Mismatch %s len=%d k=%d rows=%d mode=%d row=%d\n",
                                                        f < 3 ? names[f] : "direct", len, k, rows, mode, d);
                                                return 1;
                                        }
                                        for (int p = -32; p < 0; p++)
                                                if (output[d][p] != 0xa5) { fprintf(stderr, "Prefix overwritten\n"); return 1; }
                                }
                                calls++;
                        }
                        cases++;
                }
                for (int v = 0; v < k; v++) munmap(src[v].map, src[v].size);
                for (int d = 0; d < rows; d++) { munmap(dst[d].map, dst[d].size); free(reference[d]); }
                munmap(tbl.map, tbl.size);
        }
        printf("PASS: %u matrix/length cases, %u encoder calls, exact-sized guarded tables/data\n", cases, calls);
        return 0;
}

