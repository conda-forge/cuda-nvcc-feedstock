#!/bin/bash
set -e
set -x
cmake_version=$(cmake --version | grep version | awk '{print $3}')

mkdir -p cmake-tests
git clone -b v${cmake_version} --depth 1 https://gitlab.kitware.com/cmake/cmake.git cmake-tests
cmake -S cmake-tests -B cmake-tests/build ${CMAKE_ARGS} -DCMake_TEST_HOST_CMAKE=ON -DCMake_TEST_CUDA=nvcc -G "Ninja"
cd cmake-tests/build

# Test exclusion list:
# Requires cublas
#   Cuda.ProperDeviceLibraries
#
# Requires curand
#   *SharedRuntime*
#
# Requires execution on a machine with a CUDA GPU
#   Cuda.ObjectLibrary
#   Cuda.WithC
#   CudaOnly.ArchSpecial
#   CudaOnly.GPUDebugFlag
#   CudaOnly.SeparateCompilationPTX
#   CudaOnly.WithDefs
#   CudaOnly.CUBIN
#   CudaOnly.Fatbin
#   CudaOnly.OptixIR
#   RunCMake.CUDA_architectures
#   *Toolkit*
# Failing due to undefined symbol: __libc_dl_error_tsd, version GLIBC_PRIVATE
#   Cuda.Complex
if [[ "${CONDA_BUILD_CROSS_COMPILATION:-0}" == "0" ]]
then
    EXTRA_EXCLUDE=
    if [ "${cross_target_platform}" == "linux-ppc64le" ]; then
      EXTRA_EXCLUDE="|CudaOnly.DontResolveDeviceSymbols"
    fi
    CUDAHOSTCXX=$CXX ctest -L CUDA --output-on-failure -j $(nproc) -E "(ProperDeviceLibraries|SharedRuntime|ObjectLibrary|WithC|ArchSpecial|GPUDebugFlag|SeparateCompilationPTX|WithDefs|CUBIN|Fatbin|OptixIR|CUDA_architectures|Toolkit|Cuda.Complex$EXTRA_EXCLUDE)"
fi
