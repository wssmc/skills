#include "scheduling/algorithms/search_support.hpp"

#include <algorithm>
#include <cmath>
#include <numeric>
#include <stdexcept>
#include <unordered_map>
#include <utility>

namespace scheduling {
using namespace detail;

SolveResult solve_ig_basic(const FlowShopInstance &instance, const SolveConfig &config) {
    instance.validate();
    const auto started = std::chrono::steady_clock::now();
    std::mt19937_64 rng(config.solve_seed);
    auto current_sequence = shuffled_sequence(instance.jobs(), rng);
    auto current = evaluate(instance, current_sequence);
    auto best_sequence = current_sequence;
    auto best = current;
    std::vector<TracePoint> trace;
    append_trace(trace, 0, best.objective, started);
    for (std::size_t iteration = 1;
         iteration <= config.iterations && !time_exceeded(config, started); ++iteration) {
        auto candidate_sequence = current_sequence;
        if (candidate_sequence.size() > 1) {
            std::uniform_int_distribution<std::size_t> pick(0, candidate_sequence.size() - 1);
            auto first = pick(rng);
            auto second = pick(rng);
            if (first > second) {
                std::swap(first, second);
            }
            std::vector<std::size_t> removed(
                candidate_sequence.begin() + static_cast<std::ptrdiff_t>(first),
                candidate_sequence.begin() + static_cast<std::ptrdiff_t>(second + 1));
            candidate_sequence.erase(
                candidate_sequence.begin() + static_cast<std::ptrdiff_t>(first),
                candidate_sequence.begin() + static_cast<std::ptrdiff_t>(second + 1));
            std::shuffle(removed.begin(), removed.end(), rng);
            for (const auto job : removed) {
                std::uniform_int_distribution<std::size_t> insert_at(0, candidate_sequence.size());
                candidate_sequence.insert(
                    candidate_sequence.begin() + static_cast<std::ptrdiff_t>(insert_at(rng)), job);
            }
        }
        auto candidate = evaluate(instance, candidate_sequence);
        if (candidate.objective <= current.objective) {
            current_sequence = std::move(candidate_sequence);
            current = std::move(candidate);
        }
        if (current.objective < best.objective) {
            best_sequence = current_sequence;
            best = current;
        }
        append_trace(trace, iteration, best.objective, started);
    }
    return finish("ig_basic", instance, config, best_sequence, best, std::move(trace), started);
}

} // namespace scheduling
