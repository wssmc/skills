#pragma once

#include "hfsp/core/domain.hpp"

#include <cstdint>
#include <string>
#include <vector>

namespace hfsp {

struct SolveConfig {
    double time_limit_seconds{30.0};
    std::uint64_t seed{0};
    std::size_t iterations{200};
};

// These are the C++ core entry points. Python is intentionally not used for
// decoding, feasibility checks, objective evaluation, or algorithm state.
SolveResult solve_random_search(const Instance&, const SolveConfig&);
SolveResult solve_sa_basic(const Instance&, const SolveConfig&);
SolveResult solve_ma_basic(const Instance&, const SolveConfig&);
SolveResult solve_ig_basic(const Instance&, const SolveConfig&);
SolveResult solve_ga_basic(const Instance&, const SolveConfig&);
SolveResult solve_ts_basic(const Instance&, const SolveConfig&);

} // namespace hfsp
