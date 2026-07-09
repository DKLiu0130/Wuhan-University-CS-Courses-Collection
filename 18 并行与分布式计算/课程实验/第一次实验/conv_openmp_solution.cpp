// Teacher reference solution for Experiment 3.
// Build on Windows:
//   MinGW/MSYS2: g++ -O2 -std=c++17 -fopenmp conv_openmp_solution.cpp -o conv_openmp_solution.exe
//   MSVC:        cl /O2 /EHsc /openmp conv_openmp_solution.cpp /Fe:conv_openmp_solution.exe

#include <algorithm>
#include <chrono>
#include <cmath>
#include <cstdint>
#include <cstdlib>
#include <fstream>
#include <iomanip>
#include <iostream>
#include <limits>
#include <numeric>
#include <stdexcept>
#include <string>
#include <vector>

#ifdef _OPENMP
#include <omp.h>
#endif

namespace {

constexpr float EPS = 1e-4f;
constexpr int REPEATS = 5;
const char DATA_MAGIC[8] = {'E', 'X', 'P', '3', 'C', 'O', 'N', 'V'};

struct ConvShape {
    int c = 0;
    int h = 0;
    int w = 0;
    int kh = 0;
    int kw = 0;

    int oh() const {
        return h - kh + 1;
    }

    int ow() const {
        return w - kw + 1;
    }
};

struct ConvData {
    ConvShape shape;
    std::vector<float> image;
    std::vector<float> kernel;
    std::vector<float> expected;
};

int image_index(const ConvShape& s, int c, int h, int w) {
    return (c * s.h + h) * s.w + w;
}

int kernel_index(const ConvShape& s, int c, int kh, int kw) {
    return (c * s.kh + kh) * s.kw + kw;
}

int out_index(const ConvShape& s, int oh, int ow) {
    return oh * s.ow() + ow;
}

std::int32_t read_i32(std::ifstream& in) {
    std::int32_t value = 0;
    in.read(reinterpret_cast<char*>(&value), sizeof(value));
    if (!in) {
        throw std::runtime_error("failed to read int32 from dataset");
    }
    return value;
}

void read_floats(std::ifstream& in, std::vector<float>& data) {
    in.read(reinterpret_cast<char*>(data.data()),
            static_cast<std::streamsize>(data.size() * sizeof(float)));
    if (!in) {
        throw std::runtime_error("failed to read float array from dataset");
    }
}

ConvData load_data(const std::string& path) {
    std::ifstream in(path, std::ios::binary);
    if (!in) {
        throw std::runtime_error("cannot open dataset: " + path);
    }

    char magic[8] = {};
    in.read(magic, sizeof(magic));
    if (!in || !std::equal(std::begin(magic), std::end(magic), std::begin(DATA_MAGIC))) {
        throw std::runtime_error("bad dataset magic: " + path);
    }

    ConvData data;
    data.shape.c = read_i32(in);
    data.shape.h = read_i32(in);
    data.shape.w = read_i32(in);
    data.shape.kh = read_i32(in);
    data.shape.kw = read_i32(in);

    if (data.shape.c <= 0 || data.shape.h <= 0 || data.shape.w <= 0 ||
        data.shape.kh <= 0 || data.shape.kw <= 0 ||
        data.shape.kh > data.shape.h || data.shape.kw > data.shape.w) {
        throw std::runtime_error("invalid convolution shape in dataset");
    }

    data.image.resize(static_cast<std::size_t>(data.shape.c) * data.shape.h * data.shape.w);
    data.kernel.resize(static_cast<std::size_t>(data.shape.c) * data.shape.kh * data.shape.kw);
    data.expected.resize(static_cast<std::size_t>(data.shape.oh()) * data.shape.ow());

    read_floats(in, data.image);
    read_floats(in, data.kernel);
    read_floats(in, data.expected);
    return data;
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

void reset_output(std::vector<float>& out) {
    std::fill(out.begin(), out.end(), std::numeric_limits<float>::quiet_NaN());
}

float max_abs_diff(const std::vector<float>& a, const std::vector<float>& b) {
    float diff = 0.0f;
    for (std::size_t i = 0; i < a.size(); ++i) {
        if (!std::isfinite(a[i]) || !std::isfinite(b[i])) {
            return std::numeric_limits<float>::infinity();
        }
        diff = std::max(diff, std::fabs(a[i] - b[i]));
    }
    return diff;
}

double checksum(const std::vector<float>& out) {
    return std::accumulate(out.begin(), out.end(), 0.0);
}

void print_status(const char* name, float diff) {
    std::cout << name << "_max_diff: " << diff << "\n";
    std::cout << name << "_status:   " << (diff <= EPS ? "PASS" : "FAIL") << "\n";
}

}  // namespace

void conv_serial(const std::vector<float>& image,
                 const std::vector<float>& kernel,
                 std::vector<float>& out,
                 const ConvShape& shape) {
    for (int oh = 0; oh < shape.oh(); ++oh) {
        for (int ow = 0; ow < shape.ow(); ++ow) {
            float sum = 0.0f;
            for (int c = 0; c < shape.c; ++c) {
                for (int kh = 0; kh < shape.kh; ++kh) {
                    for (int kw = 0; kw < shape.kw; ++kw) {
                        sum += image[image_index(shape, c, oh + kh, ow + kw)] *
                               kernel[kernel_index(shape, c, kh, kw)];
                    }
                }
            }
            out[out_index(shape, oh, ow)] = sum;
        }
    }
}

void conv_openmp(const std::vector<float>& image,
                 const std::vector<float>& kernel,
                 std::vector<float>& out,
                 const ConvShape& shape) {
#pragma omp parallel for schedule(static)
    for (int oh = 0; oh < shape.oh(); ++oh) {
        for (int ow = 0; ow < shape.ow(); ++ow) {
            float sum = 0.0f;
            for (int c = 0; c < shape.c; ++c) {
                for (int kh = 0; kh < shape.kh; ++kh) {
                    for (int kw = 0; kw < shape.kw; ++kw) {
                        sum += image[image_index(shape, c, oh + kh, ow + kw)] *
                               kernel[kernel_index(shape, c, kh, kw)];
                    }
                }
            }
            out[out_index(shape, oh, ow)] = sum;
        }
    }
}

int main(int argc, char** argv) {
    int threads = 4;
    if (argc >= 2) {
        threads = std::max(1, std::atoi(argv[1]));
    }
    std::string data_path = argc >= 3 ? argv[2] : "conv_data.bin";

#ifdef _OPENMP
    omp_set_num_threads(threads);
#else
    std::cout << "Warning: OpenMP is not enabled. Rebuild with -fopenmp or /openmp.\n";
#endif

    try {
        ConvData data = load_data(data_path);
        const ConvShape& s = data.shape;
        std::vector<float> serial_out(data.expected.size());
        std::vector<float> parallel_out(data.expected.size());

        reset_output(serial_out);
        reset_output(parallel_out);
        conv_serial(data.image, data.kernel, serial_out, s);
        conv_openmp(data.image, data.kernel, parallel_out, s);

        float serial_diff = max_abs_diff(serial_out, data.expected);
        float parallel_diff = max_abs_diff(parallel_out, data.expected);
        float serial_parallel_diff = max_abs_diff(serial_out, parallel_out);

        std::cout << std::fixed << std::setprecision(3);
        std::cout << "data:       " << data_path << "\n";
        std::cout << "image:      " << s.c << "x" << s.h << "x" << s.w << "\n";
        std::cout << "kernel:     " << s.c << "x" << s.kh << "x" << s.kw << "\n";
        std::cout << "output:     " << s.oh() << "x" << s.ow() << "\n";
        std::cout << "threads:    " << threads << "\n";
        print_status("serial", serial_diff);
        print_status("openmp", parallel_diff);
        std::cout << "serial_openmp_max_diff: " << serial_parallel_diff << "\n";

        if (serial_diff <= EPS && parallel_diff <= EPS && serial_parallel_diff <= EPS) {
            double serial_ms = benchmark_ms([&]() {
                reset_output(serial_out);
                conv_serial(data.image, data.kernel, serial_out, s);
            }, REPEATS);
            double parallel_ms = benchmark_ms([&]() {
                reset_output(parallel_out);
                conv_openmp(data.image, data.kernel, parallel_out, s);
            }, REPEATS);
            double speedup = serial_ms / parallel_ms;
            std::cout << "serial_ms:  " << serial_ms << "\n";
            std::cout << "openmp_ms:  " << parallel_ms << "\n";
            std::cout << "speedup:    " << speedup << "\n";
            std::cout << "checksum:   " << checksum(parallel_out) << "\n";
        } else {
            std::cout << "performance: skipped because correctness check failed\n";
        }
    } catch (const std::exception& e) {
        std::cerr << "Error: " << e.what() << "\n";
        return 1;
    }

    return 0;
}
