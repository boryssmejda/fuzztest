cmake_minimum_required(VERSION 3.22)

project(google-fuzztest)

include(${CMAKE_CURRENT_SOURCE_DIR}/cmake/project_flags.cmake)
include(${CMAKE_CURRENT_SOURCE_DIR}/cmake/add_dependencies.cmake)

add_subdirectory(${CMAKE_CURRENT_SOURCE_DIR}/fuzztest)
