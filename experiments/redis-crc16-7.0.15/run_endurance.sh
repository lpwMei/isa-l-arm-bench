#!/usr/bin/env bash
set -euo pipefail
cd /work
export HOME=/tmp TZ=Asia/Shanghai
exec > results/endurance.log 2>&1
trap 'rc=$?; printf "%s\n" "$rc" > results/endurance.exit' EXIT
date -Ins
id
cat /etc/os-release
# One billion is NOT substituted for the requested ten billion.
# Each variant performs 10,000,000,000 SETs, then 10,000,000,000 GETs.
python3 artifacts/run_e2e.py --requests 10000000000 --rounds 1 --label endurance
date -Ins
echo PASS > results/endurance.status
