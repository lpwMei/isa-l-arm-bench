set -euo pipefail
for ROUND in $(seq 1 "$REPEATS"); do
  if (( ROUND % 2 )); then ORDER='baseline upstream'; else ORDER='upstream baseline'; fi
  for VERSION in $ORDER; do
    SOURCE="$BENCH_ROOT/$VERSION"
    OUT="$BENCH_ROOT/results/$VERSION/round-$ROUND"
    mkdir -p "$OUT"
    for CRC in iscsi gzip t10dif; do
      taskset -c "$BENCH_CPU" "$SOURCE/crc/crc_funcs_perf" \
        -t "$CRC" -s 16,64,256,1024,4096,65536,1048576 -c \
        > "$OUT/crc-$CRC.csv" 2>&1
    done
    for PARITY in 2 4 6 7; do
      taskset -c "$BENCH_CPU" "$SOURCE/erasure_code/erasure_code_perf" \
        -k 10 -p "$PARITY" -e 1 -s 64K \
        > "$OUT/ec-k10-p$PARITY.log" 2>&1
    done
    for CORPUS in json-lines binary repeated; do
      taskset -c "$BENCH_CPU" "$SOURCE/igzip/igzip_perf" \
        -l 1 -d 0 -i 3 -t -s -b 4096 "$BENCH_ROOT/corpus/$CORPUS.bin" \
        > "$OUT/inflate-$CORPUS.log" 2>&1
      if grep -qi 'Error in .*inflate' "$OUT/inflate-$CORPUS.log"; then
        cat "$OUT/inflate-$CORPUS.log"
        exit 1
      fi
    done
  done
done
{
  printf 'Native architecture: %s\n' "$(uname -m)"
  printf 'The uploaded logs contain five alternating A/B rounds on CPU %s.\n' "$BENCH_CPU"
  printf 'baseline: ISA-L v2.32.1 at %s\n' "$BASELINE_SHA"
  printf 'upstream: pinned master at %s\n' "$UPSTREAM_SHA"
  printf 'Only public upstream code was tested; no new optimization patch is included.\n'
  printf 'igzip_perf measures raw DEFLATE, not complete ZIP extraction.\n'
  printf 'Cloud CPU results do not establish a Kunpeng 950 performance gain.\n'
} | tee "$BENCH_ROOT/results/README.txt"
