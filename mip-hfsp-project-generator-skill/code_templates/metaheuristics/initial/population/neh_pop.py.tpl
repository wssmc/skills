"""NEH-based 种群生成器 — src/metaheuristics/initial/population/neh_pop.py

⚠ 用途约定：仅用于种群元启发式（GA / MA）的种群初始化。
⚠ NEH 本身是确定性算法，直接调用 pop_size 次会得到 pop_size 个相同解。
   本模块通过**扰动策略**（首解扰动 / 随机重启 / 混合策略）生成多样化种群。

函数签名：generate_neh_population(instance, pop_size, seed=None, strategy='mixed', decoder=None)
        -> list[list[int]]
"""
from __future__ import annotations

import random

import sys
sys.path.insert(0, str(__import__("pathlib").Path(__file__).resolve().parent.parent.parent.parent))
from core.domain import Instance
from metaheuristics.initial.single.neh import init_neh
from metaheuristics.initial.single.random_init import init_random


def _neh_with_perturbation(instance: Instance, rng: random.Random, decoder) -> list[int]:
    """扰动版 NEH：先随机打乱几个 job 的初始排序，再执行 NEH 插入。"""
    n = instance.num_jobs
    totals = {j: sum(instance.processing_times.get(j, {}).get(s, 0.0)
                     for s in range(instance.num_stages))
              for j in range(n)}
    ordered = sorted(range(n), key=lambda j: -totals[j])

    # 随机交换若干对起始位置引入扰动
    n_swaps = max(1, n // 5)
    for _ in range(n_swaps):
        i, k = rng.sample(range(n), 2)
        ordered[i], ordered[k] = ordered[k], ordered[i]

    if decoder is None:
        return ordered

    # 标准 NEH 插入
    result = [ordered[0]]
    for k in range(1, len(ordered)):
        best_seq, best_obj = None, float("inf")
        for pos in range(k + 1):
            trial = result[:pos] + [ordered[k]] + result[pos:]
            obj = decoder(trial)
            if obj < best_obj:
                best_obj, best_seq = obj, trial
        result = best_seq

    return result


def generate_neh_population(instance: Instance, pop_size: int,
                            seed: int | None = None,
                            strategy: str = "mixed",
                            decoder=None) -> list[list[int]]:
    """生成基于 NEH 的多样化种群。

    Args:
        instance: 算例数据
        pop_size: 种群大小
        seed: 随机种子
        strategy:
            - "perturbed"：全部使用扰动 NEH
            - "mixed"：1 个纯 NEH + (pop_size-1) 个扰动 NEH + 少量随机
            - "seed_plus_random"：1 个纯 NEH + (pop_size-1) 个随机
        decoder: 目标值评估函数，用于 NEH 内部插入决策

    Returns:
        list[list[int]]: pop_size 个作业排列
    """
    rng = random.Random(seed)
    population = []

    if strategy == "seed_plus_random":
        population.append(init_neh(instance, decoder))
        while len(population) < pop_size:
            population.append(init_random(instance, rng.randint(0, 2**32)))

    elif strategy == "perturbed":
        for _ in range(pop_size):
            population.append(_neh_with_perturbation(instance, rng, decoder))

    else:  # "mixed"（默认）
        population.append(init_neh(instance, decoder))  # 1 个纯 NEH（精英种子）
        n_perturbed = max(1, int(pop_size * 0.7))       # 70% 扰动 NEH
        for _ in range(n_perturbed):
            population.append(_neh_with_perturbation(instance, rng, decoder))
        while len(population) < pop_size:               # 剩余随机（维持多样性）
            population.append(init_random(instance, rng.randint(0, 2**32)))

    return population[:pop_size]
