#!/bin/bash

export CFLAGS_CUDA_NVCC_BACKUP="${CFLAGS}"
export CPPFLAGS_CUDA_NVCC_BACKUP="${CPPFLAGS}"
export CXXFLAGS_CUDA_NVCC_BACKUP="${CXXFLAGS}"
export NVCC_PREPEND_FLAGS_BACKUP="${NVCC_PREPEND_FLAGS}"

[[ "@cross_target_platform@" == "linux-64" ]] && targetsDir="targets/x86_64-linux"
[[ "@cross_target_platform@" == "linux-ppc64le" ]] && targetsDir="targets/ppc64le-linux"
[[ "@cross_target_platform@" == "linux-aarch64" ]] && targetsDir="targets/sbsa-linux"

if [ "${CONDA_BUILD:-0}" = "1" ]; then
    if [ -z "${CXX+x}" ]; then
        echo 'cuda-nvcc: Please add the `compiler("c")` and `compiler("cxx")` packages to the environment.'
        exit 1
    fi
    CUDA_INCLUDE_DIR="${PREFIX}/${targetsDir}/include"
    # Needed to fix cross compilation
    export CMAKE_ARGS="${CMAKE_ARGS} -DCMAKE_FIND_ROOT_PATH=$PREFIX;$BUILD_PREFIX/$HOST/sysroot;$BUILD_PREFIX/${targetsDir}"
else
    CUDA_INCLUDE_DIR="${CONDA_PREFIX}/${targetsDir}/include"
fi

# (Leo checking if this is needed): Avoid GCC warnings due to using headers from `BUILD_PREFIX`
# ln -s "${BUILD_PREFIX}/${targetsDir}/include/crt" "${CUDA_INCLUDE_DIR}"

export CFLAGS="${CFLAGS} -I${CUDA_INCLUDE_DIR}"
export CPPFLAGS="${CPPFLAGS} -I${CUDA_INCLUDE_DIR}"
export CXXFLAGS="${CXXFLAGS} -I${CUDA_INCLUDE_DIR}"
export NVCC_PREPEND_FLAGS="${NVCC_PREPEND_FLAGS} -ccbin=${CXX}"
