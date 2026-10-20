#!/usr/bin/env python3
"""Summarize unchanged official EC benchmark output; reject incomplete samples."""
import argparse
import csv
import json
import re
import statistics as stats
from collections import defaultdict
from pathlib import Path


def summarize(root, repeats):
    data = defaultdict(dict)
    for path in root.glob('*/r*-k*-p*-s*.log'):
        match = re.fullmatch(r'r(\d+)-(k\d+-p\d+-s\d+)\.log', path.name)
        round_id, case = int(match[1]), match[2]
        scores = re.findall(r'erasure_code_(encode|decode)[^\n]*?=\s*([0-9.]+)\s+MB/s', path.read_text())
        assert len(scores) == 2, path
        for direction, value in scores:
            data[path.parent.name, case, direction][round_id] = float(value)
    assert data, 'No results'
    rows = []
    for (version, case, direction), values in sorted(data.items()):
        assert set(values) == set(range(1, repeats + 1)), (version, case, direction, values)
        baseline = data['baseline', case, direction]
        samples = list(values.values())
        median = stats.median(samples)
        paired = [(values[r] / baseline[r] - 1) * 100 for r in sorted(values)]
        rows.append(dict(version=version, case=case, direction=direction,
                         median_MB_s=round(median, 2),
                         gain_pct=round((median / stats.median(baseline.values()) - 1) * 100, 2),
                         paired_gain_pct=round(stats.median(paired), 2),
                         min_paired_gain_pct=round(min(paired), 2),
                         cv_pct=round(stats.stdev(samples) / stats.mean(samples) * 100, 2) if repeats > 1 else 0,
                         repeats=repeats))
    with (root / 'summary.csv').open('w', newline='') as stream:
        writer = csv.DictWriter(stream, fieldnames=list(rows[0]))
        writer.writeheader()
        writer.writerows(rows)
    (root / 'summary.json').write_text(json.dumps(rows, indent=2) + '\n')
    for row in rows:
        print(f"{row['version']:10} {row['case']:20} {row['direction']:6} "
              f"{row['median_MB_s']:10.2f} MB/s {row['gain_pct']:+7.2f}% CV={row['cv_pct']:.2f}%")


if __name__ == '__main__':
    p = argparse.ArgumentParser(description=__doc__)
    p.add_argument('root', type=Path)
    p.add_argument('--repeats', type=int, required=True)
    a = p.parse_args()
    summarize(a.root, a.repeats)

