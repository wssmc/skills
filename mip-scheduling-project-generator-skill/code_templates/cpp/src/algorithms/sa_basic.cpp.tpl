#include "scheduling/algorithms/search_support.hpp"

#include <algorithm>
#include <cmath>
#include <numeric>
#include <stdexcept>
#include <unordered_map>
#include <utility>

namespace scheduling {
using namespace detail;

SolveResult solve_sa_basic(const FlowShopInstance &instance, const SolveConfig &config) {
    instance.validate();
    const auto started = std::chrono::steady_clock::now();
    std::mt19937_64 rng(config.solve_seed);
    auto current_sequence = shuffled_sequence(instance.jobs(), rng);
    auto current = evaluate(instance, current_sequence);
    auto best_sequence = current_sequence;
    auto best = current;
    std::vector<TracePoint> trace;
    append_trace(trace, 0, best.objective, started);
    double temperature = std::max(1e-6, current.objective * 0.10);
    std::uniform_real_distribution<double> unit(0.0, 1.0);
    for (std::size_t iteration = 1;
         iteration <= config.iterations && !time_exceeded(config, started); ++iteration) {
        auto candidate_sequence = swap_neighbor(current_sequence, rng);
        auto candidate = evaluate(instance, candidate_sequence);
        const auto delta = candidate.objective - current.objective;
        if (delta <= 0.0 || unit(rng) < std::exp(-delta / temperature)) {
            current_sequence = std::move(candidate_sequence);
            current = std::move(candidate);
        }
        if (current.objective < best.objective) {
            best_sequence = current_sequence;
            best = current;
        }
        temperature = std::max(1e-6, temperature * 0.995);
        append_trace(trace, iteration, best.objective, started);
    }
    return finish("sa_basic", instance, config, best_sequence, best, std::move(trace), started);
}

} // namespace scheduling
