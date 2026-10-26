"""Host-side observation only; this script never issues Redis workload commands."""
from datetime import datetime, timezone, timedelta
import json
import os
from pathlib import Path
import shutil
import subprocess
import time

ROOT = Path('/home/liupengwei/redis-crc16-20261026')
MANUAL = Path(os.environ.get('CRC16_TEST_ROOT', str(ROOT / 'manual')))
RUN = MANUAL / 'short-command-results'
OUT = MANUAL / 'profile-results'
OUT.mkdir(exist_ok=False)
SYMFS = OUT / 'symfs'
FG = ROOT / 'artifacts/FlameGraph'
HZ = os.sysconf('SC_CLK_TCK')


def now():
    return datetime.now(timezone(timedelta(hours=8))).isoformat(timespec='seconds')


def stage():
    path = RUN / 'stage.txt'
    return path.read_text().strip() if path.exists() else ''


def get_server(variant):
    expected = f'/manual/bin/redis-server-{variant} 127.0.0.1:36381'
    found = []
    for path in Path('/proc').glob('[0-9]*/cmdline'):
        try:
            if expected in path.read_bytes().replace(b'\0', b' ').decode(errors='replace'):
                found.append(int(path.parent.name))
        except (OSError, PermissionError):
            pass
    assert len(found) == 1, found
    return found[0]


def cpu_times(pid):
    text = Path(f'/proc/{pid}/stat').read_text().rsplit(')', 1)[1].split()
    return int(text[11]) / HZ, int(text[12]) / HZ


def mirror_symbols(pid):
    for line in Path(f'/proc/{pid}/maps').read_text().splitlines():
        parts = line.split(maxsplit=5)
        if len(parts) < 6 or not parts[5].startswith('/'):
            continue
        path = parts[5]
        source = Path(f'/proc/{pid}/root{path}')
        target = SYMFS / path.lstrip('/')
        if target.exists():
            continue
        target.parent.mkdir(parents=True, exist_ok=True)
        shutil.copyfile(source, target)


records = []
for variant, op in [('baseline', 'set'), ('baseline', 'get'),
                    ('optimized', 'set'), ('optimized', 'get')]:
    expected = f'{variant}-{op}'
    deadline = time.monotonic() + 600
    while stage() != expected:
        if stage() == 'done' or time.monotonic() > deadline:
            raise RuntimeError(f'Missed stage {expected}: current={stage()}')
        time.sleep(0.5)
    time.sleep(5)
    assert stage() == expected, stage()
    pid = get_server(variant)
    mirror_symbols(pid)
    start_user, start_sys = cpu_times(pid)
    start_time = time.monotonic()
    started_at = now()
    prefix = OUT / expected
    args = ['perf', 'record', '-e', 'cycles:u', '-F', '199', '--call-graph', 'dwarf,8192',
            '-p', str(pid), '-o', str(prefix.with_suffix('.data')), '--', 'sleep', '30']
    print(f'{now()} PROFILE START {expected} pid={pid}', flush=True)
    with prefix.with_suffix('.record.log').open('w') as log:
        subprocess.run(args, stdout=log, stderr=subprocess.STDOUT, check=True)
    end_user, end_sys = cpu_times(pid)
    elapsed = time.monotonic() - start_time
    assert stage() == expected, f'Profile crossed workload boundary: {expected} -> {stage()}'
    with prefix.with_suffix('.report.txt').open('w') as out:
        subprocess.run(['perf', 'report', '-i', str(prefix.with_suffix('.data')),
                        '--symfs', str(SYMFS), '--stdio', '--no-children', '--call-graph', 'none',
                        '--percent-limit', '0', '--sort', 'dso,symbol'], stdout=out, check=True)
    with prefix.with_suffix('.script').open('w') as out:
        subprocess.run(['perf', 'script', '-i', str(prefix.with_suffix('.data')),
                        '--symfs', str(SYMFS), '-F', 'comm,pid,tid,time,period,event,ip,sym,dso'],
                       stdout=out, check=True)
    with prefix.with_suffix('.folded').open('w') as out:
        subprocess.run(['perl', str(FG / 'stackcollapse-perf.pl'), str(prefix.with_suffix('.script'))],
                       stdout=out, check=True)
    with prefix.with_suffix('.svg').open('w') as out:
        subprocess.run(['perl', str(FG / 'flamegraph.pl'), '--title', f'Redis 7.0.15 {variant} {op.upper()}',
                        '--subtitle', 'Fixed 64B key; c200 P16; cycles:u; 30s @199Hz',
                        '--countname', 'cycles', '--width', '1500', str(prefix.with_suffix('.folded'))],
                       stdout=out, check=True)
    stacks = [(s.split(';'), int(n)) for s, n in
              (line.rsplit(' ', 1) for line in prefix.with_suffix('.folded').read_text().splitlines())]
    total = sum(n for s, n in stacks)
    crc_names = {'crc16', 'crc16_xmodem', 'crc16_xmodem_short', 'crc16_xmodem_pmull'}
    crc = sum(n for s, n in stacks if crc_names.intersection(s))
    user, system = end_user - start_user, end_sys - start_sys
    record = dict(stage=expected, pid=pid, started_at=started_at,
                  profile_wall_seconds=elapsed, server_user_seconds=user,
                  server_sys_seconds=system, process_cpu_busy_fraction=(user + system) / elapsed,
                  crc16_user_cycles_percent=100 * crc / total, cycle_period_total=total,
                  crc16_cycle_period=crc, perf_command=args,
                  command_count=100000000, key_bytes=64, keyspace=1,
                  exact_benchmark_command=['taskset', '-c', '342', '/manual/bin/redis-benchmark',
                      '-p', '36381', '-c', '200', '-n', '100000000', '-P', '16', op.upper(), 'k' * 64] +
                      (['xxx'] if op == 'set' else []))
    records.append(record)
    (OUT / 'summary.json').write_text(json.dumps(records, indent=2))
    print(f'{now()} PROFILE DONE {expected}: CRC16={record["crc16_user_cycles_percent"]:.3f}% user cycles', flush=True)

deadline = time.monotonic() + 600
while stage() != 'done':
    if time.monotonic() > deadline:
        raise RuntimeError('Timed out waiting for benchmark completion')
    time.sleep(1)
assert (RUN / 'status.txt').read_text().strip() == 'PASS'
(OUT / 'status.txt').write_text('PASS\n')
print(f'{now()} PASS all four short-command workloads and profiles', flush=True)
