"""模因算法（MA）基础版。"""
from __future__ import annotations

import sys

sys.path.insert(0, str(__import__("pathlib").Path(__file__).resolve().parent.parent.parent))
from core.domain import Instance, Schedule
from metaheuristics.base_solver.base_solver import PopulationBasedSolver
from metaheuristics.neighborhood.operators import random_swap


class MASolver(PopulationBasedSolver):
    ALGO_NAME = "ma_basic"
    ALGO_SHORT = "MA"

    def __init__(self, config=None):
        super().__init__(config)
        self.pop_size = 20
        self.mutation_rate = 0.1
        self.local_search_iters = 10

    def _local_search(self, sequence: list[int], assignment: dict) -> tuple[list[int], float]:
        best = list(sequence)
        best_obj = self.evaluate(best, assignment)
        for _ in range(self.local_search_iters):
            candidate = random_swap(best, self.rng)
            candidate_obj = self.evaluate(candidate, assignment)
            if candidate_obj < best_obj:
                best = candidate
                best_obj = candidate_obj
        return best, best_obj

    def _solve(self) -> None:
        self.population = self._init_population()
        best_sequence, best_assignment, best_obj = self.population[0]
        self.record_best(best_sequence, best_assignment)
        self.trace = [(0, 0.0, best_obj)]
        iteration = 0

        while self.elapsed() < self.time_limit:
            iteration += 1
            parent1 = self._tournament_select(4)
            parent2 = self._tournament_select(4)
            child = self._crossover_ox(parent1[0], parent2[0])
            if self.rng.random() < self.mutation_rate:
                child = random_swap(child, self.rng)
            assignment = self._random_machine_assign()
            child, child_obj = self._local_search(child, assignment)

            worst_index = max(range(len(self.population)), key=lambda i: self.population[i][2])
            if child_obj < self.population[worst_index][2]:
                self.population[worst_index] = (child, assignment, child_obj)
            self.population.sort(key=lambda item: item[2])
            candidate_sequence, candidate_assignment, candidate_obj = self.population[0]
            if candidate_obj < best_obj:
                best_sequence, best_assignment, best_obj = (
                    candidate_sequence,
                    candidate_assignment,
                    candidate_obj,
                )
                self.record_best(best_sequence, best_assignment)
            self.trace.append((iteration, self.elapsed(), best_obj))
            self.log_iteration(iteration, f"pop={len(self.population)}")

        self.log_done(iteration)


def solve_ma_basic(instance: Instance, time_limit: float = 30.0,
                   seed: int | None = None, **kwargs) -> tuple[Schedule, list, dict]:
    return MASolver().solve(instance, time_limit, seed, **kwargs)
