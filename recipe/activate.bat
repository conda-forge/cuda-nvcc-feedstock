@echo on

:: Backup environment variables (only if the variables are set)
if defined INCLUDE (
    set "INCLUDE_CONDA_NVCC_BACKUP=%INCLUDE%"
)

:: Append `targets` to search path to give exist includes preference
set "INCLUDE=%INCLUDE%;%LIBRARY_INC%\targets\x64"
