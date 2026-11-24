#include <iostream>
#include <vector>
#include <algorithm>
#include <chrono>
#include <random>

using namespace std;
using namespace std::chrono;

void run_test(const vector<int>& data, const string& label) {
    long long sum = 0;
    auto start = high_resolution_clock::now();

    for (int i = 0; i < 10000; ++i) {
        for (int val : data) {
            if (val >= 128) {
                sum += val;
            }
        }
    }

    auto end = high_resolution_clock::now();
    auto duration = duration_cast<milliseconds>(end - start).count();
    cout << label << " execution time: " << duration << " ms (Sum: " << sum << ")" << endl;
}

int main() {
    const int SIZE = 32768;
    vector<int> data(SIZE);

    mt19937 gen(42);
    uniform_int_distribution<> dis(0, 255);
    for (int i = 0; i < SIZE; ++i) {
        data[i] = dis(gen);
    }

    run_test(data, "Unsorted");
    sort(data.begin(), data.end());
    run_test(data, "Sorted");

    return 0;
}
