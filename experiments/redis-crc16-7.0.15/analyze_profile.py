"""Resolve host-side perf samples against the exact container executable.

perf cannot open /work/... on the host. `perf script -F ip,dso,period`
still contains absolute IPs; nm ranges for this non-PIE executable resolve them.
"""
import bisect
from collections import defaultdict
import json
from pathlib import Path
import subprocess

root = Path('/home/liupengwei/redis-crc16-20261026')
binary = root / 'baseline/src/redis-server'
symbols = []
for line in subprocess.check_output(['nm', '-n', '-S', '--defined-only', str(binary)], text=True).splitlines():
    fields = line.split()
    if len(fields) == 4 and fields[2] in ('T', 't'):
        start, size = int(fields[0], 16), int(fields[1], 16)
        if size:
            symbols.append((start, start + size, fields[3]))
symbols.sort()
starts = [s[0] for s in symbols]
periods = defaultdict(int)
counts = defaultdict(int)
for line in (root / 'results/profile-baseline-set-samples.txt').read_text().splitlines():
    fields = line.split()
    if len(fields) < 3:
        continue
    period, ip = int(fields[0]), int(fields[1], 16)
    name = fields[2]
    if name == '(/work/baseline/src/redis-server)':
        index = bisect.bisect_right(starts, ip) - 1
        if index >= 0 and symbols[index][0] <= ip < symbols[index][1]:
            name = symbols[index][2]
        else:
            name = f'unresolved-redis:0x{ip:x}'
    periods[name] += period
    counts[name] += 1
total = sum(periods.values())
output = {
    'scope': 'Baseline SET; current 10-billion-request run; 10 seconds; cycles:u; 499 Hz',
    'resolution': 'Absolute sampled IP mapped to exact nm -S function ranges; non-PIE executable mapped at 0x400000',
    'total_samples': sum(counts.values()),
    'total_user_cycle_period': total,
    'crc16_user_cycles_percent': 100 * periods['crc16'] / total,
    'crc16_sample_count': counts['crc16'],
    'crc16_address_range': [hex(s[0]) + '-' + hex(s[1]) for s in symbols if s[2] == 'crc16'],
    'symbols': [dict(symbol=n, user_cycles_percent=100*p/total, samples=counts[n])
                for n, p in sorted(periods.items(), key=lambda entry: -entry[1])],
    'limitations': 'User-mode cycles denominator excludes kernel time, waiting and other processes; no optimized-run profile yet; not itself an end-to-end Amdahl fraction.',
}
(root / 'results/profile-baseline-set-summary.json').write_text(json.dumps(output, indent=2))
print(json.dumps({k: v for k, v in output.items() if k != 'symbols'}, indent=2))
print(json.dumps(output['symbols'][:12], indent=2))
