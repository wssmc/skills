#pragma once

#include "hfsp/core/domain.hpp"

#include <stdexcept>

namespace hfsp {

// Explicit boundary for the optional Gurobi C++ API adapter.
// A generated project must replace this placeholder with a model whose
// feasibility semantics match the C++ decoder before marking MIP runnable.
class GurobiModel {
public:
    SolveResult solve(const Instance&) const {
        throw std::logic_error(
            "Gurobi C++ API adapter is not verified; configure GUROBI_HOME and implement the model first");
    }
};

} // namespace hfsp
