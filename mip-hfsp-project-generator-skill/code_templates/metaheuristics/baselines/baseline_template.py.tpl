"""可运行的随机搜索 baseline。文献 baseline 应各自使用独立文件实现。"""
from __future__ import annotations

import random
import sys
import time

sys.path.insert(0, str(__import__("pathlib").Path(__file__).resolve().parent.parent.parent))
from core.domain import Instance, Schedule
from metaheuristics.decoding.eval_cache import EvalCache, make_eval_key
from metaheuristics.decoding.list_decoder import decode
from metaheuristics.decoding.metrics import evaluate_schedule
from metaheuristics.encoding.sequence_encoding import serialize_machine_assignment
from metaheuristics.initial.single.random_init import init_random, init_random_machine_assignment


def solve_random_search(instance: Instance, time_limit: float = 30.0,
                        seed: int | None = None, **kwargs) -> tuple[Schedule, list, dict]:
    supported_kwargs = {"cache", "init_fn", "verbose"}
    unknown_kwargs = set(kwargs) - supported_kwargs
    if unknown_kwargs:
        raise TypeError(f"Unsupported random_search options: {sorted(unknown_kwargs)}")
    if time_limit <= 0:
        raise ValueError("time_limit must be positive")
    errors = instance.validate()
    if errors:
        raise ValueError(f"Invalid instance: {errors}")
    rng = random.Random(seed)
    injected_cache = kwargs.get("cache")
    if injected_cache is not None:
        if not isinstance(injected_cache, EvalCache):
            raise TypeError("cache must be an EvalCache")
        if injected_cache.max_size != EvalCache.MAX_SIZE or len(injected_cache) != 0:
            raise ValueError("injected cache must be an empty EvalCache(max_size=500)")
    cache = injected_cache if injected_cache is not None else EvalCache(max_size=500)
    init_fn = kwargs.get("init_fn") or init_random
    started = time.perf_counter()

    def evaluate(sequence: list[int], assignment: dict) -> tuple[float, Schedule | None]:
        key = make_eval_key(instance, sequence, assignment)
        cached = cache.get(key)
        if cached is not None:
            return cached, None
        schedule = decode(sequence, assignment, instance)
        evaluate_schedule(instance, schedule)
        cache.put(key, schedule.objective)
        return schedule.objective, schedule

    best_sequence = init_fn(instance, seed=seed)
    best_assignment = init_random_machine_assignment(instance, seed)
    best_obj, best_schedule = evaluate(best_sequence, best_assignment)
    if best_schedule is None:
        raise RuntimeError("isolated cache unexpectedly contained the initial encoding")
    trace = [(0, time.perf_counter() - started, best_obj)]
    iteration = 0

    while time.perf_counter() - started < time_limit:
        iteration += 1
        sequence = init_random(instance, rng.randint(0, 2**32 - 1))
        assignment = init_random_machine_assignment(instance, rng.randint(0, 2**32 - 1))
        objective, schedule = evaluate(sequence, assignment)
        if objective < best_obj:
            best_sequence = sequence
            best_assignment = assignment
            best_obj = objective
            best_schedule = schedule or decode(sequence, assignment, instance)
            evaluate_schedule(instance, best_schedule)
        trace.append((iteration, time.perf_counter() - started, best_obj))

    return best_schedule, trace, {
        "job_sequence": list(best_sequence),
        "machine_assignment": serialize_machine_assignment(best_assignment),
    }
