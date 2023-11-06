@echo on
setlocal enableextensions enabledelayedexpansion || goto :error

:: Activation script
mkdir %PREFIX%\etc\conda\activate.d
copy %RECIPE_DIR%\activate.bat %PREFIX%\etc\conda\activate.d\~cuda-nvcc_activate.bat || goto :error

:: Deactivation script
mkdir %PREFIX%\etc\conda\deactivate.d
copy %RECIPE_DIR%\deactivate.bat %PREFIX%\etc\conda\deactivate.d\~cuda-nvcc_deactivate.bat || goto :error

goto :EOF

:error
echo Failed with error %errorlevel%
exit /b %errorlevel%
