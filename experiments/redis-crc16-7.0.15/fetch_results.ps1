$ErrorActionPreference = 'Stop'
$deliveryDirectory = $PSScriptRoot
$remoteDirectory = '/home/liupengwei/redis-crc16-20261026'
ssh -o BatchMode=yes 192.168.90.158 "cd $remoteDirectory && tar -czf artifacts/results-snapshot.tar.gz results"
if ($LASTEXITCODE -ne 0) { throw 'Remote snapshot failed' }
scp -q "192.168.90.158:$remoteDirectory/artifacts/results-snapshot.tar.gz" (Join-Path $deliveryDirectory 'results-snapshot.tar.gz')
if ($LASTEXITCODE -ne 0) { throw 'Snapshot download failed' }
tar -xzf (Join-Path $deliveryDirectory 'results-snapshot.tar.gz') -C $deliveryDirectory
if ($LASTEXITCODE -ne 0) { throw 'Snapshot extraction failed' }
python (Join-Path $deliveryDirectory 'summarize_results.py')
if ($LASTEXITCODE -ne 0) { throw 'Report generation failed' }
