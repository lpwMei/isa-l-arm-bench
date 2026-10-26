set -euo pipefail
for VERSION in baseline upstream; do
  if test "$VERSION" = baseline; then SHA="$BASELINE_SHA"; else SHA="$UPSTREAM_SHA"; fi
  SOURCE="$BENCH_ROOT/$VERSION"
  git init "$SOURCE"
  git -C "$SOURCE" remote add origin https://github.com/intel/isa-l.git
  git -C "$SOURCE" fetch --depth 1 origin "$SHA"
  git -C "$SOURCE" checkout --detach FETCH_HEAD
  test "$(git -C "$SOURCE" rev-parse HEAD)" = "$SHA"
  (
    cd "$SOURCE"
    ./autogen.sh
    ./configure CFLAGS='-O3 -g'
    make -j"$(nproc)"
    make -j"$(nproc)" perfs
    make igzip/igzip_perf
  ) > "$BENCH_ROOT/results/build-$VERSION.log" 2>&1
  cp "$SOURCE/config.log" "$BENCH_ROOT/results/config-$VERSION.log"
  taskset -c "$BENCH_CPU" make -C "$SOURCE" check \
    > "$BENCH_ROOT/results/check-$VERSION.log" 2>&1
done
