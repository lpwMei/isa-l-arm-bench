#!/usr/bin/env bash
set -euo pipefail
cd /work/candidate
export HOME=/tmp TZ=Asia/Shanghai
exec > ../results/redis-regression.log 2>&1
trap 'rc=$?; printf "%s\n" "$rc" > ../results/redis-regression.exit' EXIT
./runtest --clients 1 --single unit/cluster --single unit/type/string --single unit/keyspace --no-latency
echo PASS > ../results/redis-regression.status
