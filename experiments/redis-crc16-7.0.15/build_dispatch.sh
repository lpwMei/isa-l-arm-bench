#!/usr/bin/env bash
set -euo pipefail
cd /manual
export HOME=/tmp TZ=Asia/Shanghai
exec > build-results/build-validate.log 2>&1
trap 'rc=$?; printf "%s\n" "$rc" > /manual/build-results/build-validate.exit' EXIT
date -Ins
id
cat /etc/os-release
gcc --version | head -1
python3 - <<'PY'
import hashlib, json
from pathlib import Path
manifest = json.loads(Path('artifacts/selected-import-manifest.json').read_text())
for name, expected in manifest['files'].items():
    assert hashlib.sha256((Path('source/src') / name).read_bytes()).hexdigest() == expected, name
print('PASS imported file hashes match selected manifest')
PY
make -C source -j8 > build-results/make.log 2>&1
source/src/redis-server --version
gcc -O2 -Dcrc16=crc16_reference -c validation/reference.c -o validation/reference.o
objects=(source/src/crc16.o source/src/crc16_xmodem_dispatch.o source/src/crc16_xmodem_short.o source/src/crc16_xmodem_pmull.o)
gcc -O2 -Wall -Wextra artifacts/validate_crc16.c validation/reference.o "${objects[@]}" -Wl,-z,noexecstack -o validation/dispatch-correctness
taskset -c 340 validation/dispatch-correctness | tee build-results/correctness.txt
gcc -O2 -Wall -Wextra -DCRC16_TEST_NO_PMULL artifacts/validate_crc16.c validation/reference.o "${objects[@]}" -Wl,--wrap=getauxval,-z,noexecstack -o validation/dispatch-nohw-correctness
taskset -c 340 validation/dispatch-nohw-correctness | tee build-results/nohw-correctness.txt
gcc -O2 -Wall -Wextra -c source/src/crc16.c -o validation/scalar.o
gcc -O2 -Wall -Wextra artifacts/validate_crc16.c validation/reference.o validation/scalar.o -o validation/dispatch-scalar-correctness
taskset -c 340 validation/dispatch-scalar-correctness | tee build-results/scalar-correctness.txt
gcc -O2 -Wall -Wextra artifacts/dispatch_route_test.c "${objects[@]}" -Wl,--wrap=crc16_xmodem,--wrap=crc16_xmodem_short,--wrap=crc16_xmodem_pmull,-z,noexecstack -o validation/dispatch-route-test
taskset -c 340 validation/dispatch-route-test | tee build-results/route-test.txt
gcc -O2 -Wall -Wextra artifacts/dispatch_probe.c "${objects[@]}" -Wl,-z,noexecstack -o validation/dispatch-seed-test
taskset -c 340 validation/dispatch-seed-test | tee build-results/seed-test.txt
readelf -W -l source/src/redis-server | grep GNU_STACK > build-results/gnu-stack.txt
nm source/src/redis-server | grep -E ' crc16$|crc16_xmodem|crc16InitPmull|crc16_has_pmull' > build-results/linked-symbols.txt
(cd source && ./runtest --clients 1 --single unit/cluster --single unit/type/string --single unit/keyspace --no-latency) > build-results/redis-regression.log 2>&1
install -m 755 source/src/redis-server bin/redis-server-optimized
sha256sum bin/* > build-results/binary-sha256.txt

# Verify the exact routing counterexample in the actual cluster server.
source /manual/manual_test.sh
start_redis optimized
python3 - <<'PY'
import binascii, json, subprocess
from pathlib import Path
cases=[]
for n in (0,1,9,15,16,17,31,32,33,47,48,49,63,64,65,128,256):
    for key in ('a'*n, 'prefix{'+'a'*n+'}suffix'):
        body = key.encode()
        start = body.find(b'{')
        end = body.find(b'}', start+1) if start >= 0 else -1
        hashed = body[start+1:end] if start >= 0 and end > start+1 else body
        expected = binascii.crc_hqx(hashed, 0) & 16383
        got = int(subprocess.check_output(['/manual/bin/redis-cli','-p','36381','CLUSTER','KEYSLOT',key]))
        assert got == expected, (n, key, expected, got)
        cases.append(dict(key=key,expected=expected,got=got))
Path('build-results/cluster-slot-cases.json').write_text(json.dumps(cases,indent=2))
print('PASS actual Redis CLUSTER KEYSLOT: 34 boundary/hash-tag cases')
PY
stop_redis
echo PASS > build-results/status.txt
date -Ins
exec bash /manual/run_short_commands.sh
