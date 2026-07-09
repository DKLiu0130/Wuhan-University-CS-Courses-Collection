#include <mpi.h>

#include <algorithm>
#include <cmath>
#include <iostream>
#include <limits>
#include <string>
#include <vector>

constexpr int DEFAULT_MATRIX_SIZE = 1024;
constexpr int DEFAULT_TILE_ROWS = 64;
constexpr int TAG_RESULT = 20;
constexpr int TAG_STOP = 21;

struct Problem {
    int n = DEFAULT_MATRIX_SIZE;
    int tile_rows = DEFAULT_TILE_ROWS;
};

int TileCount(const Problem& problem) {
    return (problem.n + problem.tile_rows - 1) / problem.tile_rows;
}

int ResultElements(const Problem& problem) {
    return 2 + problem.tile_rows * problem.n;
}

int FullResultElements(const Problem& problem) {
    return 2 + problem.n * problem.n;
}

double ValueA(int row, int col) {
    return 0.001 * (row + 1) + 0.002 * (col + 1);
}

double ValueB(int row, int col) {
    return 0.003 * (row + 1) - 0.001 * (col + 1);
}

std::vector<double> MakeB(int n) {
    std::vector<double> b(n * n, 0.0);
    for (int r = 0; r < n; ++r) {
        for (int c = 0; c < n; ++c) {
            b[r * n + c] = ValueB(r, c);
        }
    }
    return b;
}

void ComputeTile(const Problem& problem,
                 const std::vector<double>& b,
                 int start_row,
                 int rows,
                 std::vector<double>& c_tile) {
    c_tile.assign(problem.tile_rows * problem.n, 0.0);
    for (int i = 0; i < rows; ++i) {
        int global_row = start_row + i;
        for (int j = 0; j < problem.n; ++j) {
            double sum = 0.0;
            for (int k = 0; k < problem.n; ++k) {
                sum += ValueA(global_row, k) * b[k * problem.n + j];
            }
            c_tile[i * problem.n + j] = sum;
        }
    }
}

void ComputeFullMatrix(const Problem& problem,
                       const std::vector<double>& b,
                       std::vector<double>& c) {
    c.assign(problem.n * problem.n, 0.0);
    for (int i = 0; i < problem.n; ++i) {
        for (int j = 0; j < problem.n; ++j) {
            double sum = 0.0;
            for (int k = 0; k < problem.n; ++k) {
                sum += ValueA(i, k) * b[k * problem.n + j];
            }
            c[i * problem.n + j] = sum;
        }
    }
}

void PackResult(const Problem& problem,
                int start_row,
                int rows,
                const std::vector<double>& c_tile,
                std::vector<double>& payload) {
    payload.assign(ResultElements(problem), 0.0);
    payload[0] = static_cast<double>(start_row);
    payload[1] = static_cast<double>(rows);
    std::copy(c_tile.begin(), c_tile.end(), payload.begin() + 2);
}

void UnpackResult(const Problem& problem,
                  const std::vector<double>& payload,
                  std::vector<double>& c) {
    int start_row = static_cast<int>(payload[0]);
    int rows = static_cast<int>(payload[1]);
    for (int r = 0; r < rows; ++r) {
        for (int col = 0; col < problem.n; ++col) {
            c[(start_row + r) * problem.n + col] = payload[2 + r * problem.n + col];
        }
    }
}

void PackFullResult(const Problem& problem,
                    const std::vector<double>& c,
                    std::vector<double>& payload) {
    payload.assign(FullResultElements(problem), 0.0);
    payload[0] = 0.0;
    payload[1] = static_cast<double>(problem.n);
    std::copy(c.begin(), c.end(), payload.begin() + 2);
}

void UnpackFullResult(const Problem& problem,
                      const std::vector<double>& payload,
                      std::vector<double>& c) {
    c.assign(problem.n * problem.n, 0.0);
    std::copy(payload.begin() + 2, payload.end(), c.begin());
}

double ExpectedValue(int n, int row, int col) {
    double count = static_cast<double>(n);
    double sum_k = count * (count + 1.0) / 2.0;
    double sum_k2 = count * (count + 1.0) * (2.0 * count + 1.0) / 6.0;
    double a_row = 0.001 * (row + 1);
    double b_col = -0.001 * (col + 1);
    return 0.003 * a_row * sum_k
        + count * a_row * b_col
        + 0.000006 * sum_k2
        + 0.002 * b_col * sum_k;
}

bool CheckResults(const Problem& problem,
                  const std::vector<double>& actual,
                  double eps,
                  std::string& message) {
    for (int i = 0; i < problem.n * problem.n; ++i) {
        if (!std::isfinite(actual[i])) {
            message = "missing result at element " + std::to_string(i);
            return false;
        }
        int row = i / problem.n;
        int col = i % problem.n;
        double diff = std::fabs(actual[i] - ExpectedValue(problem.n, row, col));
        if (diff > eps) {
            message = "value mismatch at element " + std::to_string(i);
            return false;
        }
    }
    message = "matched";
    return true;
}

void SendStop() {
    double stop[2] = {-1.0, 0.0};
    MPI_Send(stop, 2, MPI_DOUBLE, 1, TAG_STOP, MPI_COMM_WORLD);
}

void Rank0Blocking(const Problem& problem, const std::vector<double>& b) {
    std::vector<double> c;
    std::vector<double> payload;
    ComputeFullMatrix(problem, b, c);
    PackFullResult(problem, c, payload);
    MPI_Send(payload.data(), FullResultElements(problem), MPI_DOUBLE, 1, TAG_RESULT,
             MPI_COMM_WORLD);
    SendStop();
}

void Rank1Blocking(const Problem& problem, std::vector<double>& c) {
    while (true) {
        MPI_Status status;
        MPI_Probe(0, MPI_ANY_TAG, MPI_COMM_WORLD, &status);
        if (status.MPI_TAG == TAG_STOP) {
            double stop[2] = {0.0, 0.0};
            MPI_Recv(stop, 2, MPI_DOUBLE, 0, TAG_STOP, MPI_COMM_WORLD, MPI_STATUS_IGNORE);
            break;
        }
        std::vector<double> payload(FullResultElements(problem));
        MPI_Recv(payload.data(), FullResultElements(problem), MPI_DOUBLE, 0, TAG_RESULT,
                 MPI_COMM_WORLD, MPI_STATUS_IGNORE);
        UnpackFullResult(problem, payload, c);
    }
}

void Rank0Pipeline(const Problem& problem, const std::vector<double>& b) {
    int total_tiles = TileCount(problem);
    
    std::vector<double> payload_a(ResultElements(problem));
    std::vector<double> payload_b(ResultElements(problem));
    std::vector<double>* current_payload = &payload_a;
    std::vector<double>* next_payload = &payload_b;

    std::vector<double> c_tile(problem.tile_rows * problem.n);
    MPI_Request request = MPI_REQUEST_NULL;

    for (int k = 0; k < total_tiles; ++k) {
        int start_row = k * problem.tile_rows;
        int rows = std::min(problem.tile_rows, problem.n - start_row);

        ComputeTile(problem, b, start_row, rows, c_tile);

        if (request != MPI_REQUEST_NULL) {
            MPI_Wait(&request, MPI_STATUS_IGNORE);
        }

        PackResult(problem, start_row, rows, c_tile, *current_payload);

        MPI_Isend(current_payload->data(), ResultElements(problem), MPI_DOUBLE, 
                  1, TAG_RESULT, MPI_COMM_WORLD, &request);

        std::swap(current_payload, next_payload);
    }

    if (request != MPI_REQUEST_NULL) {
        MPI_Wait(&request, MPI_STATUS_IGNORE);
    }

    SendStop();
}

void Rank1Pipeline(const Problem& problem, std::vector<double>& c) {
    int total_received_rows = 0;
    std::vector<double> payload(ResultElements(problem));

    while (total_received_rows < problem.n) {
        MPI_Status status;
        MPI_Probe(0, MPI_ANY_TAG, MPI_COMM_WORLD, &status);

        if (status.MPI_TAG == TAG_STOP) {
            double stop[2];
            MPI_Recv(stop, 2, MPI_DOUBLE, 0, TAG_STOP, MPI_COMM_WORLD, MPI_STATUS_IGNORE);
            break;
        }

        MPI_Recv(payload.data(), ResultElements(problem), MPI_DOUBLE, 0, TAG_RESULT, 
                 MPI_COMM_WORLD, MPI_STATUS_IGNORE);

        UnpackResult(problem, payload, c);
        
        total_received_rows += static_cast<int>(payload[1]);
    }
}

double RunBlocking(const Problem& problem, int rank, std::vector<double>& c) {
    std::vector<double> b = MakeB(problem.n);
    MPI_Barrier(MPI_COMM_WORLD);
    double t0 = MPI_Wtime();
    if (rank == 0) {
        Rank0Blocking(problem, b);
    } else {
        Rank1Blocking(problem, c);
    }
    MPI_Barrier(MPI_COMM_WORLD);
    return MPI_Wtime() - t0;
}

double RunPipeline(const Problem& problem, int rank, std::vector<double>& c) {
    std::vector<double> b = MakeB(problem.n);
    MPI_Barrier(MPI_COMM_WORLD);
    double t0 = MPI_Wtime();
    if (rank == 0) {
        Rank0Pipeline(problem, b);
    } else {
        Rank1Pipeline(problem, c);
    }
    MPI_Barrier(MPI_COMM_WORLD);
    return MPI_Wtime() - t0;
}

int main(int argc, char** argv) {
    MPI_Init(&argc, &argv);

    int rank = 0;
    int size = 0;
    MPI_Comm_rank(MPI_COMM_WORLD, &rank);
    MPI_Comm_size(MPI_COMM_WORLD, &size);

    if (size != 2) {
        if (rank == 0) {
            std::cout << "Please run with exactly 2 processes.\n";
        }
        MPI_Finalize();
        return 1;
    }

    std::string mode = "pipeline";
    if (argc >= 2) {
        mode = argv[1];
    }

    Problem problem;
    if (argc >= 3) {
        problem.tile_rows = std::stoi(argv[2]);
    }
    if (argc >= 4) {
        problem.n = std::stoi(argv[3]);
    }
    if (problem.n <= 0 || problem.tile_rows <= 0 || problem.tile_rows > problem.n) {
        if (rank == 0) {
            std::cout << "Invalid matrix size or tile rows.\n";
        }
        MPI_Finalize();
        return 1;
    }

    std::vector<double> c;
    if (rank == 1) {
        c.assign(problem.n * problem.n, std::numeric_limits<double>::quiet_NaN());
    }

    double elapsed = 0.0;
    if (mode == "blocking") {
        elapsed = RunBlocking(problem, rank, c);
    } else {
        elapsed = RunPipeline(problem, rank, c);
    }

    if (rank == 1) {
        std::string message;
        bool pass = CheckResults(problem, c, 1e-5, message);
        std::cout << "mode:           " << mode << "\n";
        std::cout << "mpi_size:       " << size << "\n";
        std::cout << "matrix_size:    " << problem.n << " x " << problem.n << "\n";
        std::cout << "tile_rows:      " << problem.tile_rows << "\n";
        std::cout << "tile_count:     " << TileCount(problem) << "\n";
        std::cout << "elapsed_sec:    " << elapsed << "\n";
        std::cout << "check:          " << message << "\n";
        std::cout << "status:         " << (pass ? "PASS" : "FAIL") << "\n";
    }

    MPI_Finalize();
    return 0;
}
