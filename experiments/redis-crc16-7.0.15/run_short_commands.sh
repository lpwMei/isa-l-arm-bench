#!/usr/bin/env bash
set -euo pipefail
cd /manual
source /manual/manual_test.sh
OUT=/manual/short-command-results
mkdir "$OUT"
exec > "$OUT/runner.log" 2>&1
date -Ins
id
cat /etc/os-release
KEY=$(printf 'k%.0s' {1..64})

stage() {
    printf '%s\n' "$1" > "$OUT/stage.tmp"
    mv "$OUT/stage.tmp" "$OUT/stage.txt"
    date -Ins
    printf 'Stage: %s, server PID: %s\n' "$1" "$(cat "$RUN/redis.pid")"
}

start_redis baseline
printf '%s\n' "$RUN" > "$OUT/baseline-run.txt"
stage baseline-set
taskset -c 342 /manual/bin/redis-benchmark -p 36381 -c 200 -n 100000000 -P 16 SET "$KEY" xxx > "$OUT/baseline-set.txt" 2>&1
stage baseline-get
taskset -c 342 /manual/bin/redis-benchmark -p 36381 -c 200 -n 100000000 -P 16 GET "$KEY" > "$OUT/baseline-get.txt" 2>&1
"$CLI" -p "$PORT" INFO all > "$OUT/baseline-info.txt"
"$CLI" -p "$PORT" DBSIZE > "$OUT/baseline-dbsize.txt"
"$CLI" -p "$PORT" GET "$KEY" > "$OUT/baseline-value.txt"
stop_redis

start_redis optimized
printf '%s\n' "$RUN" > "$OUT/optimized-run.txt"
stage optimized-set
taskset -c 342 /manual/bin/redis-benchmark -p 36381 -c 200 -n 100000000 -P 16 SET "$KEY" xxx > "$OUT/optimized-set.txt" 2>&1
stage optimized-get
taskset -c 342 /manual/bin/redis-benchmark -p 36381 -c 200 -n 100000000 -P 16 GET "$KEY" > "$OUT/optimized-get.txt" 2>&1
"$CLI" -p "$PORT" INFO all > "$OUT/optimized-info.txt"
"$CLI" -p "$PORT" DBSIZE > "$OUT/optimized-dbsize.txt"
"$CLI" -p "$PORT" GET "$KEY" > "$OUT/optimized-value.txt"
stop_redis
printf 'PASS\n' > "$OUT/status.txt"
printf 'done\n' > "$OUT/stage.txt"
date -Ins
