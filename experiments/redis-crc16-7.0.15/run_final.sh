#!/usr/bin/env bash
set -euo pipefail
cd /work
export HOME=/tmp TZ=Asia/Shanghai
exec > results/final-run.log 2>&1
trap 'rc=$?; printf "%s\n" "$rc" > results/final-run.exit' EXIT
mkdir fallback
tar -xzf artifacts/redis-7.0.15-pristine.tar.gz -C fallback
git -C fallback apply --check ../artifacts/redis-7.0.15-kp950-crc16-pmull.patch
git -C fallback apply ../artifacts/redis-7.0.15-kp950-crc16-pmull.patch
make -C fallback -j8 CRC16_PMULL=no > results/build-fallback.log 2>&1
fallback/src/redis-server --version > results/fallback-version.txt
nm fallback/src/redis-server > results/fallback-symbols.txt
if grep -q crc16_xmodem_pmull results/fallback-symbols.txt; then
    echo 'CRC16_PMULL=no unexpectedly linked PMULL'; exit 1
fi
echo PASS > results/fallback-build.status
bash artifacts/run_regression.sh
bash artifacts/run_endurance.sh
echo PASS > results/final-run.status
