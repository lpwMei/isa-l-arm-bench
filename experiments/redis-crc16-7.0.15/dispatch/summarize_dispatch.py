"""Validate and summarize the selected original-dispatch integration."""
from datetime import datetime, timezone, timedelta
import hashlib
import json
from pathlib import Path
import re

ROOT = Path(__file__).resolve().parent
DATA = ROOT / 'test-results/dispatch-work'
RUN = DATA / 'short-command-results'
PROFILES = DATA / 'profile-results'
BUILD = DATA / 'build-results'
for path in [RUN / 'status.txt', PROFILES / 'status.txt', BUILD / 'status.txt']:
    assert path.read_text().strip() == 'PASS', path
for name in ['correctness.txt', 'nohw-correctness.txt', 'scalar-correctness.txt', 'route-test.txt']:
    assert (BUILD / name).read_text().startswith('PASS'), name
assert 'All tests passed without errors!' in (BUILD / 'redis-regression.log').read_text()
assert 'failures=0' in (BUILD / 'seed-test.txt').read_text()
slots = json.loads((BUILD / 'cluster-slot-cases.json').read_text())
assert len(slots) == 34 and all(c['expected'] == c['got'] for c in slots)
assert any(c['key'] == 'a' * 17 and c['got'] == 3700 for c in slots)
records = json.loads((PROFILES / 'summary.json').read_text())
assert len(records) == 4
table = '| 版本 | 操作 | 请求数 | 耗时(s) | 吞吐(ops/s) | CRC16相关栈 / 用户态cycles |\n'
table += '|---|---|---:|---:|---:|---:|\n'
for record in records:
    name = record['stage']
    output = (RUN / f'{name}.txt').read_text()
    count, seconds = re.search(r'(\d+) requests completed in ([\d.]+) seconds', output).groups()
    assert int(count) == 100000000
    record.update(requests_completed=int(count), benchmark_seconds=float(seconds),
                  rps=float(re.search(r'throughput summary: ([\d.]+) requests per second', output).group(1)))
    assert 'Total Lost Samples: 0' in (PROFILES / f'{name}.report.txt').read_text()
    variant, op = name.split('-')
    label = '原版' if variant == 'baseline' else '完整dispatch＋尾部修复'
    table += f'| {label} | {op.upper()} | {int(count):,} | {float(seconds):.2f} | {record["rps"]:,.2f} | {record["crc16_user_cycles_percent"]:.2f}% |\n'
for variant in ['baseline', 'optimized']:
    info = (RUN / f'{variant}-info.txt').read_text()
    for op in ['set', 'get']:
        assert int(re.search(rf'cmdstat_{op}:calls=(\d+)', info).group(1)) == 100000000
    assert re.search(r'^total_error_replies:0$', info, re.M)
    assert re.search(r'^keyspace_misses:0$', info, re.M)
    assert (RUN / f'{variant}-dbsize.txt').read_text().strip() == '1'
manifest = json.loads((ROOT / 'selected-import-manifest.json').read_text())
assert manifest['changed_upstream_files'] == ['crc16_xmodem_short.S']
now = datetime.now(timezone(timedelta(hours=8))).isoformat(timespec='seconds')
report = f'''# 完整上游dispatch接入与复测报告

生成时间：{now}。目标：Redis 7.0.15，192.168.90.158 / Kunpeng 950 / openEuler 24.03 LTS SP3。

## 最终实现

已改为Redis crc16()统一调用上游crc16_xmodem()，由crc16_xmodem_dispatch.c决定路径：

| 输入长度 | 上游原有分支 |
|---|---|
| 0–15B | dispatcher中的标量查表 |
| 16–63B | crc16_xmodem_short |
| 64B及以上 | crc16_xmodem_pmull（4way） |

crc16_xmodem_dispatch.c与上游提交f8e9dbea5bd065823f0f77532136851e1d25dd0c字节一致。4way、8way、opt和常量头也原样导入，8way与opt一并链接保留；上游dispatch本身没有8way选择分支，本次未自行增加阈值。负长度保持Redis原有语义；不支持PMULL的平台保留原算法。950上所有非负长度均进入原dispatch，已用链接包装计数测试验证。

唯一修改的上游文件是crc16_xmodem_short.S中的尾部处理，得到用户明确同意后采用。原始导入SHA256与最终SHA256分别见upstream-import-manifest.json和selected-import-manifest.json。

## 原样版本的问题及修复

上游short在16–63B且长度非16倍数时，把不足16B的尾部补零后参与CRC，计算结果与Redis不一致。

最小反例：17个a，标准CRC16/XMODEM为0xce74（槽3700），原样dispatch返回0x0217（槽535）。原样probe共65,792个用例，失败11,520个；原始输出保存在test-results/dispatch-results/upstream-dispatch-probe.txt。

修复保留dispatch文件、阈值及各算法选择：先折叠完整16B块、归约出CRC，再以该CRC为seed，对真实剩余0–15B调用现有逐字节路径，避免补零。对应独立补丁是redis-7.0.15-crc16-short-tail-fix.patch，可逐行审核。

上游自带正确性测试虽然声明了dispatch/short接口，但实际只对比4way/opt/8way，没有调用dispatch或short做正确性验证，因此原有make test不能覆盖该问题。

## 验证

- 完整dispatch路径、模拟无PMULL硬件回退、纯标量路径，各362,327个差分用例通过；包括全部双字节组合、0–4096长度与64种偏移、随机/固定二进制数据、1MiB输入及前后保护页。
- 包含四种seed、64种偏移、0–256长度的65,792个直接dispatch用例，修复后全部通过。
- 129个非负长度路由测试：全部进入上游dispatch；16–63B确实调用short，64B及以上确实调用4way。short修复后用原scalar路径接续余数。
- 实际Redis集群34个长度边界/hash tag槽位检查通过，包含17字节反例，槽位恢复3700。
- Redis原生unit/cluster、unit/type/string、unit/keyspace测试全部通过。
- 导入文件SHA256检查、最终二进制符号检查通过；GNU_STACK为RW。

证据均在test-results/dispatch-work/build-results/。

## 用户指定短命令复测

计时负载只有以下两条命令，只增大-n，不增加随机key空间、预热、-d、--csv或--threads：

```bash
KEY=$(printf 'k%.0s' {{1..64}})
taskset -c 342 /manual/bin/redis-benchmark -p 36381 -c 200 -n 100000000 -P 16 SET "$KEY" xxx
taskset -c 342 /manual/bin/redis-benchmark -p 36381 -c 200 -n 100000000 -P 16 GET "$KEY"
```

原版及新版本SET/GET各1亿请求，总计4亿请求。Redis固定CPU340，客户端固定342，属于Socket1不同物理核；单节点持有全部槽位。UID/GID1007，编译器GCC12.3.1，jemalloc5.2.1。沿用相同容器镜像和客户端。主机非独占，未实施IRQ隔离。

{table}

每项运行中采集30秒cycles:u DWARF调用栈，无丢样且未跨越阶段边界。分母为相应Redis进程的用户态cycles，不含内核与等待；CRC16相关栈统计crc16、crc16_xmodem、short、4way的并集，不重复累计父子帧。吞吐含采样开销，单轮数据不能代替多轮稳定收益。

本轮64B key按原始dispatch仍选择4way；短输入分支的正确性由独立边界、路由及真实槽位用例验证，本轮不代表短输入的端到端收益。

## 火焰图与原始数据

test-results/dispatch-work/profile-results/内有baseline-set.svg、baseline-get.svg、optimized-set.svg、optimized-get.svg及对应PNG预览。浏览器打开SVG后Search输入crc16，可查看所有CRC相关帧合计占比。

同目录保留每项原始.data、解码.script、折叠.folded、.report.txt、.record.log及summary.json。服务器完整工作目录为/home/liupengwei/redis-crc16-20261026/dispatch-work。原样失败probe另存于/home/liupengwei/redis-crc16-20261026/dispatch-results。

## 补丁使用

默认交付redis-7.0.15-crc16-dispatch-fixed.patch，可直接应用到干净7.0.15。它已经包含最小尾部修复，无需再次应用单独fix。

```bash
git apply --check redis-7.0.15-crc16-dispatch-fixed.patch
git apply redis-7.0.15-crc16-dispatch-fixed.patch
make -j8
```

redis-7.0.15-crc16-upstream-dispatch.patch为严格原样对照版，已知会使部分长度CRC错误，只用于复现问题；在它之上应用独立short-tail-fix补丁，等价于默认组合补丁。8way没有被强行加入dispatch选择策略。
'''
(ROOT / '完整dispatch复测报告.md').write_text(report, encoding='utf-8', newline='\n')
(ROOT / 'dispatch-summary.json').write_text(json.dumps(records, indent=2), encoding='utf-8')
print(table)
