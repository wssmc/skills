"""禁忌搜索 (TS) 基础版 — src/metaheuristics/ts/ts_basic.py

最小可运行实现。
算法签名: solve_ts_basic(instance, time_limit, seed, **kwargs) -> (Schedule, trace_list, best_seq)
"""
from __future__ import annotations

import random
import time
from collections import deque

import sys
sys.path.insert(0, str(__import__("pathlib").Path(__file__).resolve().parent.parent.parent))
from core.domain import Instance, Schedule
from metaheuristics.initial.random_init import init_random, init_random_machine_assignment
from metaheuristics.decoding.list_decoder import decode
from metaheuristics.decoding.metrics import evaluate_schedule
from metaheuristics.decoding.eval_cache import EvalCache
from metaheuristics.neighborhood.operators import swap_move


def solve_ts_basic(instance: Instance, time_limit: float = 30.0,
                   seed: int | None = None, **kwargs) -> tuple[Schedule, list, dict]:
    """基础禁忌搜索。

    Args:
        instance: 算例数据
        time_limit: 时间限制（秒）
        seed: 随机种子

    Returns:
        (Schedule, trace_list, best_seq)
    """
    rng = random.Random(seed)
    t0 = time.time()

    # 计算缓存（FIFO，上限 500）
    cache = EvalCache(max_size=500)

    def evaluate(seq):
        key = tuple(seq)
        cached = cache.get(key)
        if cached is not None:
            return cached
        sched = decode(seq, machine_assign, instance)
        evaluate_schedule(instance, sched)
        cache.put(key, sched.objective)
        return sched.objective

    # 初始化
    job_seq = init_random(instance, seed)
    machine_assign = init_random_machine_assignment(instance, seed)
    current = decode(job_seq, machine_assign, instance)
    evaluate_schedule(instance, current)
    best = current
    best_seq = job_seq.copy()
    trace = [(0, 0.0, best.objective)]

    # 禁忌表
    tabu_list = deque(maxlen=min(20, max(instance.num_jobs // 2, 5)))
    tabu_set = set()

    iteration = 0
    while time.time() - t0 < time_limit:
        iteration += 1

        # 生成邻居（交换移动）
        best_neighbor = None
        best_neighbor_obj = float("inf")
        best_move = None

        # 随机采样邻居
        sample_size = min(instance.num_jobs * 2, 50)
        for _ in range(sample_size):
            i = rng.randint(0, len(job_seq) - 1)
            j = rng.randint(0, len(job_seq) - 1)
            if i == j:
                continue
            move = (min(i, j), max(i, j))
            new_seq = swap_move(job_seq, i, j)
            schedule = decode(new_seq, machine_assign, instance)

            # 藐视准则：如果比最优更好，即使禁忌也接受；否则跳过禁忌移动
            if schedule.objective < best.objective or move not in tabu_set:
                if schedule.objective < best_neighbor_obj:
                    best_neighbor_obj = schedule.objective
                    best_neighbor = new_seq
                    best_move = move

        if best_neighbor is None:
            continue

        # 更新禁忌表
        tabu_list.append(best_move)
        tabu_set = set(tabu_list)

        job_seq = best_neighbor
        current = decode(job_seq, machine_assign, instance)
        evaluate_schedule(instance, current)

        if current.objective < best.objective:
            best = current
            best_seq = job_seq.copy()

        trace.append((iteration, time.time() - t0, best.objective))

    return best, trace, {"job_sequence": best_seq, "machine_assignment": machine_assign}
