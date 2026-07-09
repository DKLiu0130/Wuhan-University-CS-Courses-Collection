#include <mpi.h>

#include <iostream>
#include <string>
#include <vector>

constexpr int BATCH_SIZE = 1024;
constexpr int HIDDEN_DIM = 1024;
constexpr int FEATURE_DIM = 1024;

double ValueIGrad(int rank, int row, int col) {
    return 0.001 * (rank + 1) + 0.002 * (row + 1) + 0.0001 * (col + 1);
}

double ValueD(int rank, int row, int col) {
    return 0.003 * (rank + 1) - 0.0002 * (row + 1) + 0.0001 * (col + 1);
}

void FillLocalInputs(int rank,
                     int local_batch,
                     std::vector<double>& i_grad,
                     std::vector<double>& d) {
    i_grad.assign(HIDDEN_DIM * local_batch, 0.0);
    d.assign(local_batch * FEATURE_DIM, 0.0);

    for (int r = 0; r < HIDDEN_DIM; ++r) {
        for (int c = 0; c < local_batch; ++c) {
            i_grad[r * local_batch + c] = ValueIGrad(rank, r, c);
        }
    }

    for (int r = 0; r < local_batch; ++r) {
        for (int c = 0; c < FEATURE_DIM; ++c) {
            d[r * FEATURE_DIM + c] = ValueD(rank, r, c);
        }
    }
}

void ComputeLocalWGrad(int local_batch,
                       const std::vector<double>& i_grad,
                       const std::vector<double>& d,
                       std::vector<double>& local_w_grad) {
    local_w_grad.assign(HIDDEN_DIM * FEATURE_DIM, 0.0);
    for (int i = 0; i < HIDDEN_DIM; ++i) {
        for (int j = 0; j < FEATURE_DIM; ++j) {
            double sum = 0.0;
            for (int k = 0; k < local_batch; ++k) {
                sum += i_grad[i * local_batch + k] * d[k * FEATURE_DIM + j];
            }
            local_w_grad[i * FEATURE_DIM + j] = sum;
        }
    }
}

void BlockingAllreduceAverage(const std::vector<double>& local_w_grad,
                              std::vector<double>& global_w_grad,
                              int world_size) {
    global_w_grad.assign(local_w_grad.size(), 0.0);
    MPI_Allreduce(local_w_grad.data(), global_w_grad.data(),
                  static_cast<int>(local_w_grad.size()), MPI_DOUBLE, MPI_SUM,
                  MPI_COMM_WORLD);
    for (double& value : global_w_grad) {
        value /= static_cast<double>(world_size);
    }
}

void PipelineExtraCreditEntry() {
    // Extra credit thinking entry.
    //
    // Data-parallel backward:
    // - D is split by batch dimension across ranks.
    // - Each rank owns local_batch rows of D.
    //
    // Baseline:
    // - Each rank computes the full local_w_grad = I_grad_local @ D_local.
    // - All ranks call one blocking MPI_Allreduce on the full local_w_grad.
    // - Divide the reduced W_grad by world_size.
    //
    // Pipeline question:
    // Can we split local_batch into micro-batches and overlap:
    //   compute partial W_grad for micro-batch k
    //   start MPI_Iallreduce for partial W_grad k
    //   compute partial W_grad for micro-batch k+1
    //   wait and accumulate reduced partial gradients in order
    //
    // Possible MPI APIs to explore:
    // - MPI_Iallreduce for non-blocking collective reduction.
    // - MPI_Test / MPI_Wait for completion.
    // - Multiple buffers to avoid overwriting data still used by MPI.
    //
    // Important difference from the main homework:
    // - MPI_Iallreduce is collective. Every rank must call collectives in the
    //   same order.
    // - Partial W_grad values from micro-batches must be accumulated to produce
    //   the final W_grad.
    //
    // This file is only an entry point for exploration. The main homework does
    // not require implementing this function.
}

int main(int argc, char** argv) {
    MPI_Init(&argc, &argv);

    int rank = 0;
    int world_size = 0;
    MPI_Comm_rank(MPI_COMM_WORLD, &rank);
    MPI_Comm_size(MPI_COMM_WORLD, &world_size);

    bool run_baseline = argc >= 2 && std::string(argv[1]) == "baseline";
    if (!run_baseline) {
        if (rank == 0) {
            std::cout << "extra credit entry\n";
            std::cout << "problem:        I_grad @ D = W_grad\n";
            std::cout << "baseline:       full local GEMM, then one blocking Allreduce\n";
            std::cout << "pipeline idea:  micro-batch GEMM + MPI_Iallreduce overlap\n";
            std::cout << "batch_size:     " << BATCH_SIZE << "\n";
            std::cout << "hidden_dim:     " << HIDDEN_DIM << "\n";
            std::cout << "feature_dim:    " << FEATURE_DIM << "\n";
            std::cout << "warning:        collectives must be called in the same order on all ranks\n";
            std::cout << "run baseline:   mpiexec -n 4 mpi_gradient_pipeline_extra.exe baseline\n";
        }
        PipelineExtraCreditEntry();
        MPI_Finalize();
        return 0;
    }

    if (BATCH_SIZE % world_size != 0) {
        if (rank == 0) {
            std::cout << "BATCH_SIZE must be divisible by MPI size.\n";
        }
        MPI_Finalize();
        return 1;
    }

    int local_batch = BATCH_SIZE / world_size;
    std::vector<double> i_grad;
    std::vector<double> d;
    std::vector<double> local_w_grad;
    std::vector<double> global_w_grad;

    FillLocalInputs(rank, local_batch, i_grad, d);

    MPI_Barrier(MPI_COMM_WORLD);
    double t0 = MPI_Wtime();
    ComputeLocalWGrad(local_batch, i_grad, d, local_w_grad);
    BlockingAllreduceAverage(local_w_grad, global_w_grad, world_size);
    MPI_Barrier(MPI_COMM_WORLD);
    double elapsed = MPI_Wtime() - t0;

    if (rank == 0) {
        std::cout << "extra credit baseline\n";
        std::cout << "mpi_size:       " << world_size << "\n";
        std::cout << "batch_size:     " << BATCH_SIZE << "\n";
        std::cout << "local_batch:    " << local_batch << "\n";
        std::cout << "hidden_dim:     " << HIDDEN_DIM << "\n";
        std::cout << "feature_dim:    " << FEATURE_DIM << "\n";
        std::cout << "elapsed_sec:    " << elapsed << "\n";
        std::cout << "note:           pipeline version is left as extra credit\n";
    }

    PipelineExtraCreditEntry();
    MPI_Finalize();
    return 0;
}
