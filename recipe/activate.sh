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
    # Needed to fix cross compilation.
    # $PREFIX and $PREFIX/${targetsDir} are needed to properly find all host components
    # $BUILD_PREFIX/$HOST/sysroot is needed to find compiler bits and is placed before any `targetsDir` for priority.
    # $BUILD_PREFIX/${targetsDir} is needed for projects that don't enable the CUDA language but use FindCUDAToolkit
    export CMAKE_ARGS="${CMAKE_ARGS} -DCMAKE_FIND_ROOT_PATH=$PREFIX;$BUILD_PREFIX/$HOST/sysroot;$PREFIX/${targetsDir};$BUILD_PREFIX/${targetsDir}"
else
    CUDA_CFLAGS="${CUDA_CFLAGS} -I${CONDA_PREFIX}/${targetsDir}/include"
    CUDA_LDFLAGS="${CUDA_LDFLAGS} -L${CONDA_PREFIX}/${targetsDir}/lib"
    CUDA_LDFLAGS="${CUDA_LDFLAGS} -L${CONDA_PREFIX}/${targetsDir}/lib/stubs"
fi
export CFLAGS="${CFLAGS} ${CUDA_CFLAGS}"
export CPPFLAGS="${CPPFLAGS} ${CUDA_CFLAGS}"
export CXXFLAGS="${CXXFLAGS} ${CUDA_CFLAGS}"
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
    export NVCC_PREPEND_FLAGS

    if [[ ! -z "${NVCC_APPEND_FLAGS+x}" ]]
    then
        export NVCC_APPEND_FLAGS_BACKUP="${NVCC_APPEND_FLAGS}"
    fi
    # For conda-build we add the host requirements prefix to the include- and
    # link-paths for nvcc because it is separate from the build prefix where
    # nvcc is installed. We do this using `NVCC_APPEND_FLAGS` so that it
    # goes last on the compiler/link line. This ensures that these flags
    # match the behavior of the other implicit flags of the compiler, allowing
    # for user overrides.
    if [ "${CONDA_BUILD:-0}" = "1" ]; then
        NVCC_APPEND_FLAGS="${NVCC_APPEND_FLAGS} -I${PREFIX}/${targetsDir}/include"
        NVCC_APPEND_FLAGS="${NVCC_APPEND_FLAGS} -L${PREFIX}/${targetsDir}/lib"
        NVCC_APPEND_FLAGS="${NVCC_APPEND_FLAGS} -L${PREFIX}/${targetsDir}/lib/stubs"
    fi
    export NVCC_APPEND_FLAGS
fi

# Exit with unclean status if there was an error
! $ERROR
