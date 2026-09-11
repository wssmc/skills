#include "scheduling/registry.hpp"

#include <cassert>
#include <cmath>
#include <iostream>

int main() {
    scheduling::FlowShopInstance instance{
        "smoke",
        101,
        {{2.0, 3.0}, {1.0, 2.0}, {3.0, 1.0}},
        {2, 2},
    };
    instance.validate();

    scheduling::FlowShopInstance cross_stage{"cross_stage", 102, {{1.0, 2.0}}, {1, 1}};
    const auto cross =
        scheduling::solve_random_search(cross_stage, scheduling::SolveConfig{0.5, 11, 1, 4});
    assert(std::abs(cross.result.objective - 3.0) < 1e-9);

    const auto &registry = scheduling::algorithm_registry();
    assert(registry.size() == 6);
    for (const auto &[name, solver] : registry) {
        std::cerr << "running " << name << '\n';
        const scheduling::SolveConfig config{0.5, 7001, 1, 20};
        const auto first = solver(instance, config);
        const auto replay = solver(instance, config);
        assert(first.result.algorithm == name);
        assert(first.result.instance_seed == 101);
        assert(first.result.solve_seed == 7001);
        assert(first.result.round == 1);
        assert(first.result.feasible);
        assert(std::isfinite(first.result.objective));
        assert(first.result.best_sequence == replay.result.best_sequence);
        assert(std::abs(first.result.objective - replay.result.objective) < 1e-9);
        assert(first.result.best_sequence.size() == instance.jobs());
        assert(!first.trace.empty());
    }
    return 0;
}
