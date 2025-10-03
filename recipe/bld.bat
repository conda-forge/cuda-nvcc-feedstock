@echo on
setlocal enableextensions enabledelayedexpansion
if errorlevel 1 exit 1

sed -e "s/@default_cudaarchs@/%DEFAULT_CUDAARCHS%/g" ^
    %RECIPE_DIR%\activate.bat > %RECIPE_DIR%\activate-replaced.bat
if errorlevel 1 exit 1

:: Activation script
mkdir %PREFIX%\etc\conda\activate.d
copy %RECIPE_DIR%\activate-replaced.bat %PREFIX%\etc\conda\activate.d\~cuda-nvcc_activate.bat
if errorlevel 1 exit 1

:: Deactivation script
mkdir %PREFIX%\etc\conda\deactivate.d
copy %RECIPE_DIR%\deactivate.bat %PREFIX%\etc\conda\deactivate.d\~cuda-nvcc_deactivate.bat
if errorlevel 1 exit 1
