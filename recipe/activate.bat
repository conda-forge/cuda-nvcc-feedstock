@echo on

:: Backup environment variables (only if the variables are set)
if defined INCLUDE (
    set "INCLUDE_CONDA_NVCC_BACKUP=%INCLUDE%"
)

:: Append `targets` to search path to give exist includes preference
set "INCLUDE=%INCLUDE%;%LIBRARY_INC%\targets\x64"

:: Set good defaults for common target architectures according to host platform for common
:: configuration environment variables
if not defined CUDAARCHS (
    set "CUDAARCHS=@default_cudaarchs@"
)
if not defined TORCH_CUDA_ARCH_LIST (
    set "TORCH_CUDA_ARCH_LIST=@default_torch_cuda_arch_list@"
)
