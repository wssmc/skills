#include "hfsp/registry.hpp"

#include <cassert>
#include <cmath>
#include <iostream>

int main() {
    hfsp::Instance instance{
        "smoke",
        {{2.0, 3.0}, {1.0, 2.0}, {3.0, 1.0}},
        {2, 2},
    };
    instance.validate();
    hfsp::Instance cross_stage{"cross_stage", {{1.0, 2.0}}, {1, 1}};
    const auto cross_stage_result = hfsp::solve_random_search(cross_stage, hfsp::SolveConfig{0.5, 11, 4});
    assert(std::abs(cross_stage_result.result.objective - 3.0) < 1e-9);
    const auto& registry = hfsp::algorithm_registry();
    assert(registry.size() == 6);
    for (const auto& [name, solver] : registry) {
        std::cerr << "running " << name << '\n';
        const auto result = solver(instance, hfsp::SolveConfig{0.5, 7, 20});
        assert(result.result.algorithm == name);
        assert(result.result.feasible);
        assert(std::isfinite(result.result.objective));
        assert(result.result.best_sequence.size() == instance.jobs());
        assert(!result.trace.empty());
    }
    return 0;
}
