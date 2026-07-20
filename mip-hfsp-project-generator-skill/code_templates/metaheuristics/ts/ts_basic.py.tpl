"""禁忌搜索（TS）基础版。"""
from __future__ import annotations

import sys
from collections import deque

sys.path.insert(0, str(__import__("pathlib").Path(__file__).resolve().parent.parent.parent))
from core.domain import Instance, Schedule
from metaheuristics.base_solver.base_solver import SingleSolutionSolver
from metaheuristics.neighborhood.operators import swap_move


class TSSolver(SingleSolutionSolver):
    ALGO_NAME = "ts_basic"
    ALGO_SHORT = "TS"

    def _solve(self) -> None:
        current_seq, assignment = self._init_single()
        self.machine_assign = assignment
        current_obj = self.evaluate(current_seq, assignment)
        best_obj = current_obj
        self.record_best(current_seq, assignment)
        self.trace = [(0, 0.0, best_obj)]
        if len(current_seq) < 2:
            self.log_done(0)
            return

        tabu_list = deque(maxlen=min(20, max(self.instance.num_jobs // 2, 5)))
        tabu_set = set()
        iteration = 0

        while self.elapsed() < self.time_limit:
            iteration += 1
            best_neighbor = None
            best_neighbor_obj = float("inf")
            best_move = None
            sample_size = min(self.instance.num_jobs * 2, 50)

            for _ in range(sample_size):
                i, j = self.rng.sample(range(len(current_seq)), 2)
                move = tuple(sorted((current_seq[i], current_seq[j])))
                candidate = swap_move(current_seq, i, j)
                objective = self.evaluate(candidate, assignment)
                if (objective < best_obj or move not in tabu_set) and objective < best_neighbor_obj:
                    best_neighbor = candidate
                    best_neighbor_obj = objective
                    best_move = move

            if best_neighbor is None:
                break
            if len(tabu_list) == tabu_list.maxlen:
                expired = tabu_list[0]
                tabu_set.discard(expired)
            tabu_list.append(best_move)
            tabu_set.add(best_move)
            current_seq = best_neighbor
            current_obj = best_neighbor_obj

            if current_obj < best_obj:
                best_obj = current_obj
                self.record_best(current_seq, assignment)
            self.trace.append((iteration, self.elapsed(), best_obj))
            self.log_iteration(iteration, f"cur={current_obj:.2f} tabu_size={len(tabu_list)}")

        self.log_done(iteration)


def solve_ts_basic(instance: Instance, time_limit: float = 30.0,
                   seed: int | None = None, **kwargs) -> tuple[Schedule, list, dict]:
    return TSSolver().solve(instance, time_limit, seed, **kwargs)
