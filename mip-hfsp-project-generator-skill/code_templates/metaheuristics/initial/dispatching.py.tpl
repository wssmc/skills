"""调度规则初始化 — src/metaheuristics/initial/dispatching.py

提供 SPT, LPT 等调度规则初始化方法。
"""
from __future__ import annotations

import sys
sys.path.insert(0, str(__import__("pathlib").Path(__file__).resolve().parent.parent.parent))
from core.domain import Instance


def init_spt(instance: Instance) -> list[int]:
    """SPT (Shortest Processing Time) 初始化。

    按作业总加工时间升序排列。
    """
    totals = {}
    for j in range(instance.num_jobs):
        totals[j] = sum(instance.processing_times.get(j, {}).get(s, 0.0)
                        for s in range(instance.num_stages))
    return sorted(range(instance.num_jobs), key=lambda j: totals[j])


def init_lpt(instance: Instance) -> list[int]:
    """LPT (Longest Processing Time) 初始化。

    按作业总加工时间降序排列。
    """
    totals = {}
    for j in range(instance.num_jobs):
        totals[j] = sum(instance.processing_times.get(j, {}).get(s, 0.0)
                        for s in range(instance.num_stages))
    return sorted(range(instance.num_jobs), key=lambda j: -totals[j])


def init_edd(instance: Instance) -> list[int]:
    """EDD (Earliest Due Date) 初始化。"""
    return sorted(range(instance.num_jobs),
                  key=lambda j: instance.due_dates.get(j, float("inf")))
