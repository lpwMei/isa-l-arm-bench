#!/usr/bin/env bash
set -euo pipefail
cd /work
export HOME=/tmp
exec > results/container.log 2>&1
date -Ins
id
cat /etc/os-release
taskset -pc $$
bash artifacts/build_validate.sh
python3 artifacts/run_e2e.py --requests 2000000 --rounds 2 --label pilot
echo PASS > results/container.status
