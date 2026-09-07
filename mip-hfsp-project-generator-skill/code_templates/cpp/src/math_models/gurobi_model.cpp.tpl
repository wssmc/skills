#include "hfsp/math_models/gurobi_model.hpp"

// Keep the Gurobi adapter out of the default no-dependency build. When a
// license and GUROBI_HOME are available, add gurobi_c++.h and link the C++ API
// in CMake; do not introduce gurobipy into the solver path.
