#include <mpi.h>

#include <chrono>
#include <iostream>
#include <thread>
#include <vector>

int main(int argc, char** argv) {
    MPI_Init(&argc, &argv);

    int rank = 0;
    int size = 0;
    MPI_Comm_rank(MPI_COMM_WORLD, &rank);
    MPI_Comm_size(MPI_COMM_WORLD, &size);

    if (size < 2) {
        if (rank == 0) {
            std::cout << "Please run with at least 2 processes.\n";
        }
        MPI_Finalize();
        return 0;
    }

    const int count = 8;
    const int tag = 7;

    if (rank == 0) {
        std::vector<double> buffer(count);
        MPI_Request recv_request = MPI_REQUEST_NULL;

        MPI_Irecv(buffer.data(), count, MPI_DOUBLE, 1, tag, MPI_COMM_WORLD, &recv_request);

        std::cout << "rank 0 posted Irecv, then does other work...\n";
        int flag = 0;
        for (int step = 0; step < 5 && !flag; ++step) {
            MPI_Test(&recv_request, &flag, MPI_STATUS_IGNORE);
            if (!flag) {
                std::cout << "rank 0: message not ready yet, doing local work " << step << "\n";
                std::this_thread::sleep_for(std::chrono::milliseconds(100));
            }
        }
        if (!flag) {
            std::cout << "rank 0: now waits for the receive to complete\n";
            MPI_Wait(&recv_request, MPI_STATUS_IGNORE);
        }

        std::cout << "rank 0 received:";
        for (double value : buffer) {
            std::cout << " " << value;
        }
        std::cout << "\n";
    } else if (rank == 1) {
        std::vector<double> buffer(count);
        for (int i = 0; i < count; ++i) {
            buffer[i] = 10.0 + i;
        }

        std::this_thread::sleep_for(std::chrono::milliseconds(250));
        MPI_Request send_request = MPI_REQUEST_NULL;
        MPI_Isend(buffer.data(), count, MPI_DOUBLE, 0, tag, MPI_COMM_WORLD, &send_request);

        std::cout << "rank 1 posted Isend, then waits before reusing buffer\n";
        MPI_Wait(&send_request, MPI_STATUS_IGNORE);
        std::cout << "rank 1 send completed\n";
    }

    MPI_Finalize();
    return 0;
}
