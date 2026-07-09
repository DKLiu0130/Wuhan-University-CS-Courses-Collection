#!/usr/bin/env bash
set -euo pipefail

mpicxx -O2 -std=c++17 mpi_nonblocking_demo.cpp -o mpi_nonblocking_demo
mpicxx -O2 -std=c++17 mpi_matrix_pipeline_starter.cpp -o mpi_matrix_pipeline
mpicxx -O2 -std=c++17 mpi_gradient_pipeline_extra.cpp -o mpi_gradient_pipeline_extra

echo "Build finished."
echo "Run demo:     mpirun -np 2 ./mpi_nonblocking_demo"
echo "Run blocking: mpirun -np 2 ./mpi_matrix_pipeline blocking 64"
echo "Run pipeline: mpirun -np 2 ./mpi_matrix_pipeline pipeline 64"
echo "Extra credit: mpirun -np 4 ./mpi_gradient_pipeline_extra"
