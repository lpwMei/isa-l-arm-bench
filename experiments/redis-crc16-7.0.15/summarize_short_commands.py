"""Summarize only the user-approved fixed-key short-command experiment."""
from datetime import datetime, timezone, timedelta
import json
from pathlib import Path
import re

ROOT = Path(__file__).resolve().parent
RUN = ROOT / 'short-command/manual/short-command-results'
PROFILES = ROOT / 'short-command/manual/profile-results'
assert (RUN / 'status.txt').read_text().strip() == 'PASS'
assert (PROFILES / 'status.txt').read_text().strip() == 'PASS'
records = json.loads((PROFILES / 'summary.json').read_text())
assert len(records) == 4
for record in records:
    name = record['stage']
    output = (RUN / f'{name}.txt').read_text()
    count, duration = re.search(r'(\d+) requests completed in ([\d.]+) seconds', output).groups()
    assert int(count) == 100000000
    record['requests_completed'] = int(count)
    record['benchmark_seconds'] = float(duration)
    record['rps'] = float(re.search(r'throughput summary: ([\d.]+) requests per second', output).group(1))
    report = (PROFILES / f'{name}.report.txt').read_text()
    assert 'Total Lost Samples: 0' in report
    log = (PROFILES / f'{name}.record.log').read_text()
    record['perf_samples'] = int(re.search(r'\((\d+) samples\)', log).group(1))
    assert record['exact_benchmark_command'][record['exact_benchmark_command'].index('-n') + 1] == '100000000'
    assert '-r' not in record['exact_benchmark_command']
    assert '-d' not in record['exact_benchmark_command']
for variant in ('baseline', 'optimized'):
    text = (RUN / f'{variant}-info.txt').read_text()
    assert int(re.search(r'cmdstat_set:calls=(\d+)', text).group(1)) == 100000000
    assert int(re.search(r'cmdstat_get:calls=(\d+)', text).group(1)) == 100000000
    assert re.search(r'^db0:keys=1,', text, re.M)
    assert re.search(r'^keyspace_misses:0$', text, re.M)
    assert re.search(r'^total_error_replies:0$', text, re.M)
    assert (RUN / f'{variant}-dbsize.txt').read_text().strip() == '1'
    assert (RUN / f'{variant}-value.txt').read_text().strip() == 'xxx'

table = '| 版本 | 操作 | 完成请求 | 耗时(s) | 吞吐(ops/s) | CRC16相关栈 / 用户态cycles | perf样本 |\n'
table += '|---|---|---:|---:|---:|---:|---:|\n'
for r in records:
    variant, command = r['stage'].split('-')
    label = '原版' if variant == 'baseline' else '优化版'
    table += f'| {label} | {command.upper()} | {r["requests_completed"]:,} | {r["benchmark_seconds"]:.2f} | {r["rps"]:,.2f} | {r["crc16_user_cycles_percent"]:.2f}% | {r["perf_samples"]:,} |\n'

now = datetime.now(timezone(timedelta(hours=8))).isoformat(timespec='seconds')
report = f'''# 用户指定短命令：复测与火焰图

生成时间：{now}。服务器：192.168.90.158。

本次仅执行用户指定的两条固定key命令，只将-n增大为100000000延长运行。原版、优化版的SET/GET各1亿请求，总计4亿请求，均完整结束。额外预热、-r、-d、--csv、--threads均未使用。

```bash
KEY=$(printf 'k%.0s' {{1..64}})
taskset -c 342 /manual/bin/redis-benchmark -p 36381 -c 200 -n 100000000 -P 16 SET "$KEY" xxx
taskset -c 342 /manual/bin/redis-benchmark -p 36381 -c 200 -n 100000000 -P 16 GET "$KEY"
```

完整命令和perf命令保存在short-command/manual/profile-results/summary.json，工作负载源码为run_short_commands.sh。原版和优化版均共用同一个客户端，只切换服务端二进制。

## 本次结果

{table}

每项运行期间采集30秒perf DWARF调用栈，四项都未丢样；采样窗口没有跨越操作或版本边界。火焰图按period加权的cycles绘制，CRC16相关栈是crc16及crc16_xmodem_pmull的并集，不重复累计父子帧。分母为相应Redis进程的用户态cycles，不含内核和等待。

这是一轮带采样的复测，吞吐包含采样开销，不作为多轮稳定收益的结论，也不与旧工况中位数横向比较。

## 查看火焰图

- 原版SET：short-command/manual/profile-results/baseline-set.svg
- 原版GET：short-command/manual/profile-results/baseline-get.svg
- 优化版SET：short-command/manual/profile-results/optimized-set.svg
- 优化版GET：short-command/manual/profile-results/optimized-get.svg

用浏览器打开SVG，Search输入crc16，查看所有CRC16相关帧合计的用户态cycles占比；点击函数块可缩放。对应PNG为静态预览。

## 环境与核验

openEuler 24.03 LTS SP3容器，沿用已有镜像bb2be08831f4；执行UID/GID1007。单实例开启集群并持有全部16384个槽位。Redis固定CPU340（Socket1/Core170），客户端固定CPU342（Socket1/Core171）；两版配置一致。本次不是独占主机，未设置IRQ隔离。

每版的INFO commandstats快照证明SET、GET各调用100000000次；DBSIZE为1，GET miss为0，total_error_replies为0，实际值验证为xxx。旧随机key负载长测在切换前终止，未完成验收，没有与本次并行运行。

## 采样方法

```bash
perf record -e cycles:u -F 199 --call-graph dwarf,8192 \\
  -p <宿主Redis_PID> -o <版本-操作>.data -- sleep 30
```

利用/proc/<PID>/root中的精确二进制与库在独立symfs内镜像容器路径，再通过perf report和perf script --symfs解析调用栈。导出comm,pid,tid,time,period,event,ip,sym,dso字段，使用官方stackcollapse-perf.pl和flamegraph.pl绘图。

观察程序profile_short_commands.py不发送压测请求。原始perf.data、解码栈.script、折叠栈.folded、函数报告.report.txt、perf日志.record.log和最终.svg均随包保存。服务器原始目录为/home/liupengwei/redis-crc16-20261026/manual/profile-results/。

本次结果只支持该固定key工况；此前随机key工况的19.21%和18.74%属于历史采样，不用于解释本次占比。
'''
(ROOT / '短命令复测报告.md').write_text(report, encoding='utf-8', newline='\n')
(ROOT / 'short-command-summary.json').write_text(json.dumps(records, indent=2), encoding='utf-8')
print(table)
