@echo off
setlocal

set ROOT=%~dp0
set OUT=%ROOT%msmpisdk_extract

if exist "%OUT%\PFiles\Microsoft SDKs\MPI\Include\mpi.h" (
  echo MS-MPI SDK already extracted:
  echo %OUT%
  exit /b 0
)

mkdir "%OUT%" 2>nul
msiexec /a "%ROOT%msmpisdk.msi" /qn TARGETDIR="%OUT%"
if errorlevel 1 (
  echo Failed to extract MS-MPI SDK.
  exit /b 1
)

echo Extracted MS-MPI SDK to:
echo %OUT%
