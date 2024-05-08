@echo on

nvcc --version
if errorlevel 1 exit 1


cl /Tp test.cpp /link /LIBPATH:"%CONDA_PREFIX%\Library\lib" cudart_static.lib /out:test_nvcc.exe
if errorlevel 1 exit 1

nvcc --verbose test.cu
if errorlevel 1 exit 1


cmake %CMAKE_ARGS% -S . -B ./build -G=Ninja
if errorlevel 1 exit 1

cmake --build ./build -v
if errorlevel 1 exit 1
