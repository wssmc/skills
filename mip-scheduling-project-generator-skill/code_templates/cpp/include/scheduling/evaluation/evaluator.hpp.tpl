#pragma once

#include "scheduling/core/domain.hpp"
#include <limits>

namespace scheduling {

struct Evaluated {
    double objective{std::numeric_limits<double>::infinity()};
    Schedule schedule;
};

Evaluated evaluate(const FlowShopInstance &, const std::vector<std::size_t> &);

} // namespace scheduling
