#!/usr/bin/env bash
set -euo pipefail
ROOT="$RUNNER_TEMP/ec-sve-validation"
mkdir -p "$ROOT/results/main" "$ROOT/results/guards"
printf 'BENCH_ROOT=%s\n' "$ROOT" >> "$GITHUB_ENV"
test "$(uname -m)" = aarch64
CPU=$(python3 -c 'import os; print(min(os.sched_getaffinity(0)))')
PHASE=${1:-all}
if test "$PHASE" = all || test "$PHASE" = build; then
{
  date -u
  uname -a
  lscpu
  gcc --version
  as --version
  cat /proc/sys/abi/sve_default_vector_length
  printf 'upstream=%s\nexperiment=%s\ncpu=%s\nvariant=%s\n' "$UPSTREAM_SHA" "$GITHUB_SHA" "$CPU" "$VARIANT"
} > "$ROOT/results/environment.txt" 2>&1
git init "$ROOT/baseline"
git -C "$ROOT/baseline" remote add origin https://github.com/intel/isa-l.git
git -C "$ROOT/baseline" fetch --depth 1 origin "$UPSTREAM_SHA"
git -C "$ROOT/baseline" checkout --detach FETCH_HEAD
test "$(git -C "$ROOT/baseline" rev-parse HEAD)" = "$UPSTREAM_SHA"
python3 experiments/ec-sve/generate_candidates.py "$ROOT/baseline" "$ROOT/candidate" "$VARIANT"
for FILE in erasure_code/aarch64/gf_nvect_dot_prod_sve.c erasure_code/aarch64/ec_aarch64_highlevel_func.c; do
  diff -u --label "a/$FILE" --label "b/$FILE" "$ROOT/baseline/$FILE" "$ROOT/candidate/$FILE" \
    >> "$ROOT/results/candidate.patch" || test "$?" = 1
done
for VERSION in baseline candidate; do
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
  # Same official driver and flags; only the library implementation differs.
  sha256sum "$SOURCE/erasure_code/erasure_code_perf.c" >> "$ROOT/results/driver-sha256.txt"
  if test "$VERSION" = candidate; then
    gcc -O2 -Wall -Wextra -I"$SOURCE/include" experiments/ec-sve/check_boundaries.c \
      "$SOURCE/.libs/libisal.a" -o "$ROOT/check_boundaries"
    taskset -c "$CPU" "$ROOT/check_boundaries" > "$ROOT/results/check-boundaries.log" 2>&1
  fi
  mkdir -p "$ROOT/results/main/$VERSION" "$ROOT/results/guards/$VERSION"
  printf '%s built and tests passed\n' "$VERSION"
done
test "$(cut -d ' ' -f1 "$ROOT/results/driver-sha256.txt" | sort -u | wc -l)" = 1
fi
if test "$PHASE" = all || test "$PHASE" = main; then
for ROUND in 1 2 3 4 5 6 7; do
  if (( ROUND % 2 )); then ORDER='baseline candidate'; else ORDER='candidate baseline'; fi
  for VERSION in $ORDER; do
    for PARITY in 2 4 6 7; do
      taskset -c "$CPU" "$ROOT/$VERSION/erasure_code/erasure_code_perf" -k 10 -p "$PARITY" -e 1 -s 64K \
        > "$ROOT/results/main/$VERSION/r${ROUND}-k10-p${PARITY}-s65536.log" 2>&1
    done
  done
  printf 'main round %s/7 complete\n' "$ROUND"
done
python3 experiments/ec-sve/summarize.py "$ROOT/results/main" --repeats 7
fi
if test "$PHASE" = all || test "$PHASE" = guards; then
for ROUND in 1 2 3; do
  if (( ROUND % 2 )); then ORDER='candidate baseline'; else ORDER='baseline candidate'; fi
  for VERSION in $ORDER; do
    for CASE in 10:4:4096 10:6:4096 10:7:4096 10:4:1048576 10:6:1048576 10:7:1048576 4:4:65536 16:4:65536; do
      IFS=: read -r K P S <<< "$CASE"
      taskset -c "$CPU" "$ROOT/$VERSION/erasure_code/erasure_code_perf" -k "$K" -p "$P" -e 1 -s "$S" \
        > "$ROOT/results/guards/$VERSION/r${ROUND}-k${K}-p${P}-s${S}.log" 2>&1
    done
  done
  printf 'guard round %s/3 complete\n' "$ROUND"
done
python3 experiments/ec-sve/summarize.py "$ROOT/results/guards" --repeats 3
fi
if test "$PHASE" = all || test "$PHASE" = gate; then
python3 - "$ROOT/results/main/summary.json" <<'PY'
import json
import sys
rows = [r for r in json.load(open(sys.argv[1])) if r['version'] == 'candidate']
assert len(rows) == 8
for r in rows:
    target = r['direction'] == 'encode' and '-p2-' not in r['case']
    assert r['gain_pct'] >= (10 if target else -3), r
print('PASS: all three encoding targets >=10%, p2 encoding and recovery guards >=-3%')
PY
fi

