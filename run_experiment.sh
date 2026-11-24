#!/usr/bin/env bash
# Compiles test.cpp with -O0 and -O3 and runs each binary N times.
# Usage: ./run_experiment.sh [N]      (default N = 10)
# Output: results/raw_output.txt (every run, unmodified program output)
set -euo pipefail
N="${1:-10}"
cd "$(dirname "$0")"
mkdir -p results build
g++ -O0 test.cpp -o build/test_O0
g++ -O3 test.cpp -o build/test_O3
{
  echo "# date: $(date -Is)"
  echo "# g++: $(g++ --version | head -1)"
  echo "# cpu: $(grep -m1 'model name' /proc/cpuinfo | cut -d: -f2- | sed 's/^ //')"
  echo "# kernel: $(uname -r)"
  echo "# runs per build: $N"
} > results/raw_output.txt
for opt in O0 O3; do
  for i in $(seq 1 "$N"); do
    ./build/test_$opt | sed "s/^/$opt run $i: /" >> results/raw_output.txt
  done
done
echo "Done. Raw output in results/raw_output.txt"
python3 summarize.py
