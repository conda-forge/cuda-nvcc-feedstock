#!/bin/bash

if [[ -n "$CXX" ]]; then
    export NVCC_PREPEND_FLAGS_BACKUP="${NVCC_PREPEND_FLAGS}"
    export NVCC_PREPEND_FLAGS="${NVCC_PREPEND_FLAGS} -ccbin=${CXX}"
fi
if [ -z "${CXX+x}" ]; then echo 'cuda-nvcc: Please add the `c-compiler` and `cxx-compiler` packages to the environment.'; fi
