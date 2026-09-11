#include "scheduling/algorithms/search_support.hpp"

#include <algorithm>
#include <cmath>
#include <numeric>
#include <stdexcept>
#include <unordered_map>
#include <utility>

namespace scheduling {
using namespace detail;

SolveResult solve_ma_basic(const FlowShopInstance &instance, const SolveConfig &config) {
    auto result = solve_ga_basic(instance, config);
    result.result.algorithm = "ma_basic";
    return result;
}

} // namespace scheduling
