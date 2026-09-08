#pragma once

#include "scheduling/core/domain.hpp"
#include "scheduling/algorithms/algorithms.hpp"

#include <functional>
#include <map>
#include <string>
#include <vector>

namespace scheduling {

using SolverFunction = std::function<SolveResult(const FlowShopInstance&, const SolveConfig&)>;

const std::map<std::string, SolverFunction>& algorithm_registry();
std::vector<std::string> runnable_algorithms();

} // namespace scheduling
