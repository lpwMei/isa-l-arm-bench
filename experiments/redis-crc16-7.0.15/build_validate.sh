#!/usr/bin/env bash
set -euo pipefail
cd /work
exec > >(tee results/build-validate.log) 2>&1
date -Ins
id
cat /etc/os-release
gcc --version | head -1
taskset -pc $$
for variant in baseline candidate; do
    make -C "$variant" distclean > "results/clean-$variant.log" 2>&1
    make -C "$variant" -j8 > "results/build-$variant.log" 2>&1
    "$variant/src/redis-server" --version
done
mkdir -p validation
sed 's/#include "server.h"/#include <stdint.h>/' baseline/src/crc16.c > validation/reference.c
gcc -O2 -Dcrc16=crc16_reference -c validation/reference.c -o validation/reference.o
gcc -O2 -Wall -Wextra -DREDIS_CRC16_PMULL -c candidate/src/crc16.c -o validation/optimized.o
gcc -O2 -c candidate/src/crc16_xmodem_pmull.S -o validation/pmull.o
gcc -O2 -Wall -Wextra artifacts/validate_crc16.c validation/{reference,optimized,pmull}.o -o validation/crc16-test
taskset -c 320 validation/crc16-test | tee results/crc16-correctness.txt
gcc -O2 -Wall -Wextra -DCRC16_TEST_NO_PMULL artifacts/validate_crc16.c validation/{reference,optimized,pmull}.o -Wl,--wrap=getauxval -o validation/crc16-nohw-test
taskset -c 320 validation/crc16-nohw-test | tee results/crc16-nohw-correctness.txt
gcc -O2 -Wall -Wextra -c candidate/src/crc16.c -o validation/scalar.o
gcc -O2 -Wall -Wextra artifacts/validate_crc16.c validation/{reference,scalar}.o -o validation/crc16-scalar-test
taskset -c 320 validation/crc16-scalar-test | tee results/crc16-scalar-correctness.txt
taskset -c 320 validation/crc16-test --bench > results/crc16-microbenchmark.csv
readelf -W -l candidate/src/redis-server | grep GNU_STACK | tee results/gnu-stack.txt
objdump -d candidate/src/redis-server | sed -n '/<crc16>:/,+24p' > results/crc16-disassembly.txt
sha256sum baseline/src/{redis-server,redis-benchmark} candidate/src/{redis-server,redis-benchmark} > results/binary-sha256.txt
echo PASS > results/build-validate.status
