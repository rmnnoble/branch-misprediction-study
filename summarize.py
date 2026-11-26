#!/usr/bin/env python3
"""Reads results/raw_output.txt and prints median, min and max per build and data order."""
import re, statistics, collections
pat = re.compile(r"^(O\d) run \d+: (\w+) execution time: (\d+) ms \(Sum: (\d+)\)")
times = collections.defaultdict(list); sums = set()
for line in open("results/raw_output.txt"):
    m = pat.match(line)
    if m:
        times[(m.group(1), m.group(2))].append(int(m.group(3))); sums.add(m.group(4))
print(f"{'Build':<6}{'Data':<10}{'runs':>5}{'median ms':>11}{'min':>7}{'max':>7}")
for (opt, data), v in sorted(times.items()):
    print(f"-{opt:<5}{data:<10}{len(v):>5}{statistics.median(v):>11.1f}{min(v):>7}{max(v):>7}")
print("Distinct sums across all runs:", sorted(sums), "(must be exactly one value)")
