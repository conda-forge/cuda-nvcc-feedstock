#!/bin/bash

ERROR=false

[[ "@cross_target_platform@" == "linux-64" ]] && targetsDir="targets/x86_64-linux"
[[ "@cross_target_platform@" == "linux-ppc64le" ]] && targetsDir="targets/ppc64le-linux"
[[ "@cross_target_platform@" == "linux-aarch64" ]] && targetsDir="targets/sbsa-linux"

CUDA_CFLAGS=""
CUDA_LDFLAGS=""
if [ "${CONDA_BUILD:-0}" = "1" ]; then
    CUDA_CFLAGS="${CUDA_CFLAGS} -I${PREFIX}/${targetsDir}/include"
    CUDA_CFLAGS="${CUDA_CFLAGS} -I${BUILD_PREFIX}/${targetsDir}/include"
    CUDA_LDFLAGS="${CUDA_LDFLAGS} -L${PREFIX}/${targetsDir}/lib"
    CUDA_LDFLAGS="${CUDA_LDFLAGS} -L${PREFIX}/${targetsDir}/lib/stubs"
    CUDA_LDFLAGS="${CUDA_LDFLAGS} -L${BUILD_PREFIX}/${targetsDir}/lib"
    CUDA_LDFLAGS="${CUDA_LDFLAGS} -L${BUILD_PREFIX}/${targetsDir}/lib/stubs"
    # Needed to fix cross compilation
    export CMAKE_ARGS="${CMAKE_ARGS} -DCMAKE_FIND_ROOT_PATH=$PREFIX;$BUILD_PREFIX/$HOST/sysroot;$BUILD_PREFIX/${targetsDir}"
else
    CUDA_CFLAGS="${CUDA_CFLAGS} -I${CONDA_PREFIX}/${targetsDir}/include"
    CUDA_LDFLAGS="${CUDA_LDFLAGS} -L${CONDA_PREFIX}/${targetsDir}/lib"
    CUDA_LDFLAGS="${CUDA_LDFLAGS} -L${CONDA_PREFIX}/${targetsDir}/lib/stubs"
fi
export CFLAGS="${CFLAGS} ${CUDA_CFLAGS} ${CUDA_LDFLAGS}"
export CPPFLAGS="${CPPFLAGS} ${CUDA_CFLAGS} ${CUDA_LDFLAGS}"
export CXXFLAGS="${CXXFLAGS} ${CUDA_CFLAGS} ${CUDA_LDFLAGS}"
export LDFLAGS="${LDFLAGS} ${CUDA_LDFLAGS}"

if [ -z "${CXX+x}" ]; then
    echo 'cuda-nvcc: Please add the `compiler("c")` and `compiler("cxx")` packages to the environment.'
    ERROR=true
else
    if [[ ! -z "${NVCC_PREPEND_FLAGS+x}" ]]
    then
        export NVCC_PREPEND_FLAGS_BACKUP="${NVCC_PREPEND_FLAGS}"
    fi
    NVCC_PREPEND_FLAGS="${NVCC_PREPEND_FLAGS} -ccbin=${CXX}"
    # For conda-build we add the host requirements prefix to the include- and
    # link-paths for nvcc because it is separate from the build prefix where
    # nvcc is installed.
    if [ "${CONDA_BUILD:-0}" = "1" ]; then
        NVCC_PREPEND_FLAGS="${NVCC_PREPEND_FLAGS} -I${PREFIX}/${targetsDir}/include"
        NVCC_PREPEND_FLAGS="${NVCC_PREPEND_FLAGS} -L${PREFIX}/${targetsDir}/lib"
        NVCC_PREPEND_FLAGS="${NVCC_PREPEND_FLAGS} -L${PREFIX}/${targetsDir}/lib/stubs"
    fi
    export NVCC_PREPEND_FLAGS
fi

# Exit with unclean status if there was an error
! $ERROR
