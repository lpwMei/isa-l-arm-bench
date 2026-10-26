#!/usr/bin/env python3
"""Summarize the raw logs emitted by isa-l-arm-benchmark.yml."""

import argparse
import csv
import json
import math
import re
import statistics
from collections import defaultdict
from pathlib import Path


def collect(root):
    values = defaultdict(dict)
    for version in ("baseline", "upstream"):
        for folder in sorted((root / version).glob("round-*")):
            round_id = int(folder.name.removeprefix("round-"))
            for path in sorted(folder.glob("crc-*.csv")):
                for row in csv.reader(path.read_text(encoding="utf-8").splitlines()):
                    if len(row) == 3 and row[0].startswith("crc") and row[1].isdigit():
                        case = f"crc/{row[0]}/{int(row[1])}B"
                        values[(version, case)][round_id] = float(row[2])
            for path in sorted(folder.glob("ec-*.log")):
                for direction, score in re.findall(
                    r"erasure_code_(encode|decode)[^\n]*?=\s*([0-9.]+)\s+MB/s",
                    path.read_text(encoding="utf-8"),
                ):
                    case = f"ec/{path.stem}/{direction}/64KiB"
                    values[(version, case)][round_id] = float(score)
            for path in sorted(folder.glob("inflate-*.log")):
                scores = re.findall(
                    r"isal_[^\n]*inflate->[^\n]*?=\s*([0-9.]+)\s+MB/s",
                    path.read_text(encoding="utf-8"),
                )
                if len(scores) != 2:
                    raise ValueError(f"Expected two inflate results in {path}, got {len(scores)}")
                # The fixed command requests -t then -s. Use call order rather than
                # trusting a display label tied to the compression strategy.
                for mode, score in zip(("stateless", "stateful"), scores):
                    case = f"inflate/{path.stem.removeprefix('inflate-')}/{mode}"
                    values[(version, case)][round_id] = float(score)
    return values


def variation(samples):
    return statistics.stdev(samples) / statistics.mean(samples) * 100 if len(samples) > 1 else 0


def summarize(root, expected_repeats):
    values = collect(root)
    cases = sorted({case for _, case in values})
    if not cases:
        raise ValueError("No benchmark samples found")
    rows = []
    expected_rounds = set(range(1, expected_repeats + 1))
    for case in cases:
        before = values[("baseline", case)]
        after = values[("upstream", case)]
        if set(before) != expected_rounds or set(after) != expected_rounds:
            raise ValueError(f"Incomplete rounds for {case}: {sorted(before)} vs {sorted(after)}")
        b = list(before.values())
        a = list(after.values())
        if any(not math.isfinite(x) or x <= 0 for x in b + a):
            raise ValueError(f"Invalid throughput in {case}")
        bm, am = statistics.median(b), statistics.median(a)
        paired = statistics.median(after[r] / before[r] for r in sorted(before))
        rows.append({
            "case": case,
            "baseline_median_MB_s": round(bm, 2),
            "upstream_median_MB_s": round(am, 2),
            "gain_pct_ratio_of_medians": round((am / bm - 1) * 100, 2),
            "gain_pct_median_of_paired_ratios": round((paired - 1) * 100, 2),
            "baseline_cv_pct": round(variation(b), 2),
            "upstream_cv_pct": round(variation(a), 2),
            "samples_per_version": len(b),
        })
    # 3 CRCs * 7 sizes + 4 EC settings * 2 directions + 3 corpora * 2 modes.
    if len(rows) != 35:
        raise ValueError(f"Expected 35 benchmark cases, got {len(rows)}")
    return rows


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("results", type=Path)
    parser.add_argument("--repeats", type=int, default=5)
    args = parser.parse_args()
    rows = summarize(args.results, args.repeats)
    with (args.results / "summary.csv").open("w", encoding="utf-8", newline="") as f:
        writer = csv.DictWriter(f, fieldnames=list(rows[0]))
        writer.writeheader()
        writer.writerows(rows)
    (args.results / "summary.json").write_text(
        json.dumps(rows, ensure_ascii=False, indent=2) + "\n", encoding="utf-8"
    )
    for row in rows:
        print(f"{row['case']}: {row['baseline_median_MB_s']:.2f} -> "
              f"{row['upstream_median_MB_s']:.2f} MB/s "
              f"({row['gain_pct_ratio_of_medians']:+.2f}%, "
              f"paired {row['gain_pct_median_of_paired_ratios']:+.2f}%)")


if __name__ == "__main__":
    main()
