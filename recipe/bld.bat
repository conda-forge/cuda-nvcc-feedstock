@echo on
setlocal enableextensions enabledelayedexpansion || goto :error

sed -e "s/@default_cudaarchs@/%DEFAULT_CUDAARCHS%/g" ^
    -e "s/@default_torch_cuda_arch_list@/%DEFAULT_TORCH_CUDA_ARCH_LIST%/g" ^
    %RECIPE_DIR%\activate.bat > %RECIPE_DIR%\activate-replaced.bat

:: Activation script
mkdir %PREFIX%\etc\conda\activate.d
copy %RECIPE_DIR%\activate-replaced.bat %PREFIX%\etc\conda\activate.d\~cuda-nvcc_activate.bat || goto :error

:: Deactivation script
mkdir %PREFIX%\etc\conda\deactivate.d
copy %RECIPE_DIR%\deactivate.bat %PREFIX%\etc\conda\deactivate.d\~cuda-nvcc_deactivate.bat || goto :error

goto :EOF

:error
echo Failed with error %errorlevel%
exit /b %errorlevel%
