"""Copy the complete project checkpoint, preserving bytes and source provenance."""
import argparse
from datetime import datetime, timezone, timedelta
import hashlib
import json
import os
from pathlib import Path
import re
import shutil
import subprocess
import tarfile
import zipfile

parser = argparse.ArgumentParser()
parser.add_argument('--source', type=Path, required=True)
parser.add_argument('--destination', type=Path, required=True)
args = parser.parse_args()
source = args.source.resolve()
dest = args.destination.resolve()
assert source != dest and source in dest.parents
roots = ['analysis', 'cloud', 'experiments', 'tools', 'downloads', 'releases', 'upstream']
excluded_names = {'.git', '__pycache__', '.pytest_cache', '.mypy_cache', '.ruff_cache'}
excluded_prefixes = ['cloud/validation/python-deps']
records = []
skipped = []
patterns = {
    'github_token': re.compile(rb'\bgh[pousr]_[A-Za-z0-9]{30,}'),
    'github_fine_grained_token': re.compile(rb'github_pat_[A-Za-z0-9_]{50,}'),
    'aws_access_key': re.compile(rb'\b(?:AKIA|ASIA)[A-Z0-9]{16}\b'),
    'provided_server_credential': re.compile(rb'Agentic\d+[#][$]'),
    'openssh_private_key': re.compile(rb'-----BEGIN OPENSSH PRIVATE KEY-----'),
}
findings = []


def inspect_bytes(data, location):
    for name, pattern in patterns.items():
        if pattern.search(data):
            findings.append(dict(path=location, pattern=name))


def inspect_file(path, relative):
    data = path.read_bytes()
    inspect_bytes(data, relative)
    if zipfile.is_zipfile(path):
        with zipfile.ZipFile(path) as archive:
            for entry in archive.infolist():
                if not entry.is_dir():
                    inspect_bytes(archive.read(entry), relative + '!/' + entry.filename)
    elif str(path).endswith(('.tar.gz', '.tgz', '.tar')):
        with tarfile.open(path) as archive:
            for entry in archive:
                if entry.isfile():
                    handle = archive.extractfile(entry)
                    if handle:
                        inspect_bytes(handle.read(), relative + '!/' + entry.name)
    return hashlib.sha256(data).hexdigest()


for name in roots:
    base = source / name
    for current, dirs, files in os.walk(base):
        current_path = Path(current)
        dirs[:] = sorted(d for d in dirs if d not in excluded_names and
                         not any((current_path / d).relative_to(source).as_posix().startswith(p)
                                 for p in excluded_prefixes))
        for filename in sorted(files):
            if filename in excluded_names or filename.endswith(('.pyc', '.pyo')):
                skipped.append((current_path / filename).relative_to(source).as_posix())
                continue
            original = current_path / filename
            relative = original.relative_to(source)
            target = dest / relative
            target.parent.mkdir(parents=True, exist_ok=True)
            shutil.copy2(original, target)
            checksum = inspect_file(target, relative.as_posix())
            records.append(dict(path=relative.as_posix(), bytes=target.stat().st_size, sha256=checksum))
    print(f'Copied and checked {name}', flush=True)

# The publication script is itself useful work and belongs in the checkpoint.
(dest / 'maintenance').mkdir(exist_ok=True)
shutil.copy2(__file__, dest / 'maintenance/prepare_checkpoint.py')
revisions = []
repos = ['upstream/crc16_bench', 'upstream/redis-7.0.15', 'upstream/redis',
         'upstream/isa-l', 'upstream/isa-l_crypto', 'tools/FlameGraph']
for name in repos:
    repo = source / name
    def git(*command):
        return subprocess.check_output(['git', '-C', str(repo), *command], text=True).strip()
    revisions.append(dict(path=name, remote=git('remote', 'get-url', 'origin'),
                          commit=git('rev-parse', 'HEAD'),
                          working_changes=git('status', '--short').splitlines()))
(dest / 'maintenance/source-revisions.json').write_text(json.dumps(revisions, indent=2), encoding='utf-8')

# Also check the actual tested binary archive fetched from the target machine.
for path in (dest / 'deliverables').rglob('*'):
    if path.is_file():
        relative = path.relative_to(dest).as_posix()
        records.append(dict(path=relative, bytes=path.stat().st_size, sha256=inspect_file(path, relative)))

if findings:
    (dest / 'maintenance/publication-scan-findings.json').write_text(json.dumps(findings, indent=2), encoding='utf-8')
    raise SystemExit(f'Publication stopped: {len(findings)} credential-pattern findings; values not printed')

snapshot = dict(created_at=datetime.now(timezone(timedelta(hours=8))).isoformat(timespec='seconds'),
                scope='All local ISA-L project source, reports, experimental variants, evidence, packages and tested binaries',
                file_count=len(records), total_bytes=sum(r['bytes'] for r in records),
                excluded_directories=sorted(excluded_names) + excluded_prefixes,
                excluded_cache_files=skipped,
                credential_pattern_scan='No matches in files or direct archive members',
                files=records)
(dest / 'CHECKPOINT-MANIFEST-2026-10-26.json').write_text(json.dumps(snapshot, indent=2, ensure_ascii=False), encoding='utf-8')
(dest / '.gitattributes').write_text('''# Archive exact bytes so published SHA256 manifests remain valid.
* -text
*.data binary
*.zip binary
*.gz binary
*.tar binary
*.png binary
*.rdb binary
*.pyd binary
''', encoding='utf-8', newline='\n')
(dest / '.gitignore').write_text('__pycache__/\n*.pyc\n*.pyo\n', encoding='utf-8', newline='\n')
print(json.dumps({k:v for k,v in snapshot.items() if k != 'files' and k != 'excluded_cache_files'}, ensure_ascii=False))
