#pragma once

#include <cmath>
#include <cstddef>
#include <cstdint>
#include <limits>
#include <optional>
#include <stdexcept>
#include <string>
#include <vector>

namespace scheduling {

// Current reference problem model for the flow-shop family.
// A generated non-flow-shop project must replace this type with its own
// problem-specific data model instead of accumulating optional fields here.
struct FlowShopInstance {
    std::string id;
    std::uint64_t instance_seed{};
    std::vector<std::vector<double>> processing_times; // [job][stage]
    std::vector<std::size_t> machines_per_stage;

    std::size_t jobs() const noexcept { return processing_times.size(); }
    std::size_t stages() const noexcept { return machines_per_stage.size(); }

    void validate() const {
        if (id.empty()) {
            throw std::invalid_argument("instance id must not be empty");
        }
        if (processing_times.empty() || machines_per_stage.empty()) {
            throw std::invalid_argument("flow-shop instance must contain jobs and stages");
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
                if (!std::isfinite(value) || value <= 0.0) {
                    throw std::invalid_argument("processing times must be finite and positive");
                }
            }
        }
    }
};

struct Operation {
    std::size_t job_id{};
    std::size_t stage_id{};
    std::size_t machine_id{};
    double start{};
    double end{};
};

struct Schedule {
    std::vector<Operation> operations;
    double makespan{};
};

struct Result {
    std::string instance_id;
    std::string algorithm;
    double objective{std::numeric_limits<double>::infinity()};
    double runtime_seconds{};
    std::uint64_t instance_seed{};
    std::uint64_t solve_seed{};
    std::size_t round{};
    bool feasible{false};
    std::vector<std::size_t> best_sequence;
    std::string status{"UNKNOWN"};
    std::optional<double> best_bound;
    std::optional<double> relative_gap;
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

} // namespace scheduling
