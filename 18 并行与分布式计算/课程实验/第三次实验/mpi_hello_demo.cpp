#include <mpi.h>

#include <iostream>
#include <string>

int main(int argc, char** argv) {
    MPI_Init(&argc, &argv);

    int rank = 0;
    int size = 0;
    MPI_Comm_rank(MPI_COMM_WORLD, &rank);
    MPI_Comm_size(MPI_COMM_WORLD, &size);

    std::cout << "Hello from rank " << rank << " of " << size << std::endl;

    if (size >= 2) {
        if (rank == 0) {
            const std::string message = "task: build local inverted index";
            int length = static_cast<int>(message.size()) + 1;
            MPI_Send(&length, 1, MPI_INT, 1, 0, MPI_COMM_WORLD);
            MPI_Send(message.c_str(), length, MPI_CHAR, 1, 1, MPI_COMM_WORLD);
            std::cout << "rank 0 sent a message to rank 1" << std::endl;
        } else if (rank == 1) {
            int length = 0;
            MPI_Recv(&length, 1, MPI_INT, 0, 0, MPI_COMM_WORLD, MPI_STATUS_IGNORE);
            std::string message(length, '\0');
            MPI_Recv(message.data(), length, MPI_CHAR, 0, 1, MPI_COMM_WORLD, MPI_STATUS_IGNORE);
            std::cout << "rank 1 received: " << message.c_str() << std::endl;
        }
    }

    MPI_Finalize();
    return 0;
}
