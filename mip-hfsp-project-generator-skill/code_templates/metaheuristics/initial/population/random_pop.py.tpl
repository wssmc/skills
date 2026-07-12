"""随机种群生成器 — src/metaheuristics/initial/population/random_pop.py

⚠ 用途约定：仅用于种群元启发式（GA / MA）的种群初始化。
⚠ 严禁作为单解生成器（SA / IG / TS 应使用 `initial/single/random_init.py`）。

生成 pop_size 个**互不相同**的作业排列，保证种群多样性。

函数签名：generate_random_population(instance, pop_size, seed=None, **kwargs)
        -> list[list[int]]  返回 pop_size 个作业排列
"""
from __future__ import annotations

import random
from math import factorial

import sys
sys.path.insert(0, str(__import__("pathlib").Path(__file__).resolve().parent.parent.parent.parent))
from core.domain import Instance


def generate_random_population(instance: Instance, pop_size: int,
                               seed: int | None = None,
                               ensure_diversity: bool = True) -> list[list[int]]:
    """生成随机种群。

    Args:
        instance: 算例数据
        pop_size: 种群大小
        seed: 随机种子
        ensure_diversity: 是否保证个体互不相同（默认 True）。
            当 pop_size 接近 n! 时（小规模算例）自动放宽，避免死循环。

    Returns:
        list[list[int]]: pop_size 个作业排列
    """
    rng = random.Random(seed)
    n = instance.num_jobs

    # 若 pop_size 接近 n!，无法保证全部唯一，改为允许重复
    max_unique = factorial(n) if n <= 10 else float("inf")
    if pop_size > max_unique * 0.5:
        ensure_diversity = False

    population = []
    seen = set()
    max_attempts = pop_size * 10  # 防死循环
    attempts = 0

    while len(population) < pop_size and attempts < max_attempts:
        seq = list(range(n))
        rng.shuffle(seq)
        attempts += 1

        if ensure_diversity:
            key = tuple(seq)
            if key in seen:
                continue
            seen.add(key)

        population.append(seq)

    # 若仍不足（极端情况），随机填充
    while len(population) < pop_size:
        seq = list(range(n))
        rng.shuffle(seq)
        population.append(seq)

    return population


def generate_random_machine_assignments(instance: Instance, pop_size: int,
                                        seed: int | None = None) -> list[dict]:
    """生成 pop_size 个随机机器分配。"""
    rng = random.Random(seed)
    result = []
    for _ in range(pop_size):
        assignment = {}
        for j in range(instance.num_jobs):
            for s in range(instance.num_stages):
                machines = instance.stage_machines.get(s, [0])
                assignment[(j, s)] = rng.choice(machines)
        result.append(assignment)
    return result
