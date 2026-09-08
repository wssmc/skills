cmake_minimum_required(VERSION 3.20)
project(scheduling_research_project LANGUAGES CXX)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_EXTENSIONS OFF)

add_library(scheduling_core
    cpp/src/io/instance_loader.cpp
    cpp/src/io/result_writer.cpp
    cpp/src/algorithms/algorithms.cpp
    cpp/src/registry.cpp
)
target_include_directories(scheduling_core PUBLIC cpp/include)

add_executable(solver_run cpp/apps/solver_run.cpp)
target_link_libraries(solver_run PRIVATE scheduling_core)

enable_testing()
add_executable(scheduling_smoke cpp/tests/smoke_test.cpp)
target_link_libraries(scheduling_smoke PRIVATE scheduling_core)
add_test(NAME scheduling_smoke COMMAND scheduling_smoke)
