"""五个基础元启发式共用的求解生命周期与评估缓存。"""
from __future__ import annotations

import random
import time
from abc import ABC, abstractmethod
from dataclasses import dataclass
from typing import Callable

from core.domain import Instance, Schedule
from metaheuristics.decoding.eval_cache import EvalCache, make_eval_key
from metaheuristics.decoding.list_decoder import decode
from metaheuristics.decoding.metrics import evaluate_schedule
from metaheuristics.encoding.sequence_encoding import serialize_machine_assignment


@dataclass(frozen=True)
class SolverConfig:
    eval_cache_max_size: int = 500
    verbose: int = 1
    print_interval: int = 10


class BaseSolver(ABC):
    ALGO_NAME = ""
    ALGO_SHORT = ""

    def __init__(self, config: SolverConfig | None = None):
        self.config = config or SolverConfig()
        self._reset()

    def _reset(self) -> None:
        self.instance: Instance | None = None
        self.rng: random.Random | None = None
        self.seed: int | None = None
        self._t0 = 0.0
        self.time_limit = 0.0
        self.cache: EvalCache | None = None
        self.init_fn: Callable | None = None
        self.population_generator: Callable | None = None
        self.machine_assign: dict | None = None
        self.best_schedule: Schedule | None = None
        self.best_seq_data: dict | None = None
        self.trace: list = []
        self.verbose = self.config.verbose
        self.print_interval = self.config.print_interval

    def solve(self, instance: Instance, time_limit: float, seed: int | None = None,
              **kwargs) -> tuple[Schedule, list, dict]:
        self._reset()
        supported_kwargs = {
            "cache", "init_fn", "population_generator", "verbose", "print_interval"
        }
        unknown_kwargs = set(kwargs) - supported_kwargs
        if unknown_kwargs:
            raise TypeError(f"Unsupported solver options: {sorted(unknown_kwargs)}")
        errors = instance.validate()
        if errors:
            raise ValueError(f"Invalid instance: {errors}")
        if time_limit <= 0:
            raise ValueError("time_limit must be positive")
        self.instance = instance
        self.seed = seed
        self.rng = random.Random(seed)
        self._t0 = time.perf_counter()
        self.time_limit = float(time_limit)
        injected_cache = kwargs.get("cache")
        if injected_cache is not None:
            if not isinstance(injected_cache, EvalCache):
                raise TypeError("cache must be an EvalCache")
            if injected_cache.max_size != EvalCache.MAX_SIZE or len(injected_cache) != 0:
                raise ValueError("injected cache must be an empty EvalCache(max_size=500)")
        self.cache = (
            injected_cache
            if injected_cache is not None
            else EvalCache(self.config.eval_cache_max_size)
        )
        self.init_fn = kwargs.get("init_fn")
        self.population_generator = kwargs.get("population_generator")
        self.verbose = int(kwargs.get("verbose", self.config.verbose))
        self.print_interval = max(1, int(kwargs.get("print_interval", self.config.print_interval)))
        self.log_start()
        self._solve()
        if self.best_schedule is None or self.best_seq_data is None:
            raise RuntimeError(f"{self.ALGO_NAME} did not produce a best solution")
        if not self.trace:
            raise RuntimeError(f"{self.ALGO_NAME} did not record a trace")
        return self.best_schedule, self.trace, self.best_seq_data

    @abstractmethod
    def _solve(self) -> None:
        raise NotImplementedError

    def elapsed(self) -> float:
        return time.perf_counter() - self._t0

    def evaluate(self, seq: list[int], assignment: dict) -> float:
        key = make_eval_key(self.instance, seq, assignment)
        cached = self.cache.get(key)
        if cached is not None:
            return cached
        schedule = decode(seq, assignment, self.instance)
        evaluate_schedule(self.instance, schedule)
        self.cache.put(key, schedule.objective)
        return schedule.objective

    def decode_and_evaluate(self, seq: list[int], assignment: dict) -> Schedule:
        schedule = decode(seq, assignment, self.instance)
        evaluate_schedule(self.instance, schedule)
        return schedule

    def record_best(self, seq: list[int], assignment: dict, schedule: Schedule | None = None) -> None:
        self.best_schedule = schedule or self.decode_and_evaluate(seq, assignment)
        self.best_seq_data = {
            "job_sequence": list(seq),
            "machine_assignment": serialize_machine_assignment(assignment),
        }

    def log_start(self) -> None:
        if self.verbose >= 1:
            print(
                f"[{self.ALGO_SHORT}] instance={self.instance.name} algo={self.ALGO_NAME} "
                f"time_limit={self.time_limit}s seed={self.seed}"
            )

    def log_done(self, iterations: int) -> None:
        if self.verbose >= 1:
            print(
                f"[{self.ALGO_SHORT}] Done | best={self.best_schedule.objective:.2f} | "
                f"runtime={self.elapsed():.2f}s | iterations={iterations}"
            )

    def log_iteration(self, iteration: int, extra: str = "") -> None:
        if self.verbose < 2 or iteration % self.print_interval != 0:
            return
        line = (
            f"[{self.ALGO_SHORT}] it={iteration:6d} time={self.elapsed():.1f}s "
            f"best={self.best_schedule.objective:.2f}"
        )
        print(f"{line} {extra}".rstrip())

    def __call__(self, instance: Instance, time_limit: float, seed: int | None = None,
                 **kwargs) -> tuple[Schedule, list, dict]:
        return self.solve(instance, time_limit, seed, **kwargs)


class SingleSolutionSolver(BaseSolver):
    def _default_init(self) -> list[int]:
        from metaheuristics.initial.single.random_init import init_random
        return init_random(self.instance, self.rng.randint(0, 2**32 - 1))

    def _default_machine_assign(self) -> dict:
        from metaheuristics.initial.single.random_init import init_random_machine_assignment
        return init_random_machine_assignment(self.instance, self.rng.randint(0, 2**32 - 1))

    def _init_single(self) -> tuple[list[int], dict]:
        sequence = (
            self.init_fn(self.instance, seed=self.rng.randint(0, 2**32 - 1))
            if self.init_fn is not None
            else self._default_init()
        )
        return sequence, self._default_machine_assign()


class PopulationBasedSolver(BaseSolver):
    pop_size: int

    def _default_population_generator(self) -> list[list[int]]:
        from metaheuristics.initial.population.random_pop import generate_random_population
        return generate_random_population(
            self.instance, self.pop_size, seed=self.rng.randint(0, 2**32 - 1)
        )

    def _init_population(self) -> list[tuple[list, dict, float]]:
        if self.population_generator is None:
            sequences = self._default_population_generator()
        else:
            sequences = self.population_generator(
                self.instance, self.pop_size, seed=self.rng.randint(0, 2**32 - 1)
            )
        population = []
        for sequence in sequences:
            assignment = self._random_machine_assign()
            population.append((sequence, assignment, self.evaluate(sequence, assignment)))
        return sorted(population, key=lambda item: item[2])

    def _random_machine_assign(self) -> dict:
        from metaheuristics.initial.single.random_init import init_random_machine_assignment
        return init_random_machine_assignment(self.instance, self.rng.randint(0, 2**32 - 1))

    def _crossover_ox(self, parent1: list[int], parent2: list[int]) -> list[int]:
        if len(parent1) < 2:
            return list(parent1)
        start, end = sorted(self.rng.sample(range(len(parent1)), 2))
        child = [None] * len(parent1)
        child[start:end] = parent1[start:end]
        remaining = [job for job in parent2 if job not in child[start:end]]
        iterator = iter(remaining)
        return [next(iterator) if job is None else job for job in child]

    def _tournament_select(self, k: int = 3) -> tuple[list, dict, float]:
        candidates = self.rng.sample(self.population, min(k, len(self.population)))
        return min(candidates, key=lambda item: item[2])
