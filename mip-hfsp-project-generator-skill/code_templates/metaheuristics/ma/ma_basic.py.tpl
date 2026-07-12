"""模因算法 (MA) 基础版 — src/metaheuristics/ma/ma_basic.py

最小可运行实现。
算法签名: solve_ma_basic(instance, time_limit, seed, **kwargs) -> (Schedule, trace_list, best_seq)
"""
from __future__ import annotations

import random
import time

import sys
sys.path.insert(0, str(__import__("pathlib").Path(__file__).resolve().parent.parent.parent))
from core.domain import Instance, Schedule
from metaheuristics.initial.single.random_init import init_random_machine_assignment
from metaheuristics.initial.population.random_pop import generate_random_population
from metaheuristics.decoding.list_decoder import decode
from metaheuristics.decoding.metrics import evaluate_schedule
from metaheuristics.decoding.eval_cache import EvalCache
from metaheuristics.neighborhood.operators import random_swap


def solve_ma_basic(instance: Instance, time_limit: float = 30.0,
                   seed: int | None = None, **kwargs) -> tuple[Schedule, list, dict]:
    """基础模因算法（GA + 局部搜索）。

    Args:
        instance: 算例数据
        time_limit: 时间限制（秒）
        seed: 随机种子

    Returns:
        (Schedule, trace_list, best_seq)
    """
    rng = random.Random(seed)
    t0 = time.time()

    # 计算缓存（FIFO，上限 500，MA 种群评估会有大量重复编码）
    # 计算缓存：优先使用外部注入（批量对比一致性），否则新建
    cache = kwargs.get("cache") or EvalCache(max_size=500)
    # 初始化函数：优先使用外部注入的统一初始化，否则用算法默认初始化
    init_fn = kwargs.get("init_fn")

    def evaluate_seq(seq, assign):
        key = tuple(seq)
        cached = cache.get(key)
        if cached is not None:
            return cached
        sched = decode(seq, assign, instance)
        evaluate_schedule(instance, sched)
        cache.put(key, sched.objective)
        return sched.objective

    pop_size = 20
    mutation_rate = 0.1
    local_search_iters = 10

    # 初始化种群（使用种群生成器，保证个体互不相同）
    # 优先使用外部注入的 population_generator（用于批量对比一致性）
    pop_gen = kwargs.get("population_generator") or generate_random_population
    initial_seqs = pop_gen(instance, pop_size, seed=seed, ensure_diversity=True) \
        if pop_gen is generate_random_population else pop_gen(instance, pop_size, seed=seed)
    population = []
    for seq in initial_seqs:
        assign = init_random_machine_assignment(instance, rng.randint(0, 2**32))
        schedule = decode(seq, assign, instance)
        evaluate_schedule(instance, schedule)
        population.append((seq, assign, schedule.objective))

    best = min(population, key=lambda x: x[2])
    trace = [(0, 0.0, best[2])]

    iteration = 0
    while time.time() - t0 < time_limit:
        iteration += 1

        # 选择（锦标赛）
        candidates = rng.sample(population, min(4, pop_size))
        parent1 = min(candidates[:2], key=lambda x: x[2])
        parent2 = min(candidates[2:], key=lambda x: x[2])

        # 交叉（OX - 顺序交叉）
        p1_seq, p2_seq = parent1[0], parent2[0]
        n = len(p1_seq)
        a, b = sorted(rng.sample(range(n), 2))
        child = [None] * n
        child[a:b] = p1_seq[a:b]
        remaining = [x for x in p2_seq if x not in child[a:b]]
        idx = 0
        for i in range(n):
            if child[i] is None:
                child[i] = remaining[idx]
                idx += 1

        # 变异
        if rng.random() < mutation_rate:
            child = random_swap(child, rng)

        # 局部搜索
        assign = init_random_machine_assignment(instance, rng.randint(0, 2**32))
        for _ in range(local_search_iters):
            new_child = random_swap(child, rng)
            s1 = decode(child, assign, instance)
            s2 = decode(new_child, assign, instance)
            if s2.objective < s1.objective:
                child = new_child

        # 评估
        schedule = decode(child, assign, instance)
        evaluate_schedule(instance, schedule)

        # 替换最差
        worst_idx = max(range(pop_size), key=lambda i: population[i][2])
        population[worst_idx] = (child, assign, schedule.objective)

        # 更新最优
        current_best = min(population, key=lambda x: x[2])
        if current_best[2] < best[2]:
            best = current_best

        trace.append((iteration, time.time() - t0, best[2]))

    # 返回最优解的 schedule
    best_seq, best_assign, _ = best
    best_schedule = decode(best_seq, best_assign, instance)
    evaluate_schedule(instance, best_schedule)

    return best_schedule, trace, {"job_sequence": best_seq, "machine_assignment": best_assign}
