set -euo pipefail
{
  date -u
  uname -a
  lscpu
  numactl --hardware
  gcc --version
  as --version
  ldd --version
  cat /proc/cpuinfo
  if test -r /proc/sys/abi/sve_default_vector_length; then
    cat /proc/sys/abi/sve_default_vector_length
  fi
} > "$BENCH_ROOT/results/environment.txt" 2>&1
CPU=$(python3 -c 'import os; print(min(os.sched_getaffinity(0)))')
printf 'BENCH_CPU=%s\n' "$CPU" >> "$GITHUB_ENV"
printf 'cpu=%s\nbaseline=%s\nupstream=%s\nrepeats=%s\n' \
  "$CPU" "$BASELINE_SHA" "$UPSTREAM_SHA" "$REPEATS" \
  > "$BENCH_ROOT/results/manifest.txt"
cat "$BENCH_ROOT/results/manifest.txt"
