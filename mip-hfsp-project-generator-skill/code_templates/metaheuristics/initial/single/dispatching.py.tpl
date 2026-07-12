"""调度规则初始化（单解生成器）— src/metaheuristics/initial/single/dispatching.py

⚠ 用途约定：仅用于单解元启发式（SA / IG / TS）的初始解生成。
⚠ 严禁直接用于种群初始化（GA / MA）——会导致所有个体相同，丧失种群多样性。
   种群初始化请使用 `src/metaheuristics/initial/population/` 下的生成器。

函数签名：init_xxx(instance, **kwargs) -> list[int]  返回单个作业排列
"""
from __future__ import annotations

import sys
sys.path.insert(0, str(__import__("pathlib").Path(__file__).resolve().parent.parent.parent.parent))
from core.domain import Instance


def init_spt(instance: Instance) -> list[int]:
    """SPT (Shortest Processing Time)：按作业总加工时间升序。"""
    totals = {}
    for j in range(instance.num_jobs):
        totals[j] = sum(instance.processing_times.get(j, {}).get(s, 0.0)
                        for s in range(instance.num_stages))
    return sorted(range(instance.num_jobs), key=lambda j: totals[j])


def init_lpt(instance: Instance) -> list[int]:
    """LPT (Longest Processing Time)：按作业总加工时间降序。"""
    totals = {}
    for j in range(instance.num_jobs):
        totals[j] = sum(instance.processing_times.get(j, {}).get(s, 0.0)
                        for s in range(instance.num_stages))
    return sorted(range(instance.num_jobs), key=lambda j: -totals[j])


def init_edd(instance: Instance) -> list[int]:
    """EDD (Earliest Due Date)：按交期升序。"""
    return sorted(range(instance.num_jobs),
                  key=lambda j: instance.due_dates.get(j, float("inf")))
