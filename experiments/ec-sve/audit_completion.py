#!/usr/bin/env python3
"""Audit the delivered patch against the original native ARM run's raw evidence."""
import hashlib
import json
import re
import statistics
import subprocess
import zipfile
from collections import defaultdict
from pathlib import Path

ROOT = Path(__file__).resolve().parents[2]
EXP = ROOT / 'experiments/ec-sve'
SOURCE = ROOT / 'upstream/isa-l'
PIN = '8fa1e72fee7338fcfbf829b00f2f407631bd2dba'
KERNEL = 'erasure_code/aarch64/gf_nvect_dot_prod_sve.c'
DRIVER = 'erasure_code/erasure_code_perf.c'
ARCHIVE_HASH = 'c888c43efdc66eb0a7560859fe6e2ce2ffc3237bf515265507222f856b70f897'


def git(*args):
    return subprocess.check_output(['git', '-c', f'safe.directory={SOURCE.as_posix()}',
                                    '-C', str(SOURCE), *args])


assert git('rev-parse', 'HEAD').decode().strip() == PIN
assert git('diff', '--name-only').decode().splitlines() == [KERNEL]
assert (SOURCE / DRIVER).read_bytes() == git('show', f'HEAD:{DRIVER}')
assert hashlib.sha256((EXP / 'table4-39434973237.zip').read_bytes()).hexdigest() == ARCHIVE_HASH
assert hashlib.sha256((EXP / 'ec-sve-table4.patch').read_bytes()).hexdigest() == \
       '95ea8299957f05e6afd3e619c988629197b7865ae84bb4abe04c51d5609f387b'
git('apply', '--reverse', '--check', str(EXP / 'ec-sve-table4.patch'))
git('apply', '--reverse', '--check', str(EXP / 'table4-39434973237/candidate.patch'))

evidence = json.loads((EXP / 'EC-EVIDENCE-2026-10-20.json').read_text(encoding='utf-8'))
assert evidence['baseline'] == PIN and evidence['artifact_sha256'] == ARCHIVE_HASH
with zipfile.ZipFile(EXP / 'table4-39434973237.zip') as archive:
    for name, value in evidence['files'].items():
        raw = archive.read(name)
        assert value['text'].encode('utf-8') == raw, name
        assert hashlib.sha256(raw).hexdigest() == value['sha256'], name

    env = archive.read('environment.txt').decode()
    assert 'Neoverse-N2' in env and 'aarch64' in env and 'cpu=0' in env and 'variant=table4' in env
    assert f'upstream={PIN}' in env and 'experiment=0251b745cac9b7eb9223371e4c23d0b1899934f3' in env
    driver_hashes = [line.split()[0] for line in archive.read('driver-sha256.txt').decode().splitlines()]
    assert driver_hashes == [hashlib.sha256(git('show', f'HEAD:{DRIVER}')).hexdigest()] * 2

    for version in ('baseline', 'candidate'):
        log = archive.read(f'check-{version}.log').decode()
        for field, expected in [('TOTAL', 17), ('PASS', 17), ('FAIL', 0), ('ERROR', 0)]:
            assert re.search(rf'# {field}:\s+{expected}\b', log), (version, field)
    assert 'PASS: 5544 matrix/length cases, 21816 encoder calls' in archive.read('check-boundaries.log').decode()
    for vq in (1, 2, 4):
        log = archive.read(f'vector-{vq}.log').decode()
        assert f'SVE vector length: {vq * 16} bytes' in log
        assert 'PASS: 2244 matrix/length cases, 8748 encoder calls' in log

    scores = defaultdict(dict)
    process_count = 0
    for name in archive.namelist():
        match = re.fullmatch(r'(main|guards)/(baseline|candidate)/r(\d+)-(k\d+-p\d+-s\d+)\.log', name)
        if not match:
            continue
        phase, version, round_id, case = match.groups()
        text = archive.read(name).decode()
        assert 'done all: Pass' in text, name
        found = re.findall(r'erasure_code_(encode|decode)_warm[^\n]*?=\s*([0-9.]+)\s+MB/s', text)
        assert len(found) == 2, name
        k, p, size = map(int, re.fullmatch(r'k(\d+)-p(\d+)-s(\d+)', case).groups())
        assert f'Testing with {k} data buffers and {p} parity buffers' in text
        assert f'{k+p}x{size} 1' in text
        for direction, score in found:
            scores[phase, version, case, direction][int(round_id)] = float(score)
        process_count += 1

    expected_main = {f'k10-p{p}-s65536' for p in (2, 4, 6, 7)}
    expected_guards = {f'k10-p{p}-s{s}' for p in (4, 6, 7) for s in (4096, 1048576)} | \
                      {'k4-p4-s65536', 'k16-p4-s65536'}
    results = []
    for phase, cases, repeats in [('main', expected_main, 7), ('guards', expected_guards, 3)]:
        assert {key[2] for key in scores if key[0] == phase} == cases
        for case in sorted(cases):
            for direction in ('encode', 'decode'):
                before, after = (scores[phase, v, case, direction] for v in ('baseline', 'candidate'))
                assert set(before) == set(after) == set(range(1, repeats + 1))
                gain = (statistics.median(after.values()) / statistics.median(before.values()) - 1) * 100
                target = direction == 'encode' and (phase == 'guards' or '-p2-' not in case)
                assert gain >= (10 if target else -3), (phase, case, direction, gain)
                results.append({'phase': phase, 'case': case, 'direction': direction,
                                'median_gain_pct': round(gain, 2), 'repeats': repeats})
    assert process_count == 104 and len(results) == 24

summary = {'baseline': PIN, 'native_run_url': evidence['run_url'],
           'archive_sha256': ARCHIVE_HASH, 'raw_process_logs': process_count,
           'performance_values': process_count * 2, 'checked_evidence_files': len(evidence['files']),
           'official_checks_per_version': 17, 'native_guarded_encoder_calls': 21816,
           'emulated_guarded_encoder_calls_per_width': 8748,
           'performance_gates': results,
           'kunpeng950_status': 'Not measured; real-server revalidation required',
           'status': 'PASS'}
(EXP / 'COMPLETION-AUDIT.json').write_text(json.dumps(summary, indent=2) + '\n', newline='\n')
print(json.dumps(summary, indent=2))
