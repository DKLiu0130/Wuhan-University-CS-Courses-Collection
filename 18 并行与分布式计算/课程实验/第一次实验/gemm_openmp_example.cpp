// GEMM OpenMP example for class explanation.
//
// This file is a complete example. Students can read and run it to understand
// the same serial -> OpenMP -> correctness -> performance pattern used in the
// convolution lab.
//
// Build on Windows:
//   MinGW/MSYS2: g++ -O2 -std=c++17 -fopenmp gemm_openmp_example.cpp -o gemm_openmp_example.exe
//   MSVC:        cl /O2 /EHsc /openmp gemm_openmp_example.cpp /Fe:gemm_openmp_example.exe

#include <algorithm>
#include <chrono>
#include <cmath>
#include <cstdlib>
#include <iomanip>
#include <iostream>
#include <limits>
#include <numeric>
#include <vector>

#ifdef _OPENMP
#include <omp.h>
#endif

namespace {

constexpr int M = 512;
constexpr int N = 512;
constexpr int K = 512;
constexpr int REPEATS = 3;
constexpr float EPS = 1e-3f;

int a_index(int i, int k) {
    return i * K + k;
}

int b_index(int k, int j) {
    return k * N + j;
}

int c_index(int i, int j) {
    return i * N + j;
}

double now_seconds() {
    using clock = std::chrono::high_resolution_clock;
    return std::chrono::duration<double>(clock::now().time_since_epoch()).count();
}

template <typename Func>
double benchmark_ms(Func fn, int repeats) {
    double total_ms = 0.0;
    for (int i = 0; i < repeats; ++i) {
        double t0 = now_seconds();
        fn();
        double t1 = now_seconds();
        total_ms += (t1 - t0) * 1000.0;
    }
    return total_ms / repeats;
}

void fill_data(std::vector<float>& a, std::vector<float>& b) {
    for (std::size_t i = 0; i < a.size(); ++i) {
        a[i] = static_cast<float>((i * 37) % 1000) / 1000.0f;
    }
    for (std::size_t i = 0; i < b.size(); ++i) {
        int v = static_cast<int>((i * 17) % 1000) - 500;
        b[i] = static_cast<float>(v) / 500.0f;
    }
}

void reset(std::vector<float>& c) {
    std::fill(c.begin(), c.end(), 0.0f);
}

float max_abs_diff(const std::vector<float>& x, const std::vector<float>& y) {
    float diff = 0.0f;
    for (std::size_t i = 0; i < x.size(); ++i) {
        if (!std::isfinite(x[i]) || !std::isfinite(y[i])) {
            return std::numeric_limits<float>::infinity();
        }
        diff = std::max(diff, std::fabs(x[i] - y[i]));
    }
    return diff;
}

double checksum(const std::vector<float>& c) {
    return std::accumulate(c.begin(), c.end(), 0.0);
}

void gemm_serial(const std::vector<float>& a,
                 const std::vector<float>& b,
                 std::vector<float>& c) {
    for (int i = 0; i < M; ++i) {
        for (int j = 0; j < N; ++j) {
            float sum = 0.0f;
            for (int k = 0; k < K; ++k) {
                sum += a[a_index(i, k)] * b[b_index(k, j)];
            }
            c[c_index(i, j)] = sum;
        }
    }
}

void gemm_openmp(const std::vector<float>& a,
                 const std::vector<float>& b,
                 std::vector<float>& c) {
#pragma omp parallel for schedule(static)
    for (int i = 0; i < M; ++i) {
        for (int j = 0; j < N; ++j) {
            float sum = 0.0f;
            for (int k = 0; k < K; ++k) {
                sum += a[a_index(i, k)] * b[b_index(k, j)];
            }
            c[c_index(i, j)] = sum;
        }
    }
}

}  // namespace

int main(int argc, char** argv) {
    int threads = 4;
    if (argc >= 2) {
        threads = std::max(1, std::atoi(argv[1]));
    }

#ifdef _OPENMP
    omp_set_num_threads(threads);
#else
    std::cout << "Warning: OpenMP is not enabled. Rebuild with -fopenmp or /openmp.\n";
#endif

    std::vector<float> a(M * K);
    std::vector<float> b(K * N);
    std::vector<float> serial_c(M * N);
    std::vector<float> openmp_c(M * N);
    fill_data(a, b);

    reset(serial_c);
    reset(openmp_c);
    gemm_serial(a, b, serial_c);
    gemm_openmp(a, b, openmp_c);

    float diff = max_abs_diff(serial_c, openmp_c);

    double serial_ms = benchmark_ms([&]() {
        reset(serial_c);
        gemm_serial(a, b, serial_c);
    }, REPEATS);

    double openmp_ms = benchmark_ms([&]() {
        reset(openmp_c);
        gemm_openmp(a, b, openmp_c);
    }, REPEATS);

    std::cout << std::fixed << std::setprecision(3);
    std::cout << "GEMM: C = A x B, A=" << M << "x" << K
              << ", B=" << K << "x" << N << "\n";
    std::cout << "threads:   " << threads << "\n";
    std::cout << "max_diff:  " << diff << "\n";
    std::cout << "status:    " << (diff <= EPS ? "PASS" : "FAIL") << "\n";
    std::cout << "serial_ms: " << serial_ms << "\n";
    std::cout << "openmp_ms: " << openmp_ms << "\n";
    std::cout << "speedup:   " << serial_ms / openmp_ms << "\n";
    std::cout << "checksum:  " << checksum(openmp_c) << "\n";

    return diff <= EPS ? 0 : 1;
}
