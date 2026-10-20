#!/usr/bin/env bash
# Replay the exact cloud validation on a Linux AArch64 server, including Kunpeng950.
set -euo pipefail
if test "$#" != 1; then
  printf 'Usage: bash experiments/ec-sve/run_on_arm_server.sh {table4|adaptive_fused}\n' >&2
  exit 2
fi
case "$1" in table4|adaptive_fused) ;; *) printf 'Unknown variant\n' >&2; exit 2 ;; esac
test "$(uname -m)" = aarch64
for TOOL in git gcc make autoconf automake libtoolize taskset objdump python3; do
  command -v "$TOOL" >/dev/null || { printf 'Missing dependency: %s\n' "$TOOL" >&2; exit 2; }
done
cd "$(dirname "$0")/../.."
export UPSTREAM_SHA=8fa1e72fee7338fcfbf829b00f2f407631bd2dba
export VARIANT="$1"
export RUNNER_TEMP
RUNNER_TEMP=$(mktemp -d "${TMPDIR:-/tmp}/isa-l-ec-validation.XXXXXXXX")
export GITHUB_ENV="$RUNNER_TEMP/local-env.txt"
export GITHUB_SHA
GITHUB_SHA=$(git rev-parse HEAD 2>/dev/null || printf 'local-export')
touch "$GITHUB_ENV"
trap 'printf "Validation files preserved at: %s/ec-sve-validation/results\n" "$RUNNER_TEMP"' EXIT
bash experiments/ec-sve/run_validation.sh

