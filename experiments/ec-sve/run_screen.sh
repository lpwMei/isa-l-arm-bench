#!/usr/bin/env bash
set -euo pipefail
ROOT="$RUNNER_TEMP/ec-sve-screen"
mkdir -p "$ROOT/results"
printf 'BENCH_ROOT=%s\n' "$ROOT" >> "$GITHUB_ENV"
test "$(uname -m)" = aarch64
CPU=$(python3 -c 'import os; print(min(os.sched_getaffinity(0)))')
{
  date -u
  uname -a
  lscpu
  gcc --version
  cat /proc/sys/abi/sve_default_vector_length
  printf 'pinned_upstream=%s\nexperiment_commit=%s\ncpu=%s\n' "$UPSTREAM_SHA" "$GITHUB_SHA" "$CPU"
} > "$ROOT/results/environment.txt" 2>&1
git init "$ROOT/baseline"
git -C "$ROOT/baseline" remote add origin https://github.com/intel/isa-l.git
git -C "$ROOT/baseline" fetch --depth 1 origin "$UPSTREAM_SHA"
git -C "$ROOT/baseline" checkout --detach FETCH_HEAD
test "$(git -C "$ROOT/baseline" rev-parse HEAD)" = "$UPSTREAM_SHA"
for VARIANT in compact1 compact2 group2; do
  python3 experiments/ec-sve/generate_candidates.py "$ROOT/baseline" "$ROOT/$VARIANT" "$VARIANT"
done
for VERSION in baseline compact1 compact2 group2; do
  SOURCE="$ROOT/$VERSION"
  (
    cd "$SOURCE"
    ./autogen.sh
    ./configure CFLAGS='-O3 -g'
    make -j"$(nproc)"
    make erasure_code/erasure_code_perf
  ) > "$ROOT/results/build-$VERSION.log" 2>&1
  taskset -c "$CPU" make -C "$SOURCE" check > "$ROOT/results/check-$VERSION.log" 2>&1
  objdump -d "$SOURCE/.libs/libisal.so" > "$ROOT/results/disassembly-$VERSION.txt"
  mkdir -p "$ROOT/results/$VERSION"
  printf '%s built and correctness tests passed\n' "$VERSION"
done
for ROUND in 1 2 3; do
  # Alternate full version order to limit time/order bias.
  if (( ROUND % 2 )); then ORDER='baseline compact1 compact2 group2'; else ORDER='group2 compact2 compact1 baseline'; fi
  for VERSION in $ORDER; do
    for PARITY in 2 4 6 7; do
      taskset -c "$CPU" "$ROOT/$VERSION/erasure_code/erasure_code_perf" -k 10 -p "$PARITY" -e 1 -s 64K \
        > "$ROOT/results/$VERSION/r${ROUND}-k10-p${PARITY}-s65536.log" 2>&1
    done
    printf 'round=%s version=%s complete\n' "$ROUND" "$VERSION"
  done
done
python3 experiments/ec-sve/summarize.py "$ROOT/results" --repeats 3
