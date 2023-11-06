@echo on

:: Backup environment variables (only if the variables are set)
if defined INCLUDE (
    set "INCLUDE_CONDA_NVCC_BACKUP=%INCLUDE%"
)

set "INCLUDE=%INCLUDE%;%LIBRARY_INC%\targets\x64"
