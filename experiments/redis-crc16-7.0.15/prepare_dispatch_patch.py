"""Import the supplied kernels byte-for-byte; keep a correctness fix separate."""
from pathlib import Path
import difflib
import hashlib
import json
import subprocess

ROOT = Path(__file__).resolve().parents[2]
REDIS = ROOT / 'upstream/redis-7.0.15'
CRC = ROOT / 'upstream/crc16_bench'
OUT = Path(__file__).resolve().parent / 'dispatch'
OUT.mkdir(exist_ok=True)


def blob(repo, path):
    return subprocess.check_output(['git', '-C', str(repo), 'show', f'HEAD:{path}'])


def write(path, text):
    path.write_text(text, encoding='utf-8', newline='\n')


source = blob(REDIS, 'src/crc16.c').decode()
write(OUT / 'crc16_reference.c', source.replace('#include "server.h"', '#include <stdint.h>'))
source = source.replace('#include "server.h"', '''#include <stdint.h>

#if defined(REDIS_CRC16_PMULL) && defined(__linux__) && \\
    defined(__aarch64__) && defined(__BYTE_ORDER__) && \\
    __BYTE_ORDER__ == __ORDER_LITTLE_ENDIAN__
#include <sys/auxv.h>
#include <asm/hwcap.h>
extern uint16_t crc16_xmodem(uint16_t seed, const uint8_t *buf, uint64_t len);
static int crc16_has_pmull;
__attribute__((constructor)) static void crc16InitPmull(void) {
    crc16_has_pmull = (getauxval(AT_HWCAP) & HWCAP_PMULL) != 0;
}
#define CRC16_USE_PMULL
#endif''')
source = source.replace('uint16_t crc16(const char *buf, int len) {', '''uint16_t crc16(const char *buf, int len) {
#ifdef CRC16_USE_PMULL
    /* All nonnegative lengths on capable hardware go through the imported
     * dispatcher, including its scalar and short-buffer branches. */
    if (len >= 0 && crc16_has_pmull)
        return crc16_xmodem(0, (const uint8_t *)buf, (uint64_t)len);
#endif''')
write(REDIS / 'src/crc16.c', source)

assembly_names = ['crc16_xmodem_pmull', 'crc16_xmodem_short',
                  'crc16_xmodem_pmull_8way', 'crc16_xmodem_pmull_opt']
makefile = blob(REDIS, 'src/Makefile').decode()
block = '''# Import the upstream dispatch and kernels without changing their source.
# Its dispatch policy remains <16 scalar, 16..63 short, >=64 four-way.
CRC16_PMULL?=yes
CRC16_XMODEM_ASM_OBJ=''' + ' '.join(n + '.o' for n in assembly_names) + '''
ifeq ($(uname_S),Linux)
ifeq ($(uname_M),aarch64)
ifeq ($(CRC16_PMULL),yes)
FINAL_CFLAGS+=-DREDIS_CRC16_PMULL
# Keep the imported assembly byte-identical; set non-exec stack at link time.
FINAL_LDFLAGS+=-Wl,-z,noexecstack
CRC16_XMODEM_OBJ=crc16_xmodem_dispatch.o $(CRC16_XMODEM_ASM_OBJ)
REDIS_SERVER_OBJ+=$(CRC16_XMODEM_OBJ)
REDIS_CLI_OBJ+=$(CRC16_XMODEM_OBJ)
REDIS_BENCHMARK_OBJ+=$(CRC16_XMODEM_OBJ)
endif
endif
endif
'''
makefile = makefile.replace('ALL_SOURCES=$(sort', block + 'ALL_SOURCES=$(sort')
makefile = makefile.replace('ALL_SOURCES=$(sort $(patsubst',
                          'ALL_SOURCES=$(filter-out $(CRC16_XMODEM_ASM_OBJ:.o=.c),$(sort $(patsubst')
makefile = makefile.replace('$(REDIS_BENCHMARK_OBJ)))\n', '$(REDIS_BENCHMARK_OBJ))))\n')
makefile = makefile.replace('# The file commands.c', '''$(CRC16_XMODEM_ASM_OBJ): %.o: %.S .make-prerequisites
\t$(REDIS_CC) -MMD -o $@ -c $<

# The file commands.c''')
write(REDIS / 'src/Makefile', makefile)

imports = ['crc16_xmodem_dispatch.c', 'crc16_xmodem_constants.h'] + [n + '.S' for n in assembly_names]
manifest = {}
for name in imports:
    data = blob(CRC, name)
    (REDIS / 'src' / name).write_bytes(data)
    manifest[name] = dict(sha256=hashlib.sha256(data).hexdigest(), byte_identical=True)

arm = (ROOT / 'upstream/isa-l/crc/aarch64/crc16_t10dif_pmull.S').read_text()
license_text = '\n'.join(line.lstrip('# ') for line in arm.split('#include', 1)[0].splitlines()
                         if line.strip('# '))
notice = '''Upstream: https://gitee.com/chenxuqiang2022/crc16_bench
Commit: f8e9dbea5bd065823f0f77532136851e1d25dd0c
Imported source files are byte-identical to the Git blobs at that commit.
The upstream four-way source identifies Arm's ISA-L implementation as its origin.
The originating copyright notice and license are retained below.

''' + license_text + '\n'
write(REDIS / 'src/CRC16_XMODEM_NOTICE', notice)
manifest['upstream_commit'] = 'f8e9dbea5bd065823f0f77532136851e1d25dd0c'
write(OUT / 'upstream-import-manifest.json', json.dumps(manifest, indent=2))

patch = ''
for name in ['Makefile', 'crc16.c']:
    before = blob(REDIS, 'src/' + name).decode().splitlines(keepends=True)
    after = (REDIS / 'src' / name).read_text().splitlines(keepends=True)
    patch += f'diff --git a/src/{name} b/src/{name}\n'
    patch += ''.join(difflib.unified_diff(before, after, fromfile='a/src/' + name, tofile='b/src/' + name))
for name in imports + ['CRC16_XMODEM_NOTICE']:
    lines = (REDIS / 'src' / name).read_text().splitlines()
    patch += (f'diff --git a/src/{name} b/src/{name}\nnew file mode 100644\n'
              f'--- /dev/null\n+++ b/src/{name}\n@@ -0,0 +1,{len(lines)} @@\n')
    patch += ''.join('+' + line + '\n' for line in lines)
write(OUT / 'redis-7.0.15-crc16-upstream-dispatch.patch', patch)

# Optional, explicit fix: finish only complete 16-byte chunks, then continue
# the CRC with the exact residual bytes using the existing seeded scalar path.
original = blob(CRC, 'crc16_xmodem_short.S').decode()
start = original.index('\t/* ---- Partial tail:')
end = original.index('\t/* ---- Process loaded', start)
fixed = (original[:start] + '''\t/* Finish full chunks; consume the exact tail after reduction. */
.crc_short_tail:
\tb\t.crc_short_finish

''' + original[end:])
needle = '\tumov\tx0, v2.d[0]\n\tubfx\tx0, x0, 16, 16\n\tret'
assert fixed.count(needle) == 1
fixed = fixed.replace(needle, '''\tumov\tx0, v2.d[0]
\tubfx\tx0, x0, 16, 16
\t/* x1 points to the remaining 0..15 bytes, x2 is their exact length.
\t * Continue from the reduced CRC; do not hash zero padding. */
\tb\tcrc16_xmodem_pmull''')
write(OUT / 'crc16_xmodem_short.fixed.S', fixed)
fixpatch = 'diff --git a/src/crc16_xmodem_short.S b/src/crc16_xmodem_short.S\n'
fixpatch += ''.join(difflib.unified_diff(original.splitlines(keepends=True), fixed.splitlines(keepends=True),
                                       fromfile='a/src/crc16_xmodem_short.S', tofile='b/src/crc16_xmodem_short.S'))
write(OUT / 'redis-7.0.15-crc16-short-tail-fix.patch', fixpatch)

# Selected by the user: unchanged upstream dispatch plus the explicit short fix.
def addition(name, text):
    lines = text.splitlines()
    return (f'diff --git a/src/{name} b/src/{name}\nnew file mode 100644\n'
            f'--- /dev/null\n+++ b/src/{name}\n@@ -0,0 +1,{len(lines)} @@\n' +
            ''.join('+' + line + '\n' for line in lines))

old_block = addition('crc16_xmodem_short.S', original)
assert patch.count(old_block) == 1
combined = patch.replace(old_block, addition('crc16_xmodem_short.S', fixed))
write(OUT / 'redis-7.0.15-crc16-dispatch-fixed.patch', combined)
write(REDIS / 'src/crc16_xmodem_short.S', fixed)
selected = dict(upstream_commit=manifest['upstream_commit'],
                selection='User-approved original dispatch plus short-tail correction',
                files={name: hashlib.sha256((REDIS/'src'/name).read_bytes()).hexdigest()
                       for name in imports},
                changed_upstream_files=['crc16_xmodem_short.S'])
write(OUT / 'selected-import-manifest.json', json.dumps(selected, indent=2))
print('Raw integration, separate fix, and selected combined patch generated')
