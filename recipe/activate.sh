#!/bin/bash

ERROR=false

[[ "@cross_target_platform@" == "linux-64" ]] && targetsDir="targets/x86_64-linux"
[[ "@cross_target_platform@" == "linux-ppc64le" ]] && targetsDir="targets/ppc64le-linux"
[[ "@cross_target_platform@" == "linux-aarch64" ]] && targetsDir="targets/sbsa-linux"

CUDA_FLAGS=""
if [ "${CONDA_BUILD:-0}" = "1" ]; then
    CUDA_FLAGS="${CUDA_FLAGS} -I${PREFIX}/${targetsDir}/include"
    CUDA_FLAGS="${CUDA_FLAGS} -I${BUILD_PREFIX}/${targetsDir}/include"
    # Needed to fix cross compilation
    export CMAKE_ARGS="${CMAKE_ARGS} -DCMAKE_FIND_ROOT_PATH=$PREFIX;$BUILD_PREFIX/$HOST/sysroot;$BUILD_PREFIX/${targetsDir}"
else
    CUDA_FLAGS="${CUDA_FLAGS} -I${CONDA_PREFIX}/${targetsDir}/include"
fi

export CFLAGS="${CFLAGS} ${CUDA_FLAGS}"
export CPPFLAGS="${CPPFLAGS} ${CUDA_FLAGS}"
export CXXFLAGS="${CXXFLAGS} ${CUDA_FLAGS}"
if [ -z "${CXX+x}" ]; then
    echo 'cuda-nvcc: Please add the `compiler("c")` and `compiler("cxx")` packages to the environment.'
    ERROR=true
else
    if [[ ! -z "${NVCC_PREPEND_FLAGS+x}" ]]
    then
        export NVCC_PREPEND_FLAGS_BACKUP="${NVCC_PREPEND_FLAGS}"
    fi
    export NVCC_PREPEND_FLAGS="${NVCC_PREPEND_FLAGS} -ccbin=${CXX}"
fi

# Exit with unclean status if there was an error
! $ERROR
