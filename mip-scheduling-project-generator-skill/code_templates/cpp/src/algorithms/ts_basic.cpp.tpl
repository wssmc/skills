#include "scheduling/algorithms/search_support.hpp"

#include <algorithm>
#include <cmath>
#include <numeric>
#include <stdexcept>
#include <unordered_map>
#include <utility>

namespace scheduling {
using namespace detail;

SolveResult solve_ts_basic(const FlowShopInstance &instance, const SolveConfig &config) {
    instance.validate();
    const auto started = std::chrono::steady_clock::now();
    std::mt19937_64 rng(config.solve_seed);
    auto current_sequence = shuffled_sequence(instance.jobs(), rng);
    auto current = evaluate(instance, current_sequence);
    auto best_sequence = current_sequence;
    auto best = current;
    std::unordered_map<std::string, std::size_t> tabu_until;
    std::vector<TracePoint> trace;
    append_trace(trace, 0, best.objective, started);
    const std::size_t tenure = 7;
    for (std::size_t iteration = 1;
         iteration <= config.iterations && !time_exceeded(config, started); ++iteration) {
        bool selected = false;
        std::vector<std::size_t> selected_sequence;
        Evaluated selected_eval;
        std::string selected_move;
        for (std::size_t first = 0; first < current_sequence.size() && !selected; ++first) {
            for (std::size_t second = first + 1; second < current_sequence.size(); ++second) {
                auto candidate_sequence = current_sequence;
                std::swap(candidate_sequence[first], candidate_sequence[second]);
                const auto move = std::to_string(current_sequence[first]) + ":" +
                                  std::to_string(current_sequence[second]);
                const auto tabu = tabu_until.find(move);
                auto candidate = evaluate(instance, candidate_sequence);
                const bool aspiration = candidate.objective < best.objective;
                if (tabu != tabu_until.end() && tabu->second > iteration && !aspiration) {
                    continue;
                }
                if (!selected || candidate.objective < selected_eval.objective) {
                    selected = true;
                    selected_sequence = std::move(candidate_sequence);
                    selected_eval = std::move(candidate);
                    selected_move = move;
                }
            }
        }
        if (!selected) {
            break;
        }
        current_sequence = std::move(selected_sequence);
        current = std::move(selected_eval);
        tabu_until[selected_move] = iteration + tenure;
        if (current.objective < best.objective) {
            best_sequence = current_sequence;
            best = current;
        }
        append_trace(trace, iteration, best.objective, started);
    }
    return finish("ts_basic", instance, config, best_sequence, best, std::move(trace), started);
}

} // namespace scheduling
