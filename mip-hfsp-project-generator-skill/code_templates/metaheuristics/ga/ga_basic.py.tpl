"""遗传算法（GA）基础版。"""
from __future__ import annotations

import sys

sys.path.insert(0, str(__import__("pathlib").Path(__file__).resolve().parent.parent.parent))
from core.domain import Instance, Schedule
from metaheuristics.base_solver.base_solver import PopulationBasedSolver
from metaheuristics.neighborhood.operators import random_swap


class GASolver(PopulationBasedSolver):
    ALGO_NAME = "ga_basic"
    ALGO_SHORT = "GA"

    def __init__(self, config=None):
        super().__init__(config)
        self.pop_size = 30
        self.mutation_rate = 0.1
        self.elite_size = 2

    def _solve(self) -> None:
        self.population = self._init_population()
        best_sequence, best_assignment, best_obj = self.population[0]
        self.record_best(best_sequence, best_assignment)
        self.trace = [(0, 0.0, best_obj)]
        iteration = 0

        while self.elapsed() < self.time_limit:
            iteration += 1
            new_population = list(self.population[:self.elite_size])
            while len(new_population) < self.pop_size and self.elapsed() < self.time_limit:
                parent1 = self._tournament_select(3)
                parent2 = self._tournament_select(3)
                child = self._crossover_ox(parent1[0], parent2[0])
                if self.rng.random() < self.mutation_rate:
                    child = random_swap(child, self.rng)
                assignment = self._random_machine_assign()
                new_population.append((child, assignment, self.evaluate(child, assignment)))

            self.population = sorted(new_population, key=lambda item: item[2])
            candidate_sequence, candidate_assignment, candidate_obj = self.population[0]
            if candidate_obj < best_obj:
                best_sequence, best_assignment, best_obj = (
                    candidate_sequence,
                    candidate_assignment,
                    candidate_obj,
                )
                self.record_best(best_sequence, best_assignment)
            average = sum(item[2] for item in self.population) / len(self.population)
            self.trace.append((iteration, self.elapsed(), best_obj))
            self.log_iteration(
                iteration,
                f"avg={average:.2f} worst={self.population[-1][2]:.2f} pop={len(self.population)}",
            )

        self.log_done(iteration)


def solve_ga_basic(instance: Instance, time_limit: float = 30.0,
                   seed: int | None = None, **kwargs) -> tuple[Schedule, list, dict]:
    return GASolver().solve(instance, time_limit, seed, **kwargs)
