"""Reproduce the integration from pinned, clean upstream checkouts."""
from pathlib import Path
import difflib
import subprocess

ROOT = Path(__file__).resolve().parents[2]
REDIS = ROOT / "upstream/redis-7.0.15"
CRC = ROOT / "upstream/crc16_bench"
OUT = Path(__file__).resolve().parent


def write(path, text):
    path.write_text(text, encoding="utf-8", newline="\n")


def original(path):
    return subprocess.check_output(
        ["git", "-C", str(REDIS), "show", f"HEAD:{path}"], text=True
    )


source = original("src/crc16.c")
source = source.replace('#include "server.h"', '''#include <stdint.h>

#if defined(REDIS_CRC16_PMULL) && defined(__linux__) && \\
    defined(__aarch64__) && defined(__BYTE_ORDER__) && \\
    __BYTE_ORDER__ == __ORDER_LITTLE_ENDIAN__
#include <sys/auxv.h>
#include <asm/hwcap.h>

extern uint16_t crc16_xmodem_pmull(uint16_t seed, const uint8_t *buf,
                                  uint64_t len);

/* Set before main(), then immutable: no per-call syscall or lazy-init race. */
static int crc16_has_pmull;
__attribute__((constructor)) static void crc16InitPmull(void) {
    crc16_has_pmull = (getauxval(AT_HWCAP) & HWCAP_PMULL) != 0;
}
#define CRC16_USE_PMULL
#endif''')
source = source.replace('uint16_t crc16(const char *buf, int len) {', '''uint16_t crc16(const char *buf, int len) {
#ifdef CRC16_USE_PMULL
    /* Keep short inputs and len <= 0 on the original Redis path.  In
     * particular, never convert a negative int length to uint64_t. */
    if (len >= 64 && crc16_has_pmull)
        return crc16_xmodem_pmull(0, (const uint8_t *)buf, (uint64_t)len);
#endif''')
write(REDIS / "src/crc16.c", source)

makefile = original("src/Makefile")
makefile = makefile.replace('ALL_SOURCES=$(sort', '''# ARM crypto instructions are confined to the assembly object.  The C code
# remains runnable on machines without PMULL and checks Linux HWCAP at startup.
# Build with CRC16_PMULL=no to retain only the original table implementation.
CRC16_PMULL?=yes
ifeq ($(uname_S),Linux)
ifeq ($(uname_M),aarch64)
ifeq ($(CRC16_PMULL),yes)
FINAL_CFLAGS+=-DREDIS_CRC16_PMULL
REDIS_SERVER_OBJ+=crc16_xmodem_pmull.o
REDIS_CLI_OBJ+=crc16_xmodem_pmull.o
REDIS_BENCHMARK_OBJ+=crc16_xmodem_pmull.o
endif
endif
endif
ALL_SOURCES=$(sort''')
# Avoid asking make dep to read a nonexistent .c for the assembly object.
makefile = makefile.replace('ALL_SOURCES=$(sort $(patsubst', 'ALL_SOURCES=$(filter-out crc16_xmodem_pmull.c,$(sort $(patsubst')
makefile = makefile.replace('$(REDIS_BENCHMARK_OBJ)))\n', '$(REDIS_BENCHMARK_OBJ))))\n')
makefile = makefile.replace('# The file commands.c', '''crc16_xmodem_pmull.o: crc16_xmodem_pmull.S .make-prerequisites
\t$(REDIS_CC) -MMD -o $@ -c $<

# The file commands.c''')
write(REDIS / "src/Makefile", makefile)

# The supplied implementation identifies ISA-L's Arm assembly as its origin.
# Restore that upstream BSD notice, preserving the supplied algorithm verbatim.
arm = (ROOT / "upstream/isa-l/crc/aarch64/crc16_t10dif_pmull.S").read_text()
license_text = arm.split('#include', 1)[0]
license_text = "/*\n" + "\n".join(
    line.lstrip("# ") for line in license_text.splitlines() if line.strip("# ")
) + "\n */\n\n"
provenance = '''/* Imported from https://gitee.com/chenxuqiang2022/crc16_bench
 * commit f8e9dbea5bd065823f0f77532136851e1d25dd0c.
 * Integration changes: retain the Arm BSD notice and mark the stack non-exec.
 */
'''
assembly = (CRC / "crc16_xmodem_pmull.S").read_text()
write(REDIS / "src/crc16_xmodem_pmull.S", license_text + provenance + assembly +
      '\n#if defined(__linux__)\n\t.section .note.GNU-stack,"",%progbits\n#endif\n')

# Include the untracked new assembly without modifying Git's index.
diff = subprocess.check_output(["git", "-C", str(REDIS), "diff", "--no-ext-diff", "--", "src/Makefile", "src/crc16.c"])
new = (REDIS / "src/crc16_xmodem_pmull.S").read_text().splitlines()
diff += ("diff --git a/src/crc16_xmodem_pmull.S b/src/crc16_xmodem_pmull.S\n"
         "new file mode 100644\n--- /dev/null\n+++ b/src/crc16_xmodem_pmull.S\n"
         f"@@ -0,0 +1,{len(new)} @@\n" +
         "".join("+" + line + "\n" for line in new)).encode()
(OUT / "redis-7.0.15-kp950-crc16-pmull.patch").write_bytes(diff)
print("Patch generated:", len(diff), "bytes")

# Keep the client-only fix separate: the server A/B changes only CRC16.
bench_orig = original("src/redis-benchmark.c")
bench64 = bench_orig.replace('#include <errno.h>', '#include <errno.h>\n#include <limits.h>')
bench64 = bench64.replace('    int requests;', '    long long requests;')
for counter in ('requests_issued', 'requests_finished', 'previous_requests_finished'):
    bench64 = bench64.replace(f'redisAtomic int {counter};', f'redisAtomic long long {counter};')
    bench64 = bench64.replace(f'int {counter} = 0;', f'long long {counter} = 0;')
bench64 = bench64.replace('  %d requests completed', '  %lld requests completed')
bench64 = bench64.replace('            config.requests = atoi(argv[++i]);', '''            char *end;
            const char *count = argv[++i];
            errno = 0;
            config.requests = strtoll(count, &end, 10);
            if (errno == ERANGE || end == count || *end != '\\0' ||
                config.requests <= 0 || config.requests > LLONG_MAX - INT_MAX) {
                fprintf(stderr, "Invalid request count: %s\\n", count);
                exit(1);
            }''')
client_diff = 'diff --git a/src/redis-benchmark.c b/src/redis-benchmark.c\n' + ''.join(
    difflib.unified_diff(bench_orig.splitlines(keepends=True), bench64.splitlines(keepends=True),
                         fromfile='a/src/redis-benchmark.c', tofile='b/src/redis-benchmark.c'))
write(OUT / 'redis-7.0.15-benchmark-64bit.patch', client_diff)
