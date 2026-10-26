#!/usr/bin/env python3
"""Preserve small, reviewable raw logs beyond Actions artifact retention."""
import argparse
import hashlib
import json
from pathlib import Path

p = argparse.ArgumentParser(description=__doc__)
p.add_argument('results', type=Path)
p.add_argument('output', type=Path)
p.add_argument('--run-id', type=int, required=True)
p.add_argument('--artifact-sha256', required=True)
a = p.parse_args()
files = {}
for path in sorted(a.results.rglob('*')):
    if not path.is_file():
        continue
    rel = path.relative_to(a.results).as_posix()
    if (rel.startswith(('main/', 'guards/')) or path.name.startswith(('check-', 'vector-'))
            or path.name in ('environment.txt', 'candidate.patch', 'driver-sha256.txt')):
        raw = path.read_bytes()
        files[rel] = {'sha256': hashlib.sha256(raw).hexdigest(), 'text': raw.decode('utf-8')}
assert 'main/summary.json' in files and 'candidate.patch' in files
evidence = {
    'run_url': f'https://github.com/lpwMei/isa-l-arm-bench/actions/runs/{a.run_id}',
    'artifact_sha256': a.artifact_sha256.lower(),
    'baseline': '8fa1e72fee7338fcfbf829b00f2f407631bd2dba',
    'files': files,
}
a.output.write_text(json.dumps(evidence, ensure_ascii=False, indent=2) + '\n', newline='\n')
print(f'Preserved {len(files)} raw log/manifest files in {a.output} ({a.output.stat().st_size} bytes)')
