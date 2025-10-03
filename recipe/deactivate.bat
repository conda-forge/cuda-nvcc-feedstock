@echo on

:: Restore environment variables (if there is anything to restore)
if defined INCLUDE_CONDA_NVCC_BACKUP (
	if "%INCLUDE_CONDA_NVCC_BACKUP%"=="UNSET" (
		set "INCLUDE="
	) else (
		set "INCLUDE=%INCLUDE_CONDA_NVCC_BACKUP%"
	)
	set "INCLUDE_CONDA_NVCC_BACKUP="
)

if "%CUDAARCHS_BACKUP%" == "UNSET" (
    set "CUDAARCHS="
    set "CUDAARCHS_BACKUP="
)
