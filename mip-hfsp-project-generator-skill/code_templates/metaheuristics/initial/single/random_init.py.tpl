"""随机初始化（单解生成器）— src/metaheuristics/initial/single/random_init.py

⚠ 用途约定：仅用于单解元启发式（SA / IG / TS）的初始解生成。
⚠ 严禁直接用于种群初始化（GA / MA）——单次调用只生成一个解。
   种群初始化请使用 `src/metaheuristics/initial/population/random_pop.py`
   （其内部循环调用本模块生成 pop_size 个不同的解）。

函数签名：init_random(instance, seed=None) -> list[int]
"""
from __future__ import annotations

import random

import sys
sys.path.insert(0, str(__import__("pathlib").Path(__file__).resolve().parent.parent.parent.parent))
from core.domain import Instance


def init_random(instance: Instance, seed: int | None = None) -> list[int]:
    """随机作业排列。"""
    rng = random.Random(seed)
    seq = list(range(instance.num_jobs))
    rng.shuffle(seq)
    return seq


def init_random_machine_assignment(instance: Instance, seed: int | None = None) -> dict:
    """随机机器分配 (job, stage) -> machine_id。"""
    rng = random.Random(seed)
    assignment = {}
    for j in range(instance.num_jobs):
        for s in range(instance.num_stages):
            machines = instance.stage_machines.get(s, [0])
            assignment[(j, s)] = rng.choice(machines)
    return assignment
