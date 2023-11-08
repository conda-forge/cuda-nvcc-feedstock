@echo on

:: Restore environment variables (if there is anything to restore)
if defined INCLUDE_CONDA_NVCC_BACKUP (
	set "INCLUDE=%INCLUDE_CONDA_NVCC_BACKUP%"
	set "INCLUDE_CONDA_NVCC_BACKUP="
)
