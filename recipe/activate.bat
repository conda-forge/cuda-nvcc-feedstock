@echo on

:: Backup environment variables (only if the variables are set)
if defined INCLUDE (
    set "INCLUDE_CONDA_NVCC_BACKUP=%INCLUDE%"
) else (
    set "INCLUDE_CONDA_NVCC_BACKUP=UNSET"
)

:: Append `targets` to search path to give exist includes preference
set "INCLUDE=%INCLUDE%;%LIBRARY_INC%\targets\x64;%LIBRARY_INC%\targets\x64\cccl"

if "%CONDA_BUILD%" == "1" (
    :: Set good defaults for common target architectures according to host platform for common
    :: configuration environment variables
    if not defined CUDAARCHS (
        set "CUDAARCHS=@default_cudaarchs@"
        set "CUDAARCHS_BACKUP=UNSET"
    )
)
