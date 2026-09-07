#pragma once

#include "hfsp/core/domain.hpp"
#include "hfsp/metaheuristics/algorithms.hpp"

#include <functional>
#include <map>
#include <memory>
#include <string>
#include <vector>

namespace hfsp {

using SolverFunction = std::function<SolveResult(const Instance&, const SolveConfig&)>;

const std::map<std::string, SolverFunction>& algorithm_registry();
std::vector<std::string> runnable_algorithms();

} // namespace hfsp
