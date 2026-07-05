"""模拟退火 (SA) 基础版 — src/metaheuristics/sa/sa_basic.py

最小可运行实现，验证基本框架正确性。
算法签名: solve_sa_basic(instance, time_limit, seed, **kwargs) -> (Schedule, trace_list, best_seq)
"""
from __future__ import annotations

import math
import random
import time

import sys
sys.path.insert(0, str(__import__("pathlib").Path(__file__).resolve().parent.parent.parent))
from core.domain import Instance, Schedule
from metaheuristics.initial.random_init import init_random, init_random_machine_assignment
from metaheuristics.decoding.list_decoder import decode
from metaheuristics.decoding.metrics import evaluate_schedule
from metaheuristics.neighborhood.operators import random_swap, random_insert


def solve_sa_basic(instance: Instance, time_limit: float = 30.0,
                   seed: int | None = None, **kwargs) -> tuple[Schedule, list, dict]:
    """基础模拟退火。

    Args:
        instance: 算例数据
        time_limit: 时间限制（秒）
        seed: 随机种子

    Returns:
        (Schedule, trace_list, best_seq)
    """
    rng = random.Random(seed)
    t0 = time.time()

    # 初始化
    job_seq = init_random(instance, seed)
    machine_assign = init_random_machine_assignment(instance, seed)
    current = decode(job_seq, machine_assign, instance)
    evaluate_schedule(instance, current)
    best = current
    best_seq = job_seq.copy()
    trace = [(0, 0.0, best.objective)]

    # SA 参数
    initial_temp = max(op.processing_time for op in current.operations) * 10
    cooling_rate = 0.995
    min_temp = 0.01
    temp = initial_temp

    iteration = 0
    while time.time() - t0 < time_limit and temp > min_temp:
        iteration += 1

        # 生成邻居
        if rng.random() < 0.5:
            new_seq = random_swap(job_seq, rng)
        else:
            new_seq = random_insert(job_seq, rng)

        new_schedule = decode(new_seq, machine_assign, instance)
        evaluate_schedule(instance, new_schedule)

        # 接受准则
        delta = new_schedule.objective - current.objective
        if delta < 0 or rng.random() < math.exp(-delta / max(temp, 1e-10)):
            job_seq = new_seq
            current = new_schedule
            if current.objective < best.objective:
                best = current
                best_seq = job_seq.copy()

        trace.append((iteration, time.time() - t0, best.objective))
        temp *= cooling_rate

    return best, trace, {"job_sequence": best_seq, "machine_assignment": machine_assign}
