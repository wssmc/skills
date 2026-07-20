"""迭代贪心（IG）基础版。"""
from __future__ import annotations

import sys

sys.path.insert(0, str(__import__("pathlib").Path(__file__).resolve().parent.parent.parent))
from core.domain import Instance, Schedule
from metaheuristics.base_solver.base_solver import SingleSolutionSolver
from metaheuristics.initial.single.dispatching import init_spt


class IGSolver(SingleSolutionSolver):
    ALGO_NAME = "ig_basic"
    ALGO_SHORT = "IG"

    def _default_init(self) -> list[int]:
        return init_spt(self.instance)

    def _solve(self) -> None:
        current_seq, assignment = self._init_single()
        self.machine_assign = assignment
        current_obj = self.evaluate(current_seq, assignment)
        best_obj = current_obj
        self.record_best(current_seq, assignment)
        self.trace = [(0, 0.0, best_obj)]
        destruction_size = max(1, self.instance.num_jobs // 10)
        iteration = 0

        while self.elapsed() < self.time_limit:
            iteration += 1
            partial = current_seq.copy()
            removed = []
            for _ in range(min(destruction_size, len(partial))):
                removed.append(partial.pop(self.rng.randrange(len(partial))))
            self.rng.shuffle(removed)

            for job in removed:
                best_trial = None
                best_trial_obj = float("inf")
                for position in range(len(partial) + 1):
                    trial = partial[:position] + [job] + partial[position:]
                    objective = self.evaluate(trial, assignment)
                    if objective < best_trial_obj:
                        best_trial = trial
                        best_trial_obj = objective
                partial = best_trial

            candidate_obj = self.evaluate(partial, assignment)
            accepted = candidate_obj <= current_obj
            if accepted:
                current_seq = partial
                current_obj = candidate_obj
            if candidate_obj < best_obj:
                best_obj = candidate_obj
                self.record_best(partial, assignment)

            self.trace.append((iteration, self.elapsed(), best_obj))
            self.log_iteration(
                iteration,
                f"cur={current_obj:.2f} d={destruction_size} accepted={int(accepted)}",
            )

        self.log_done(iteration)


def solve_ig_basic(instance: Instance, time_limit: float = 30.0,
                   seed: int | None = None, **kwargs) -> tuple[Schedule, list, dict]:
    return IGSolver().solve(instance, time_limit, seed, **kwargs)
