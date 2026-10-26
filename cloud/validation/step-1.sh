set -euo pipefail
test "$(uname -m)" = aarch64
export BENCH_ROOT="$RUNNER_TEMP/isa-l-arm-experiment"
printf 'BENCH_ROOT=%s\n' "$BENCH_ROOT" >> "$GITHUB_ENV"
mkdir -p "$BENCH_ROOT/results" "$BENCH_ROOT/corpus"
sudo apt-get update
sudo apt-get install -y build-essential autoconf automake libtool zlib1g-dev numactl python3
