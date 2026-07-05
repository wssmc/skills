"""随机初始化 — src/metaheuristics/initial/random_init.py"""
from __future__ import annotations

import random

import sys
sys.path.insert(0, str(__import__("pathlib").Path(__file__).resolve().parent.parent.parent))
from core.domain import Instance


def init_random(instance: Instance, seed: int | None = None) -> list[int]:
    """随机初始化作业排列。"""
    rng = random.Random(seed)
    seq = list(range(instance.num_jobs))
    rng.shuffle(seq)
    return seq


def init_random_machine_assignment(instance: Instance, seed: int | None = None) -> dict:
    """随机机器分配。

    Returns:
        {(job_id, stage_id): machine_id}
    """
    rng = random.Random(seed)
    assignment = {}
    for j in range(instance.num_jobs):
        for s in range(instance.num_stages):
            machines = instance.stage_machines.get(s, [0])
            assignment[(j, s)] = rng.choice(machines)
    return assignment
