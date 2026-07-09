@echo off
setlocal

set SCRIPT_DIR=%~dp0
set ROOT=%SCRIPT_DIR%..
if not exist "%ROOT%\tools\w64devkit_extract\w64devkit\bin\g++.exe" set ROOT=%SCRIPT_DIR%..\..
set W64=%ROOT%\tools\w64devkit_extract\w64devkit\bin
set MPIBIN=C:\Program Files\Microsoft MPI\Bin
set MPIINC=%ROOT%\tools\mpi\msmpisdk_extract\PFiles\Microsoft SDKs\MPI\Include
set MPILIB=%ROOT%\tools\mpi\msmpisdk_extract\PFiles\Microsoft SDKs\MPI\Lib\x64\msmpi.lib

set PATH=%W64%;%MPIBIN%;%PATH%

if not exist "%MPIBIN%\mpiexec.exe" (
  echo MS-MPI runtime is not installed. Please install tools\mpi\msmpisetup.exe first.
  exit /b 1
)

if not exist "%W64%\g++.exe" (
  echo Cannot find w64devkit. Please put this folder under the course directory that contains tools.
  exit /b 1
)

if not exist "%MPIINC%\mpi.h" (
  echo Cannot find MS-MPI SDK include files under tools\mpi.
  exit /b 1
)

g++ -O2 -std=c++17 -I "%MPIINC%" mpi_nonblocking_demo.cpp "%MPILIB%" -o mpi_nonblocking_demo.exe
if errorlevel 1 exit /b 1

g++ -O2 -std=c++17 -I "%MPIINC%" mpi_matrix_pipeline_starter.cpp "%MPILIB%" -o mpi_matrix_pipeline.exe
if errorlevel 1 exit /b 1

g++ -O2 -std=c++17 -I "%MPIINC%" mpi_gradient_pipeline_extra.cpp "%MPILIB%" -o mpi_gradient_pipeline_extra.exe
if errorlevel 1 exit /b 1

echo Build finished.
echo Run demo:      mpiexec -n 2 mpi_nonblocking_demo.exe
echo Run blocking:  mpiexec -n 2 mpi_matrix_pipeline.exe blocking 64
echo Run pipeline:  mpiexec -n 2 mpi_matrix_pipeline.exe pipeline 64
echo Extra credit:  mpiexec -n 4 mpi_gradient_pipeline_extra.exe
