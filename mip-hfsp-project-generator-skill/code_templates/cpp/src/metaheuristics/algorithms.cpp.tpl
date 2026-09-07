#include "hfsp/metaheuristics/algorithms.hpp"

#include "hfsp/decoding/eval_cache.hpp"

#include <algorithm>
#include <chrono>
#include <cmath>
#include <functional>
#include <limits>
#include <numeric>
#include <random>
#include <stdexcept>
#include <unordered_map>
#include <utility>

namespace hfsp {
namespace {

struct Evaluated {
    double objective{std::numeric_limits<double>::infinity()};
    Schedule schedule;
};

Evaluated evaluate(const Instance& instance, const std::vector<std::size_t>& sequence, EvalCache& cache) {
    if (sequence.size() != instance.jobs()) {
        throw std::invalid_argument("job sequence length does not match instance");
    }
    std::vector<bool> seen(instance.jobs(), false);
    for (const auto job : sequence) {
        if (job >= instance.jobs() || seen[job]) {
            throw std::invalid_argument("job sequence must be a permutation");
        }
        seen[job] = true;
    }

    std::vector<double> job_ready(instance.jobs(), 0.0);
    std::vector<std::vector<double>> machine_ready(instance.stages());
    for (std::size_t stage = 0; stage < instance.stages(); ++stage) {
        machine_ready[stage].assign(instance.machines_per_stage[stage], 0.0);
    }
    Schedule schedule;
    std::vector<std::size_t> machine_assignment;
    machine_assignment.reserve(instance.jobs() * instance.stages());
    for (const auto job : sequence) {
        for (std::size_t stage = 0; stage < instance.stages(); ++stage) {
            const auto machine = static_cast<std::size_t>(std::min_element(
                machine_ready[stage].begin(), machine_ready[stage].end()) - machine_ready[stage].begin());
            const auto start = std::max(job_ready[job], machine_ready[stage][machine]);
            const auto end = start + instance.processing_times[job][stage];
            schedule.operations.push_back({job, stage, machine, start, end});
            machine_assignment.push_back(machine);
            job_ready[job] = end;
            machine_ready[stage][machine] = end;
            schedule.makespan = std::max(schedule.makespan, end);
        }
    }

    const auto key = make_eval_key(instance.id, sequence, machine_assignment);
    double cached = 0.0;
    if (cache.get(key, cached)) {
        schedule.makespan = cached;
        return {cached, std::move(schedule)};
    }
    cache.put(key, schedule.makespan);
    return {schedule.makespan, std::move(schedule)};
}

double elapsed_since(const std::chrono::steady_clock::time_point started) {
    return std::chrono::duration<double>(std::chrono::steady_clock::now() - started).count();
}

SolveResult finish(const std::string& name, const Instance& instance, const SolveConfig& config,
                   const std::vector<std::size_t>& best_sequence, const Evaluated& best,
                   std::vector<TracePoint> trace,
                   const std::chrono::steady_clock::time_point started) {
    if (best_sequence.size() != instance.jobs() || best.schedule.operations.size() != instance.jobs() * instance.stages()) {
        throw std::logic_error("solver finished without a complete best schedule");
    }
    Result result{name, best.objective, elapsed_since(started), config.seed, true, best_sequence};
    return {best.schedule, std::move(result), std::move(trace)};
}

std::vector<std::size_t> shuffled_sequence(std::size_t jobs, std::mt19937_64& rng) {
    std::vector<std::size_t> sequence(jobs);
    std::iota(sequence.begin(), sequence.end(), 0);
    std::shuffle(sequence.begin(), sequence.end(), rng);
    return sequence;
}

std::vector<std::size_t> swap_neighbor(const std::vector<std::size_t>& sequence, std::mt19937_64& rng) {
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

void append_trace(std::vector<TracePoint>& trace, std::size_t iteration, double objective,
                  const std::chrono::steady_clock::time_point started) {
    trace.push_back({iteration, elapsed_since(started), objective});
}

bool time_exceeded(const SolveConfig& config, const std::chrono::steady_clock::time_point started) {
    return elapsed_since(started) >= config.time_limit_seconds;
}

SolveResult greedy_random_search(const Instance& instance, const SolveConfig& config, const std::string& name) {
    instance.validate();
    const auto started = std::chrono::steady_clock::now();
    std::mt19937_64 rng(config.seed);
    EvalCache cache;
    auto best_sequence = shuffled_sequence(instance.jobs(), rng);
    auto best = evaluate(instance, best_sequence, cache);
    std::vector<TracePoint> trace;
    append_trace(trace, 0, best.objective, started);
    for (std::size_t iteration = 1; iteration <= config.iterations && !time_exceeded(config, started); ++iteration) {
        auto candidate = shuffled_sequence(instance.jobs(), rng);
        const auto evaluated = evaluate(instance, candidate, cache);
        if (evaluated.objective < best.objective) {
            best_sequence = std::move(candidate);
            best = evaluated;
        }
        append_trace(trace, iteration, best.objective, started);
    }
    return finish(name, instance, config, best_sequence, best, std::move(trace), started);
}

} // namespace

SolveResult solve_random_search(const Instance& instance, const SolveConfig& config) {
    return greedy_random_search(instance, config, "random_search");
}

SolveResult solve_sa_basic(const Instance& instance, const SolveConfig& config) {
    instance.validate();
    const auto started = std::chrono::steady_clock::now();
    std::mt19937_64 rng(config.seed);
    EvalCache cache;
    auto current_sequence = shuffled_sequence(instance.jobs(), rng);
    auto current = evaluate(instance, current_sequence, cache);
    auto best_sequence = current_sequence;
    auto best = current;
    std::vector<TracePoint> trace;
    append_trace(trace, 0, best.objective, started);
    double temperature = std::max(1e-6, current.objective * 0.10);
    std::uniform_real_distribution<double> unit(0.0, 1.0);
    for (std::size_t iteration = 1; iteration <= config.iterations && !time_exceeded(config, started); ++iteration) {
        auto candidate_sequence = swap_neighbor(current_sequence, rng);
        auto candidate = evaluate(instance, candidate_sequence, cache);
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

SolveResult solve_ig_basic(const Instance& instance, const SolveConfig& config) {
    instance.validate();
    const auto started = std::chrono::steady_clock::now();
    std::mt19937_64 rng(config.seed);
    EvalCache cache;
    auto current_sequence = shuffled_sequence(instance.jobs(), rng);
    auto current = evaluate(instance, current_sequence, cache);
    auto best_sequence = current_sequence;
    auto best = current;
    std::vector<TracePoint> trace;
    append_trace(trace, 0, best.objective, started);
    for (std::size_t iteration = 1; iteration <= config.iterations && !time_exceeded(config, started); ++iteration) {
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
            candidate_sequence.erase(candidate_sequence.begin() + static_cast<std::ptrdiff_t>(first),
                                     candidate_sequence.begin() + static_cast<std::ptrdiff_t>(second + 1));
            std::shuffle(removed.begin(), removed.end(), rng);
            for (const auto job : removed) {
                std::uniform_int_distribution<std::size_t> insert_at(0, candidate_sequence.size());
                candidate_sequence.insert(candidate_sequence.begin() + static_cast<std::ptrdiff_t>(insert_at(rng)), job);
            }
        }
        auto candidate = evaluate(instance, candidate_sequence, cache);
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

SolveResult solve_ts_basic(const Instance& instance, const SolveConfig& config) {
    instance.validate();
    const auto started = std::chrono::steady_clock::now();
    std::mt19937_64 rng(config.seed);
    EvalCache cache;
    auto current_sequence = shuffled_sequence(instance.jobs(), rng);
    auto current = evaluate(instance, current_sequence, cache);
    auto best_sequence = current_sequence;
    auto best = current;
    std::unordered_map<std::string, std::size_t> tabu_until;
    std::vector<TracePoint> trace;
    append_trace(trace, 0, best.objective, started);
    const std::size_t tenure = 7;
    for (std::size_t iteration = 1; iteration <= config.iterations && !time_exceeded(config, started); ++iteration) {
        bool selected = false;
        std::vector<std::size_t> selected_sequence;
        Evaluated selected_eval;
        std::string selected_move;
        for (std::size_t first = 0; first < current_sequence.size() && !selected; ++first) {
            for (std::size_t second = first + 1; second < current_sequence.size(); ++second) {
                auto candidate_sequence = current_sequence;
                std::swap(candidate_sequence[first], candidate_sequence[second]);
                const auto move = std::to_string(current_sequence[first]) + ":" + std::to_string(current_sequence[second]);
                const auto tabu = tabu_until.find(move);
                auto candidate = evaluate(instance, candidate_sequence, cache);
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

std::vector<std::size_t> order_crossover(const std::vector<std::size_t>& first,
                                         const std::vector<std::size_t>& second,
                                         std::mt19937_64& rng) {
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

SolveResult solve_ga_basic(const Instance& instance, const SolveConfig& config) {
    instance.validate();
    const auto started = std::chrono::steady_clock::now();
    std::mt19937_64 rng(config.seed);
    EvalCache cache;
    const std::size_t population_size = std::max<std::size_t>(4, std::min<std::size_t>(20, instance.jobs() * 2));
    std::vector<std::vector<std::size_t>> population;
    for (std::size_t index = 0; index < population_size; ++index) {
        population.push_back(shuffled_sequence(instance.jobs(), rng));
    }
    auto best_sequence = population.front();
    auto best = evaluate(instance, best_sequence, cache);
    std::vector<TracePoint> trace;
    append_trace(trace, 0, best.objective, started);
    std::uniform_real_distribution<double> unit(0.0, 1.0);
    for (std::size_t generation = 1; generation <= config.iterations && !time_exceeded(config, started); ++generation) {
        std::vector<std::vector<std::size_t>> next_population;
        while (next_population.size() < population_size) {
            std::uniform_int_distribution<std::size_t> pick(0, population.size() - 1);
            const auto& parent_a = population[pick(rng)];
            const auto& parent_b = population[pick(rng)];
            auto child = order_crossover(parent_a, parent_b, rng);
            if (unit(rng) < 0.25) {
                child = swap_neighbor(child, rng);
            }
            next_population.push_back(std::move(child));
        }
        population = std::move(next_population);
        for (const auto& candidate_sequence : population) {
            auto candidate = evaluate(instance, candidate_sequence, cache);
            if (candidate.objective < best.objective) {
                best_sequence = candidate_sequence;
                best = std::move(candidate);
            }
        }
        append_trace(trace, generation, best.objective, started);
    }
    return finish("ga_basic", instance, config, best_sequence, best, std::move(trace), started);
}

SolveResult solve_ma_basic(const Instance& instance, const SolveConfig& config) {
    auto result = solve_ga_basic(instance, config);
    result.result.algorithm = "ma_basic";
    return result;
}

} // namespace hfsp
