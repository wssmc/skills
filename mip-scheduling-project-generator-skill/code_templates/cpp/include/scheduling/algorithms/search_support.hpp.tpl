#pragma once

#include "scheduling/algorithms/algorithms.hpp"
#include "scheduling/evaluation/evaluator.hpp"
#include <chrono>
#include <random>

namespace scheduling::detail {

double elapsed_since(const std::chrono::steady_clock::time_point started);

SolveResult finish(const std::string &name, const FlowShopInstance &instance,
                   const SolveConfig &config, const std::vector<std::size_t> &best_sequence,
                   const Evaluated &best, std::vector<TracePoint> trace,
                   const std::chrono::steady_clock::time_point started);

std::vector<std::size_t> shuffled_sequence(std::size_t jobs, std::mt19937_64 &rng);

std::vector<std::size_t> swap_neighbor(const std::vector<std::size_t> &sequence,
                                       std::mt19937_64 &rng);

void append_trace(std::vector<TracePoint> &trace, std::size_t iteration, double objective,
                  const std::chrono::steady_clock::time_point started);

bool time_exceeded(const SolveConfig &config, const std::chrono::steady_clock::time_point started);

std::vector<std::size_t> order_crossover(const std::vector<std::size_t> &first,
                                         const std::vector<std::size_t> &second,
                                         std::mt19937_64 &rng);

} // namespace scheduling::detail
