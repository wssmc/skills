"""模拟退火（SA）基础版。"""
from __future__ import annotations

import math
import sys

sys.path.insert(0, str(__import__("pathlib").Path(__file__).resolve().parent.parent.parent))
from core.domain import Instance, Schedule
from metaheuristics.base_solver.base_solver import SingleSolutionSolver
from metaheuristics.neighborhood.operators import random_insert, random_swap


class SASolver(SingleSolutionSolver):
    ALGO_NAME = "sa_basic"
    ALGO_SHORT = "SA"

    def __init__(self, initial_temperature_multiplier: float = 10.0,
                 cooling_rate: float = 0.995, minimum_temperature: float = 0.01):
        if initial_temperature_multiplier <= 0:
            raise ValueError("initial_temperature_multiplier must be positive")
        if not 0 < cooling_rate < 1:
            raise ValueError("cooling_rate must be between 0 and 1")
        if minimum_temperature <= 0:
            raise ValueError("minimum_temperature must be positive")
        super().__init__()
        self.initial_temperature_multiplier = float(initial_temperature_multiplier)
        self.cooling_rate = float(cooling_rate)
        self.minimum_temperature = float(minimum_temperature)

    def _solve(self) -> None:
        current_seq, assignment = self._init_single()
        self.machine_assign = assignment
        current_obj = self.evaluate(current_seq, assignment)
        best_obj = current_obj
        self.record_best(current_seq, assignment)
        self.trace = [(0, 0.0, best_obj)]

        max_processing_time = max(
            self.instance.processing_times[j][s]
            for j in range(self.instance.num_jobs)
            for s in range(self.instance.num_stages)
        )
        temperature = max(
            max_processing_time * self.initial_temperature_multiplier,
            self.minimum_temperature,
        )
        iteration = 0

        while self.elapsed() < self.time_limit:
            iteration += 1
            candidate = (
                random_swap(current_seq, self.rng)
                if self.rng.random() < 0.5
                else random_insert(current_seq, self.rng)
            )
            candidate_obj = self.evaluate(candidate, assignment)
            delta = candidate_obj - current_obj
            accepted = delta < 0 or self.rng.random() < math.exp(-delta / max(temperature, 1e-12))
            if accepted:
                current_seq = candidate
                current_obj = candidate_obj
                if current_obj < best_obj:
                    best_obj = current_obj
                    self.record_best(current_seq, assignment)

            self.trace.append((iteration, self.elapsed(), best_obj))
            self.log_iteration(
                iteration,
                f"cur={current_obj:.2f} accepted={int(accepted)} T={temperature:.4f}",
            )
            temperature = max(self.minimum_temperature, temperature * self.cooling_rate)

        self.log_done(iteration)


def solve_sa_basic(instance: Instance, time_limit: float = 30.0,
                   seed: int | None = None, **kwargs) -> tuple[Schedule, list, dict]:
    solver = SASolver(
        initial_temperature_multiplier=kwargs.pop("initial_temperature_multiplier", 10.0),
        cooling_rate=kwargs.pop("cooling_rate", 0.995),
        minimum_temperature=kwargs.pop("minimum_temperature", 0.01),
    )
    return solver.solve(instance, time_limit, seed, **kwargs)
