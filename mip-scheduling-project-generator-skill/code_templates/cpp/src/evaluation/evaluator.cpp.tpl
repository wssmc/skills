#include "scheduling/evaluation/evaluator.hpp"

#include <algorithm>
#include <stdexcept>
#include <utility>

namespace scheduling {

Evaluated evaluate(const FlowShopInstance &instance, const std::vector<std::size_t> &sequence) {
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
    for (const auto job : sequence) {
        for (std::size_t stage = 0; stage < instance.stages(); ++stage) {
            const auto machine = static_cast<std::size_t>(
                std::min_element(machine_ready[stage].begin(), machine_ready[stage].end()) -
                machine_ready[stage].begin());
            const auto start = std::max(job_ready[job], machine_ready[stage][machine]);
            const auto end = start + instance.processing_times[job][stage];
            schedule.operations.push_back({job, stage, machine, start, end});
            job_ready[job] = end;
            machine_ready[stage][machine] = end;
            schedule.makespan = std::max(schedule.makespan, end);
        }
    }

    return {schedule.makespan, std::move(schedule)};
}

} // namespace scheduling
