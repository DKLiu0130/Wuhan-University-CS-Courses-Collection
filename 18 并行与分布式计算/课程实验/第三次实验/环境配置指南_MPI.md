# 第三堂课环境配置：MPI

本节课使用 MPI 完成多进程倒排索引构建。请课前完成 MPI 环境安装，并确认能运行 `mpiexec`。

## Windows

推荐使用 MS-MPI runtime + 课程包中已解包的 SDK。安装包已经放在：

- `mpi/msmpisetup.exe`
- `mpi/msmpisdk.msi`
- `mpi/msmpisdk_extract/`

安装步骤：

1. 双击安装 `msmpisetup.exe`。
2. 课程包已提供 `msmpisdk_extract`，其中包含 `mpi.h` 和 `msmpi.lib`，一般不需要管理员安装 SDK。
3. 使用课程包中的 `w64devkit` 编译。

验证：

```powershell
& "C:\Program Files\Microsoft MPI\Bin\mpiexec.exe" -help
```

编译 demo：

```powershell
.\build_windows_mpi.bat
```

运行 demo：

```powershell
mpiexec -n 4 mpi_hello_demo.exe
```

## macOS

推荐使用 Homebrew 安装 OpenMPI：

```bash
brew install open-mpi
mpicxx --version
mpirun --version
```

编译运行：

```bash
mpicxx -O2 -std=c++17 mpi_hello_demo.cpp -o mpi_hello_demo
mpirun -np 4 ./mpi_hello_demo
```

## Linux

Ubuntu / Debian 可安装 OpenMPI：

```bash
sudo apt update
sudo apt install -y openmpi-bin libopenmpi-dev
mpicxx --version
mpirun --version
```

编译运行：

```bash
mpicxx -O2 -std=c++17 mpi_hello_demo.cpp -o mpi_hello_demo
mpirun -np 4 ./mpi_hello_demo
```

## 常见问题

- `mpiexec` 找不到：Windows 请确认已安装 `msmpisetup.exe`，并重新打开终端。
- `mpi.h` 找不到：Windows 请确认课程包中存在 `tools/mpi/msmpisdk_extract/PFiles/Microsoft SDKs/MPI/Include/mpi.h`。
- 程序只输出一行：确认运行命令里有 `-n 4` 或 `-np 4`。
- 不同系统命令略有差异：Windows 常用 `mpiexec -n 4`，macOS/Linux 常用 `mpirun -np 4`。
