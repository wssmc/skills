#include "scheduling/algorithms/search_support.hpp"

#include <algorithm>
#include <numeric>
#include <stdexcept>
#include <utility>

namespace scheduling::detail {

double elapsed_since(const std::chrono::steady_clock::time_point started) {
    return std::chrono::duration<double>(std::chrono::steady_clock::now() - started).count();
}

SolveResult finish(const std::string &name, const FlowShopInstance &instance,
                   const SolveConfig &config, const std::vector<std::size_t> &best_sequence,
                   const Evaluated &best, std::vector<TracePoint> trace,
                   const std::chrono::steady_clock::time_point started) {
    if (best_sequence.size() != instance.jobs() ||
        best.schedule.operations.size() != instance.jobs() * instance.stages()) {
        throw std::logic_error("solver finished without a complete best schedule");
    }
    Result result{instance.id,
                  name,
                  best.objective,
                  elapsed_since(started),
                  instance.instance_seed,
                  config.solve_seed,
                  config.round,
                  true,
                  best_sequence};
    result.status = "FEASIBLE";
    return {best.schedule, std::move(result), std::move(trace)};
}

std::vector<std::size_t> shuffled_sequence(std::size_t jobs, std::mt19937_64 &rng) {
    std::vector<std::size_t> sequence(jobs);
    std::iota(sequence.begin(), sequence.end(), 0);
    std::shuffle(sequence.begin(), sequence.end(), rng);
    return sequence;
}

std::vector<std::size_t> swap_neighbor(const std::vector<std::size_t> &sequence,
                                       std::mt19937_64 &rng) {
    auto candidate = sequence;
    if (candidate.size() > 1) {
        std::uniform_int_distribution<std::size_t> pick(0, candidate.size() - 1);
        const auto first = pick(rng);
        auto second = pick(rng);
        if (first == second) {
            second = (second + 1) % candidate.size();
        }
        std::swap(candidate[first], candidate[second]);
    }
    return candidate;
}

void append_trace(std::vector<TracePoint> &trace, std::size_t iteration, double objective,
                  const std::chrono::steady_clock::time_point started) {
    trace.push_back({iteration, elapsed_since(started), objective});
}

bool time_exceeded(const SolveConfig &config, const std::chrono::steady_clock::time_point started) {
    return elapsed_since(started) >= config.time_limit_seconds;
}

std::vector<std::size_t> order_crossover(const std::vector<std::size_t> &first,
                                         const std::vector<std::size_t> &second,
                                         std::mt19937_64 &rng) {
    if (first.size() < 2) {
        return first;
    }
    std::uniform_int_distribution<std::size_t> pick(0, first.size() - 1);
    auto left = pick(rng);
    auto right = pick(rng);
    if (left > right) {
        std::swap(left, right);
    }
    std::vector<std::size_t> child(first.size(), first.size());
    std::vector<bool> used(first.size(), false);
    for (std::size_t index = left; index <= right; ++index) {
        child[index] = first[index];
        used[first[index]] = true;
    }
    std::size_t write = (right + 1) % first.size();
    for (std::size_t offset = 0; offset < second.size(); ++offset) {
        const auto gene = second[(right + 1 + offset) % second.size()];
        if (!used[gene]) {
            child[write] = gene;
            used[gene] = true;
            write = (write + 1) % first.size();
        }
    }
    return child;
}

} // namespace scheduling::detail
