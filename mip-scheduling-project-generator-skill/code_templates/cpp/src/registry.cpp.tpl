#include "scheduling/registry.hpp"

#include <algorithm>

namespace scheduling {

const std::map<std::string, SolverFunction>& algorithm_registry() {
    static const std::map<std::string, SolverFunction> registry{
        {"random_search", solve_random_search},
        {"sa_basic", solve_sa_basic},
        {"ma_basic", solve_ma_basic},
        {"ig_basic", solve_ig_basic},
        {"ga_basic", solve_ga_basic},
        {"ts_basic", solve_ts_basic},
    };
    return registry;
}

std::vector<std::string> runnable_algorithms() {
    std::vector<std::string> names;
    for (const auto& [name, _] : algorithm_registry()) {
        names.push_back(name);
    }
    return names;
}

} // namespace scheduling
