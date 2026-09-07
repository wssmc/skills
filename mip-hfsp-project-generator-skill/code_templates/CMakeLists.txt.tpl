cmake_minimum_required(VERSION 3.20)
project(hfsp_project LANGUAGES CXX)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_EXTENSIONS OFF)

option(HFSP_WITH_GUROBI "Build the optional Gurobi C++ MIP adapter" OFF)

add_library(hfsp_core
    cpp/src/io/instance_loader.cpp
    cpp/src/metaheuristics/algorithms.cpp
    cpp/src/registry.cpp
)
target_include_directories(hfsp_core PUBLIC cpp/include)

if(HFSP_WITH_GUROBI)
    message(FATAL_ERROR
        "HFSP_WITH_GUROBI requires an explicit Gurobi C++ adapter and GUROBI_HOME. "
        "Do not silently substitute gurobipy for the C++ core.")
endif()

add_executable(hfsp_run cpp/apps/hfsp_run.cpp)
target_link_libraries(hfsp_run PRIVATE hfsp_core)

enable_testing()
add_executable(hfsp_smoke cpp/tests/smoke_test.cpp)
target_link_libraries(hfsp_smoke PRIVATE hfsp_core)
add_test(NAME hfsp_smoke COMMAND hfsp_smoke)
