#include "scheduling/algorithms/search_support.hpp"

#include <algorithm>
#include <cmath>
#include <numeric>
#include <stdexcept>
#include <unordered_map>
#include <utility>

namespace scheduling {
using namespace detail;

SolveResult greedy_random_search(const FlowShopInstance &instance, const SolveConfig &config,
                                 const std::string &name) {
    instance.validate();
    const auto started = std::chrono::steady_clock::now();
    std::mt19937_64 rng(config.solve_seed);
    auto best_sequence = shuffled_sequence(instance.jobs(), rng);
    auto best = evaluate(instance, best_sequence);
    std::vector<TracePoint> trace;
    append_trace(trace, 0, best.objective, started);
    for (std::size_t iteration = 1;
         iteration <= config.iterations && !time_exceeded(config, started); ++iteration) {
        auto candidate = shuffled_sequence(instance.jobs(), rng);
        const auto evaluated = evaluate(instance, candidate);
        if (evaluated.objective < best.objective) {
            best_sequence = std::move(candidate);
            best = evaluated;
        }
        append_trace(trace, iteration, best.objective, started);
    }
    return finish(name, instance, config, best_sequence, best, std::move(trace), started);
}

SolveResult solve_random_search(const FlowShopInstance &instance, const SolveConfig &config) {
    return greedy_random_search(instance, config, "random_search");
}

} // namespace scheduling
