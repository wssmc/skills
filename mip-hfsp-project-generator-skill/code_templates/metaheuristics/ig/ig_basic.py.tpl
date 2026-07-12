"""迭代贪心 (IG) 基础版 — src/metaheuristics/ig/ig_basic.py

最小可运行实现。
算法签名: solve_ig_basic(instance, time_limit, seed, **kwargs) -> (Schedule, trace_list, best_seq)
"""
from __future__ import annotations

import random
import time

import sys
sys.path.insert(0, str(__import__("pathlib").Path(__file__).resolve().parent.parent.parent))
from core.domain import Instance, Schedule
from metaheuristics.initial.single.random_init import init_random, init_random_machine_assignment
from metaheuristics.initial.single.dispatching import init_spt
from metaheuristics.decoding.list_decoder import decode
from metaheuristics.decoding.metrics import evaluate_schedule
from metaheuristics.decoding.eval_cache import EvalCache


def solve_ig_basic(instance: Instance, time_limit: float = 30.0,
                   seed: int | None = None, **kwargs) -> tuple[Schedule, list, dict]:
    """基础迭代贪心。

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
    # 计算缓存：优先使用外部注入（批量对比一致性），否则新建
    cache = kwargs.get("cache") or EvalCache(max_size=500)
    # 初始化函数：优先使用外部注入的统一初始化，否则用算法默认初始化
    init_fn = kwargs.get("init_fn")

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
    job_seq = init_spt(instance)
    machine_assign = init_random_machine_assignment(instance, seed)
    current = decode(job_seq, machine_assign, instance)
    evaluate_schedule(instance, current)
    best = current
    best_seq = job_seq.copy()
    trace = [(0, 0.0, best.objective)]

    d = max(1, instance.num_jobs // 10)  # 破坏大小

    iteration = 0
    while time.time() - t0 < time_limit:
        iteration += 1

        # 破坏：随机移除 d 个作业
        destroyed = best_seq.copy()
        removed = []
        for _ in range(min(d, len(destroyed))):
            idx = rng.randint(0, len(destroyed) - 1)
            removed.append(destroyed.pop(idx))

        # 修复：将移除的作业逐一插入最佳位置
        rng.shuffle(removed)
        for job in removed:
            best_pos = 0
            best_obj = float("inf")
            for pos in range(len(destroyed) + 1):
                trial = destroyed[:pos] + [job] + destroyed[pos:]
                schedule = decode(trial, machine_assign, instance)
                if schedule.objective < best_obj:
                    best_obj = schedule.objective
                    best_pos = pos
            destroyed = destroyed[:best_pos] + [job] + destroyed[best_pos:]

        # 评估
        new_schedule = decode(destroyed, machine_assign, instance)
        evaluate_schedule(instance, new_schedule)

        # 接受准则
        if new_schedule.objective < best.objective:
            best = new_schedule
            best_seq = destroyed

        trace.append((iteration, time.time() - t0, best.objective))

    return best, trace, {"job_sequence": best_seq, "machine_assignment": machine_assign}
