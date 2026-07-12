"""论文对比算法模板 — src/metaheuristics/baselines/

从文献复现的对比算法，每个算法一个文件，注册到 run_baselines.py 统一调度。
"""
from __future__ import annotations

import sys
sys.path.insert(0, str(__import__("pathlib").Path(__file__).resolve().parent.parent.parent))
from core.domain import Instance, Schedule, Result


def solve_baseline_template(instance: Instance, time_limit: float = 30.0,
                            seed: int | None = None, **kwargs) -> tuple[Schedule, list, dict]:
    """对比算法模板。

    复现文献中的算法，每个对比算法一个文件。
    算法签名统一: solve_xxx(instance, time_limit, seed, **kwargs) -> (Schedule, trace_list)

    Args:
        instance: 算例数据
        time_limit: 时间限制（秒）
        seed: 随机种子

    Returns:
        (Schedule, trace_list) 其中 trace_list = [(iteration, time, objective), ...]
    """
    import time
    import random
    rng = random.Random(seed)
    t0 = time.time()

    # 计算缓存（FIFO，上限 500）— 所有元启发式必须使用
    cache = EvalCache(max_size=500)

    from metaheuristics.initial.single.random_init import init_random, init_random_machine_assignment
    from metaheuristics.decoding.list_decoder import decode
    from metaheuristics.decoding.metrics import evaluate_schedule
from metaheuristics.decoding.eval_cache import EvalCache

    trace = []

    # 简单随机搜索作为模板
    job_seq = init_random(instance, seed)
    machine_assign = init_random_machine_assignment(instance, seed)
    schedule = decode(job_seq, machine_assign, instance)
    evaluate_schedule(instance, schedule)
    best = schedule
    best_seq = job_seq.copy()
    trace.append((0, time.time() - t0, best.objective))

    iteration = 0
    while time.time() - t0 < time_limit:
        iteration += 1
        new_seq = init_random(instance, rng.randint(0, 2**32))
        new_assign = init_random_machine_assignment(instance, rng.randint(0, 2**32))
        new_schedule = decode(new_seq, new_assign, instance)
        evaluate_schedule(instance, new_schedule)

        if new_schedule.objective < best.objective:
            best = new_schedule
            best_seq = new_seq

        trace.append((iteration, time.time() - t0, best.objective))

    return best, trace, {"job_sequence": best_seq, "machine_assignment": machine_assign}
