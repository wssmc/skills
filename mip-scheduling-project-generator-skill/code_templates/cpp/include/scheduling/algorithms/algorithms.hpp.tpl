#pragma once

#include "scheduling/core/domain.hpp"

#include <cstddef>
#include <cstdint>

namespace scheduling {

struct SolveConfig {
    double time_limit_seconds{30.0};
    std::uint64_t solve_seed{};
    std::size_t round{};
    std::size_t iterations{200};
};

SolveResult solve_random_search(const FlowShopInstance &, const SolveConfig &);
SolveResult solve_sa_basic(const FlowShopInstance &, const SolveConfig &);
SolveResult solve_ma_basic(const FlowShopInstance &, const SolveConfig &);
SolveResult solve_ig_basic(const FlowShopInstance &, const SolveConfig &);
SolveResult solve_ga_basic(const FlowShopInstance &, const SolveConfig &);
SolveResult solve_ts_basic(const FlowShopInstance &, const SolveConfig &);

} // namespace scheduling
