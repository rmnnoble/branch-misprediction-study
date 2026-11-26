# Does Branch Misprediction Still Matter? Compiler Optimization on AMD Zen 3+

Code and data for the paper "Does Branch Misprediction Still Matter? Compiler Optimization on AMD Zen 3+" (Ramin Sharifli, Architecture of Computers, Vistula University of Finance and Business).

## What the program does
`test.cpp` fills an array of 32,768 integers (values 0–255, `std::mt19937` with seed 42), then runs a loop 10,000 times that adds every element with value >= 128. It is timed twice: on the unsorted array and on the same array after `std::sort`. The final sum is printed so the compiler cannot remove the loop.

## Environment used in the paper
- CPU: AMD Ryzen 7 7435HS (Zen 3+)
- Host OS: Windows 11; guest: Kali Linux Rolling 2026.2 in Oracle VirtualBox 7.x (2 virtual cores, 2048 MB RAM)
- Compiler: GNU g++ (exact version is written at the top of `results/raw_output.txt`)

## How to reproduce
```bash
git clone <this repository>
cd <repository folder>
./run_experiment.sh 10     # builds with -O0 and -O3, runs each 10 times
```
This writes every run to `results/raw_output.txt` and prints median / min / max per build and data order.

Manual run of a single build:
```bash
g++ -O0 test.cpp -o test_O0 && ./test_O0
g++ -O3 test.cpp -o test_O3 && ./test_O3
```

## Expected result
- The printed sum is always `31228640000` (all builds, sorted and unsorted).
- Absolute times depend on the machine. Results of the run in the paper (10 runs per build, AMD Ryzen 7 7435HS, Kali Linux VM, g++ 16.2.0), median [min-max] in ms:

| Build | Unsorted | Sorted |
|---|---|---|
| -O0 | 1370.5 [1251-2457] | 430 [406-825] |
| -O3 | 66.5 [59-95] | 64 [59-81] |

The raw output of that run is in `results/raw_output.txt`.

## Files
| File | Purpose |
|---|---|
| `test.cpp` | benchmark program (Appendix A of the paper) |
| `run_experiment.sh` | compiles and runs repeated measurements |
| `summarize.py` | computes median, min and max from the raw output |
| `results/raw_output.txt` | raw measurements (created by the script) |

## Notes and limitations
Measurements were made inside a VirtualBox virtual machine, so hardware performance counters (`perf`: branches, branch-misses) were not available. Timing uses `std::chrono::high_resolution_clock`.
