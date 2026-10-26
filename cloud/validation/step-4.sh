set -euo pipefail
python3 - <<'PY'
import hashlib
import json
import os
import random
from pathlib import Path
root = Path(os.environ['BENCH_ROOT'])
rng = random.Random(20261020)
files = {
    'json-lines.bin': b''.join(
        (json.dumps({'id': i, 'kind': i % 23, 'payload': 'ISA-L ARM benchmark ' * (i % 8 + 1)}, sort_keys=True) + '\n').encode()
        for i in range(24000)
    ),
    'binary.bin': rng.randbytes(2 * 1024 * 1024),
    'repeated.bin': (b'123456789abcdef' * 1024 + b'\0' * 4096) * 128,
}
with (root / 'results' / 'corpus-sha256.txt').open('w') as manifest:
    for name, data in files.items():
        (root / 'corpus' / name).write_bytes(data)
        manifest.write(f'{hashlib.sha256(data).hexdigest()}  {name}  {len(data)} bytes\n')
PY
