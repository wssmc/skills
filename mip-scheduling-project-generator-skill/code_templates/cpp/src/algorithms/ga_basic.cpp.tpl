#include "scheduling/algorithms/search_support.hpp"

#include <algorithm>
#include <cmath>
#include <numeric>
#include <stdexcept>
#include <unordered_map>
#include <utility>

namespace scheduling {
using namespace detail;

SolveResult solve_ga_basic(const FlowShopInstance &instance, const SolveConfig &config) {
    instance.validate();
    const auto started = std::chrono::steady_clock::now();
    std::mt19937_64 rng(config.solve_seed);
    const std::size_t population_size =
        std::max<std::size_t>(4, std::min<std::size_t>(20, instance.jobs() * 2));
    std::vector<std::vector<std::size_t>> population;
    for (std::size_t index = 0; index < population_size; ++index) {
        population.push_back(shuffled_sequence(instance.jobs(), rng));
    }
    auto best_sequence = population.front();
    auto best = evaluate(instance, best_sequence);
    std::vector<TracePoint> trace;
    append_trace(trace, 0, best.objective, started);
    std::uniform_real_distribution<double> unit(0.0, 1.0);
    for (std::size_t generation = 1;
         generation <= config.iterations && !time_exceeded(config, started); ++generation) {
        std::vector<std::vector<std::size_t>> next_population;
        while (next_population.size() < population_size) {
            std::uniform_int_distribution<std::size_t> pick(0, population.size() - 1);
            const auto &parent_a = population[pick(rng)];
            const auto &parent_b = population[pick(rng)];
            auto child = order_crossover(parent_a, parent_b, rng);
            if (unit(rng) < 0.25) {
                child = swap_neighbor(child, rng);
            }
            next_population.push_back(std::move(child));
        }
        population = std::move(next_population);
        for (const auto &candidate_sequence : population) {
            auto candidate = evaluate(instance, candidate_sequence);
            if (candidate.objective < best.objective) {
                best_sequence = candidate_sequence;
                best = std::move(candidate);
            }
        }
        append_trace(trace, generation, best.objective, started);
    }
    return finish("ga_basic", instance, config, best_sequence, best, std::move(trace), started);
}

} // namespace scheduling
