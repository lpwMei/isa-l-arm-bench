"""Single-node cluster A/B test. Both servers use the same baseline client."""
import argparse
import binascii
import csv
import io
import json
import os
from pathlib import Path
import random
import socket
import subprocess
import time

ROOT = Path(os.environ.get("CRC16_WORK", "/work"))
PORT = int(os.environ.get("CRC16_PORT", "36380"))
KEY = "k" * 52 + "__rand_int__"
assert len(KEY.encode()) == 64 and "{" not in KEY


class Redis:
    def __init__(self):
        self.sock = socket.create_connection(("127.0.0.1", PORT), timeout=10)
        self.stream = self.sock.makefile("rb")

    def read(self):
        line = self.stream.readline()
        if not line:
            raise RuntimeError("Redis disconnected")
        kind, value = line[:1], line[1:-2]
        if kind == b"-":
            raise RuntimeError(value.decode(errors="replace"))
        if kind == b"+":
            return value
        if kind == b":":
            return int(value)
        if kind == b"$":
            n = int(value)
            if n == -1:
                return None
            data = self.stream.read(n)
            assert self.stream.read(2) == b"\r\n"
            return data
        if kind == b"*":
            return [self.read() for _ in range(int(value))]
        raise RuntimeError(repr(line))

    @staticmethod
    def encode(*parts):
        parts = [p if isinstance(p, bytes) else str(p).encode() for p in parts]
        return (f"*{len(parts)}\r\n".encode() + b"".join(
            f"${len(p)}\r\n".encode() + p + b"\r\n" for p in parts))

    def call(self, *parts):
        self.sock.sendall(self.encode(*parts))
        return self.read()

    def close(self):
        self.stream.close()
        self.sock.close()


def slot(key):
    start = key.find(b"{")
    end = key.find(b"}", start + 1) if start >= 0 else -1
    if start >= 0 and end > start + 1:
        key = key[start + 1:end]
    return binascii.crc_hqx(key, 0) & 16383


def functionality(r):
    rng = random.Random(950015)
    keys = [b"", b"123456789", b"a{}b", b"a{b}c", b"a{b}{c}",
            b"a{{b}c", b"a{", b"a}", b"a{\0\xff}b"]
    for length in [1, 9, 15, 16, 31, 32, 63, 64, 65, 127, 128, 129, 255, 256, 4096]:
        keys.append(bytes(rng.getrandbits(8) for _ in range(length)))
        keys.append(b"prefix{" + b"x" * length + b"}suffix")
    keys.extend(bytes(rng.getrandbits(8) for _ in range(rng.randrange(1, 1025)))
                for _ in range(1000))
    for key in keys:
        assert r.call("CLUSTER", "KEYSLOT", key) == slot(key), repr(key)
    # Pipeline SET and GET: binary keys/values and ordering must survive intact.
    value = b"binary\0\xffvalue"
    for i in range(0, len(keys), 16):
        batch = keys[i:i + 16]
        r.sock.sendall(b"".join(r.encode("SET", k, value) for k in batch))
        assert all(r.read() == b"OK" for _ in batch)
        r.sock.sendall(b"".join(r.encode("GET", k) for k in batch))
        assert all(r.read() == value for _ in batch)
    assert r.call("GET", b"absent-key-for-validation") is None
    assert r.call("MSET", b"{same}a", b"1", b"{same}b", b"2") == b"OK"
    try:
        r.call("MGET", b"different-a", b"different-b")
        raise AssertionError("CROSSSLOT was not enforced")
    except RuntimeError as error:
        assert "CROSSSLOT" in str(error)
    r.call("FLUSHDB")
    return {"hash_slot_cases": len(keys), "binary_pipeline_set_get": "PASS",
            "same_slot_multikey": "PASS", "crossslot": "PASS"}


def info(text):
    return dict(line.split(":", 1) for line in text.decode().splitlines()
                if ":" in line and not line.startswith("#"))


def start(variant, path):
    path.mkdir(parents=True, exist_ok=False)
    conf = path / "redis.conf"
    conf.write_text(f"""bind 127.0.0.1
protected-mode yes
port {PORT}
cluster-enabled yes
cluster-config-file nodes.conf
cluster-node-timeout 5000
cluster-require-full-coverage yes
appendonly no
save ""
dir {path}
daemonize no
io-threads 1
maxmemory 512mb
maxmemory-policy noeviction
enable-debug-command local
""")
    log = (path / "server.log").open("w")
    process = subprocess.Popen(["taskset", "-c", "320", str(ROOT / variant / "src/redis-server"), str(conf)],
                               stdout=log, stderr=subprocess.STDOUT)
    log.close()
    try:
        for _ in range(100):
            if process.poll() is not None:
                raise RuntimeError((path / "server.log").read_text())
            try:
                r = Redis()
                break
            except OSError:
                time.sleep(0.1)
        else:
            raise RuntimeError("Redis startup timeout")
        assert r.call("CLUSTER", "ADDSLOTSRANGE", 0, 16383) == b"OK"
        for _ in range(100):
            cluster = info(r.call("CLUSTER", "INFO"))
            if cluster["cluster_state"] == "ok":
                break
            time.sleep(0.1)
        else:
            raise RuntimeError(cluster)
        assert cluster["cluster_known_nodes"] == "1"
        assert cluster["cluster_slots_assigned"] == "16384"
        (path / "cluster-info.txt").write_bytes(r.call("CLUSTER", "INFO"))
        return process, r
    except BaseException:
        process.terminate()
        process.wait(timeout=15)
        raise


def bench(r, command, requests, threads, logpath):
    args = ["taskset", "-c", "322,324,326,328", str(ROOT / "baseline/src/redis-benchmark"),
            "-h", "127.0.0.1", "-p", str(PORT), "-c", "200", "-P", "16",
            "-n", str(requests), "-r", "10000", "--csv"]
    if threads > 1:
        args.extend(["--threads", str(threads)])
    args.extend([command, KEY])
    if command == "SET":
        args.append("v" * 64)
    before = info(r.call("INFO", "stats"))
    cpu_before = info(r.call("INFO", "cpu"))
    start_time = time.monotonic()
    result = subprocess.run(args, capture_output=True, text=True, check=True)
    elapsed = time.monotonic() - start_time
    logpath.write_text(result.stdout)
    logpath.with_suffix(".stderr").write_text(result.stderr)
    logpath.with_suffix(".command.json").write_text(json.dumps(args, indent=2))
    if "error" in result.stderr.lower() or "error" in result.stdout.lower():
        raise RuntimeError(result.stderr + result.stdout)
    after = info(r.call("INFO", "stats"))
    cpu_after = info(r.call("INFO", "cpu"))
    assert int(after["total_error_replies"]) == int(before["total_error_replies"])
    rows = list(csv.DictReader(io.StringIO(result.stdout)))
    assert len(rows) == 1, rows
    data = {k: float(v) for k, v in rows[0].items() if k != "test"}
    delta = int(after["total_commands_processed"]) - int(before["total_commands_processed"])
    assert requests <= delta <= requests + 2000, (requests, delta)
    data.update(requests=requests, wall_seconds=elapsed, commands_observed=delta,
                server_user_seconds=float(cpu_after["used_cpu_user"]) - float(cpu_before["used_cpu_user"]),
                server_sys_seconds=float(cpu_after["used_cpu_sys"]) - float(cpu_before["used_cpu_sys"]))
    return data


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--requests", type=int, default=10000000)
    parser.add_argument("--rounds", type=int, default=6)
    parser.add_argument("--threads", type=int, default=1)
    parser.add_argument("--label", default="quick")
    args = parser.parse_args()
    resultdir = ROOT / "results" / args.label
    resultdir.mkdir(parents=True, exist_ok=False)
    records = []
    for roundnum in range(args.rounds):
        # ABBA counterbalances time drift; all variants use the same CPU/port/client.
        order = ["baseline", "candidate"] if roundnum % 2 == 0 else ["candidate", "baseline"]
        for variant in order:
            path = resultdir / f"round-{roundnum + 1}-{variant}"
            process, r = start(variant, path)
            try:
                checks = functionality(r)
                (path / "functional.json").write_text(json.dumps(checks, indent=2))
                bench(r, "SET", 200000, args.threads, path / "warmup-set.csv")
                bench(r, "GET", 200000, args.threads, path / "warmup-get.csv")
                for command in ["SET", "GET"]:
                    print(f"START {args.label} round={roundnum + 1} {variant} {command} n={args.requests}", flush=True)
                    data = bench(r, command, args.requests, args.threads, path / f"{command.lower()}.csv")
                    data.update(round=roundnum + 1, variant=variant, command=command, threads=args.threads)
                    records.append(data)
                    (resultdir / "measurements.json").write_text(json.dumps(records, indent=2))
                    print(f"DONE {variant} {command} {data['rps']:.2f} ops/s", flush=True)
                (path / "info-after.txt").write_bytes(r.call("INFO", "all"))
                # Verify the benchmark used real, existing 64-byte keys.
                keys = r.call("KEYS", "k*")
                assert len(keys) == 10000, len(keys)
                assert all(len(k) == 64 and r.call("STRLEN", k) == 64 for k in keys[:32])
                (path / "key-check.json").write_text(json.dumps({"keys": len(keys), "key_bytes": 64,
                    "value_bytes": 64, "get_hit_keyspace": True}, indent=2))
                assert info(r.call("CLUSTER", "INFO"))["cluster_state"] == "ok"
            finally:
                try:
                    r.call("SHUTDOWN", "NOSAVE")
                except (OSError, RuntimeError):
                    pass
                r.close()
                process.wait(timeout=15)
            assert process.returncode == 0, process.returncode
    (resultdir / "status.txt").write_text("PASS\n")
    print(f"PASS {args.label}: {len(records)} measurements", flush=True)


if __name__ == "__main__":
    main()
