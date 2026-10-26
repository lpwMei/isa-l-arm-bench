#!/usr/bin/env bash
set -euo pipefail
cd /work
export HOME=/tmp
exec > results/measurements.log 2>&1
date -Ins
id
if ! git -C baseline apply --reverse --check ../artifacts/redis-7.0.15-benchmark-64bit.patch 2>/dev/null; then
    git -C baseline apply --check ../artifacts/redis-7.0.15-benchmark-64bit.patch
    git -C baseline apply ../artifacts/redis-7.0.15-benchmark-64bit.patch
fi
make -C baseline/src -j8 redis-benchmark > results/build-benchmark64.log 2>&1
gcc -O2 -Wall -Ibaseline/deps/hiredis -Ibaseline/deps/hdr_histogram -Ibaseline/src -c artifacts/benchmark_counter_test.c -o validation/counter-test.o
objects=(ae anet adlist dict zmalloc redisassert release crcspeed crc64 siphash crc16 monotonic cli_common mt19937-64)
objpaths=()
for obj in "${objects[@]}"; do objpaths+=("baseline/src/$obj.o"); done
gcc -o validation/counter-test validation/counter-test.o "${objpaths[@]}" baseline/deps/hiredis/libhiredis.a baseline/deps/hdr_histogram/libhdrhistogram.a baseline/deps/jemalloc/lib/libjemalloc.a -lm -ldl -pthread -lrt
validation/counter-test > results/benchmark64-counter-test.txt
for invalid in 0 -1 99999999999999999999 12abc; do
    if baseline/src/redis-benchmark -n "$invalid" > /tmp/invalid-count.txt 2>&1; then
        echo "Invalid request count was accepted: $invalid"; exit 1
    fi
    grep -q 'Invalid request count' /tmp/invalid-count.txt
done
sha256sum baseline/src/redis-benchmark > results/benchmark64-sha256.txt
python3 artifacts/run_e2e.py --requests 10000000 --rounds 6 --label repeated
python3 artifacts/run_e2e.py --requests 10000000 --rounds 2 --threads 4 --label client4
echo PASS > results/measurements.status
