#!/bin/bash

export CFLAGS_BACKUP="${CFLAGS}"
export CPPFLAGS_BACKUP="${CPPFLAGS}"
export CXXFLAGS_BACKUP="${CXXFLAGS}"
export NVCC_PREPEND_FLAGS_BACKUP="${NVCC_PREPEND_FLAGS}"

if [ "${CONDA_BUILD:-0}" = "1" ]; then
    if [ -z "${CXX+x}" ]; then echo 'cuda-nvcc: Please add the `compiler("c")` and `compiler("cxx")` packages to the environment.'; exit 1; fi

    [[ ${target_platform} == "linux-64" ]] && targetsDir="targets/x86_64-linux"
    [[ ${target_platform} == "linux-ppc64le" ]] && targetsDir="targets/ppc64le-linux"
    [[ ${target_platform} == "linux-aarch64" ]] && targetsDir="targets/sbsa-linux"
    CUDA_INCLUDE_DIR="${PREFIX}/${targetsDir}/include"

    # (Leo checking if this is needed): Avoid GCC warnings due to using headers from `BUILD_PREFIX`
    ln -s "${BUILD_PREFIX}/${targetsDir}/include/crt" "${CUDA_INCLUDE_DIR}"

    export CFLAGS="${CFLAGS} -isystem ${CUDA_INCLUDE_DIR}"
    export CPPFLAGS="${CPPFLAGS} -isystem ${CUDA_INCLUDE_DIR}"
    export CXXFLAGS="${CXXFLAGS} -isystem ${CUDA_INCLUDE_DIR}"
    export NVCC_PREPEND_FLAGS="${NVCC_PREPEND_FLAGS} -ccbin=${CXX} -isystem ${CUDA_INCLUDE_DIR}"
else
  # Todo: Either symlink headers to "${PREFIX}/include" in `cuda-nvcc`
  #       or add logic here to handle `target_platform` outside conda-build
  CUDA_INCLUDE_DIR="${PREFIX}/include"
  export CFLAGS="${CFLAGS} -isystem ${CUDA_INCLUDE_DIR}"
  export CPPFLAGS="${CPPFLAGS} -isystem ${CUDA_INCLUDE_DIR}"
  export CXXFLAGS="${CXXFLAGS} -isystem ${CUDA_INCLUDE_DIR}"
  export NVCC_PREPEND_FLAGS="${NVCC_PREPEND_FLAGS} -ccbin=${CXX} -isystem ${CUDA_INCLUDE_DIR}"
fi
