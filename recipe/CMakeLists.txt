cmake_minimum_required(VERSION 3.20 FATAL_ERROR)

project(verify_cuda_compiler LANGUAGES CUDA)
if(NOT DEFINED CMAKE_CUDA_TOOLKIT_INCLUDE_DIRECTORIES)
  message(FATAL_ERROR "CUDA compiler detection failed, no recording of CMAKE_CUDA_TOOLKIT_INCLUDE_DIRECTORIES")
endif()
add_executable(verify test.cu)
