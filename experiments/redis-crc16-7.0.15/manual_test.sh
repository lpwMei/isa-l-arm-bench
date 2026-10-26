# Source this file from an interactive Bash inside the dedicated manual container.
set -euo pipefail
export HOME=/tmp TZ=Asia/Shanghai
CLI=/manual/bin/redis-cli
BENCH=/manual/bin/redis-benchmark
PORT=36381
SERVER_CPU=340
CLIENT_CPU=342
KEY=$(printf 'k%.0s' {1..64})
VALUE=xxx
[[ ${#KEY} == 64 ]]
RUN=''
VARIANT=''

start_redis() {
    local variant=${1:?Use baseline or optimized}
    case "$variant" in baseline|optimized) ;; *) echo 'Use baseline or optimized'; return 1;; esac
    # Refuse occupied data or cluster-bus ports, including unrelated processes.
    python3 - <<'PY'
import socket
for port in (36381, 46381):
    with socket.socket() as sock:
        sock.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 1)
        sock.bind(('127.0.0.1', port))
PY
    RUN=$(mktemp -d "/manual/runs/${variant}.XXXXXX")
    VARIANT=$variant
    cat > "$RUN/redis.conf" <<EOF
bind 127.0.0.1
protected-mode yes
port $PORT
cluster-enabled yes
cluster-config-file nodes.conf
cluster-node-timeout 5000
cluster-require-full-coverage yes
appendonly no
save ""
dir $RUN
daemonize yes
pidfile $RUN/redis.pid
logfile $RUN/server.log
io-threads 1
maxmemory 512mb
maxmemory-policy noeviction
EOF
    taskset -c "$SERVER_CPU" "/manual/bin/redis-server-$VARIANT" "$RUN/redis.conf"
    local ready=no
    for i in {1..100}; do
        if "$CLI" -p "$PORT" PING 2>/dev/null | grep -q PONG; then ready=yes; break; fi
        sleep 0.1
    done
    if [[ $ready != yes ]]; then cat "$RUN/server.log"; return 1; fi
    "$CLI" -p "$PORT" CLUSTER ADDSLOTSRANGE 0 16383
    ready=no
    for i in {1..100}; do
        if "$CLI" -p "$PORT" CLUSTER INFO | grep -q 'cluster_state:ok'; then ready=yes; break; fi
        sleep 0.1
    done
    if [[ $ready != yes ]]; then cat "$RUN/server.log"; return 1; fi
    "$CLI" -p "$PORT" CLUSTER INFO | tee "$RUN/cluster-info.txt"
    taskset -apc "$(cat "$RUN/redis.pid")"
    printf 'Started %s; logs: %s\n' "$VARIANT" "$RUN"
}

assert_own_server() {
    [[ -n $RUN && -f $RUN/redis.pid ]]
    local actual
    actual=$("$CLI" -p "$PORT" INFO server | tr -d '\r' | sed -n 's/^process_id://p')
    [[ $actual == "$(cat "$RUN/redis.pid")" ]]
}

run_bench() {
    assert_own_server
    local n=${1:-10000}
    [[ $n =~ ^[1-9][0-9]*$ ]]
    printf '%s: key=%sB value=%sB connections=200 pipeline=16 n=%s per command\n' "$VARIANT" "${#KEY}" "${#VALUE}" "$n"
    printf '\nMeasured SET\n'
    taskset -c "$CLIENT_CPU" "$BENCH" -p "$PORT" -c 200 -n "$n" -P 16 SET "$KEY" xxx | tee "$RUN/set.txt"
    printf '\nMeasured GET\n'
    taskset -c "$CLIENT_CPU" "$BENCH" -p "$PORT" -c 200 -n "$n" -P 16 GET "$KEY" | tee "$RUN/get.txt"
    "$CLI" -p "$PORT" INFO all > "$RUN/info-after.txt"
    printf 'Results saved to %s\n' "$RUN"
}

stop_redis() {
    if [[ -n $RUN && -f $RUN/redis.pid ]]; then
        assert_own_server
        "$CLI" -p "$PORT" SHUTDOWN NOSAVE
        for i in {1..100}; do
            [[ ! -f $RUN/redis.pid ]] && break
            sleep 0.1
        done
        echo "Stopped $VARIANT"
    fi
}

trap stop_redis EXIT
printf 'Ready. Use: start_redis baseline; run_bench 10000; stop_redis\n'
printf 'Then: start_redis optimized; run_bench 10000; stop_redis\n'
