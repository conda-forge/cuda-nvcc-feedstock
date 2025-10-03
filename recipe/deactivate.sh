#!/bin/bash

if [[ ! -z "${NVCC_PREPEND_FLAGS_BACKUP+x}" ]]
then
  if [[ "${NVCC_PREPEND_FLAGS_BACKUP}" == "UNSET" ]]
  then
    unset NVCC_PREPEND_FLAGS
  else
    export NVCC_PREPEND_FLAGS="${NVCC_PREPEND_FLAGS_BACKUP}"
  fi
  unset NVCC_PREPEND_FLAGS_BACKUP
fi

if [[ ! -z "${NVCC_APPEND_FLAGS_BACKUP+x}" ]]
then
  export NVCC_APPEND_FLAGS="${NVCC_APPEND_FLAGS_BACKUP}"
  unset NVCC_APPEND_FLAGS_BACKUP
fi

if [[ "${CUDAARCHS_BACKUP}" == "UNSET" ]]
then
  unset CUDAARCHS
  unset CUDAARCHS_BACKUP
fi
