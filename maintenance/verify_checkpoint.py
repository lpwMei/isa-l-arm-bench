"""Verify staged bytes against the archival SHA256 manifest."""
import argparse
import hashlib
import json
from pathlib import Path
import subprocess

parser = argparse.ArgumentParser()
parser.add_argument('--source', type=Path, help='Original workspace, to restore executable modes on Windows')
args = parser.parse_args()
root = Path(__file__).resolve().parents[1]

if args.source:
    import tarfile
    executable = set()
    revisions = json.loads((root/'maintenance/source-revisions.json').read_text())
    isa_modes = []
    for repo in revisions:
        data = subprocess.check_output(['git', '-C', str(args.source/repo['path']), 'ls-tree', '-r', '-z', 'HEAD'])
        for entry in data.split(b'\0'):
            if not entry:
                continue
            header, filename = entry.split(b'\t', 1)
            if header.split()[0] == b'100755':
                name = filename.decode()
                path = repo['path'] + '/' + name
                if (root/path).is_file():
                    executable.add(path)
                if repo['path'] == 'upstream/isa-l':
                    isa_modes.append(name)
    for archive in (args.source/'downloads').glob('*.tar'):
        with tarfile.open(archive) as handle:
            for member in handle:
                path = 'releases/' + member.name
                if member.isfile() and member.mode & 0o111 and (root/path).is_file():
                    executable.add(path)
    for variant in (root/'experiments/ec-sve').iterdir():
        if variant.is_dir():
            for name in isa_modes:
                path = variant/name
                if path.is_file():
                    executable.add(path.relative_to(root).as_posix())
    for path in root.rglob('*'):
        if not path.is_file() or '.git' in path.parts:
            continue
        with path.open('rb') as handle:
            if handle.read(2) == b'#!':
                executable.add(path.relative_to(root).as_posix())
    subprocess.run(['git', 'update-index', '--chmod=+x', '-z', '--stdin'], cwd=root,
                   input=b''.join(p.encode()+b'\0' for p in sorted(executable)), check=True)
    print('Executable modes restored:', len(executable))

manifest = json.loads((root/'CHECKPOINT-MANIFEST-2026-10-26.json').read_text())
index = {}
data = subprocess.check_output(['git','ls-files','-s','-z'], cwd=root)
for entry in data.split(b'\0'):
    if entry:
        header, filename = entry.split(b'\t',1)
        mode, sha, stage = header.decode().split()
        assert stage == '0'
        index[filename.decode()] = sha
process = subprocess.Popen(['git','cat-file','--batch'],cwd=root,stdin=subprocess.PIPE,stdout=subprocess.PIPE)
cache = {}
total = 0
for record in manifest['files']:
    path = record['path']
    assert path in index, f'Missing staged file: {path}'
    sha = index[path]
    if sha not in cache:
        process.stdin.write((sha+'\n').encode())
        process.stdin.flush()
        header = process.stdout.readline().decode().split()
        assert header[1] == 'blob', header
        remaining = int(header[2])
        digest = hashlib.sha256()
        while remaining:
            chunk = process.stdout.read(min(remaining,1024*1024))
            assert chunk
            digest.update(chunk)
            remaining -= len(chunk)
        assert process.stdout.read(1) == b'\n'
        cache[sha] = digest.hexdigest()
    assert cache[sha] == record['sha256'], f'Staged bytes changed: {path}'
    total += record['bytes']
process.stdin.close()
assert process.wait() == 0
print(f'PASS staged SHA256: {len(manifest["files"])} files, {total} bytes, {len(cache)} unique blobs')
