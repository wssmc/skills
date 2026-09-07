#pragma once

#include <cstddef>
#include <cstdint>
#include <limits>
#include <stdexcept>
#include <string>
#include <utility>
#include <vector>

namespace hfsp {

struct Operation {
    std::size_t job_id{};
    std::size_t stage_id{};
    std::size_t machine_id{};
    double start{};
    double end{};
};

struct Instance {
    std::string id;
    std::vector<std::vector<double>> processing_times; // [job][stage]
    std::vector<std::size_t> machines_per_stage;

    std::size_t jobs() const noexcept { return processing_times.size(); }
    std::size_t stages() const noexcept { return machines_per_stage.size(); }

    void validate() const {
        if (processing_times.empty() || machines_per_stage.empty()) {
            throw std::invalid_argument("HFSP instance must contain jobs and stages");
        }
        for (const auto machines : machines_per_stage) {
            if (machines == 0) {
                throw std::invalid_argument("each stage must have at least one machine");
            }
        }
        for (const auto& row : processing_times) {
            if (row.size() != stages()) {
                throw std::invalid_argument("processing-time matrix shape does not match stages");
            }
            for (const auto value : row) {
                if (!(value > 0.0) || value == std::numeric_limits<double>::infinity()) {
                    throw std::invalid_argument("processing times must be finite and positive");
                }
            }
        }
    }
};

struct Schedule {
    std::vector<Operation> operations;
    double makespan{0.0};
};

struct Result {
    std::string algorithm;
    double objective{std::numeric_limits<double>::infinity()};
    double runtime_seconds{0.0};
    std::uint64_t seed{0};
    bool feasible{false};
    std::vector<std::size_t> best_sequence;
};

struct TracePoint {
    std::size_t iteration{};
    double elapsed_seconds{};
    double objective{};
};

struct SolveResult {
    Schedule schedule;
    Result result;
    std::vector<TracePoint> trace;
};

} // namespace hfsp
