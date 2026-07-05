"""NEH 启发式初始化 — src/metaheuristics/initial/neh.py

Nawaz-Enscore-Ham 启发式，经典 HFSP/FSP 初始化方法。
"""
from __future__ import annotations

import sys
sys.path.insert(0, str(__import__("pathlib").Path(__file__).resolve().parent.parent.parent))
from core.domain import Instance


def init_neh(instance: Instance, decoder=None) -> list[int]:
    """NEH 启发式初始化。

    1. 按作业总加工时间降序排列
    2. 逐步插入，每次选择最佳位置

    Args:
        instance: 算例数据
        decoder: 解码器（用于评估部分序列的目标值），如果为 None 则返回排序序列

    Returns:
        作业排列
    """
    totals = {}
    for j in range(instance.num_jobs):
        totals[j] = sum(instance.processing_times.get(j, {}).get(s, 0.0)
                        for s in range(instance.num_stages))
    ordered = sorted(range(instance.num_jobs), key=lambda j: -totals[j])

    if decoder is None:
        return ordered

    result = [ordered[0]]
    for k in range(1, len(ordered)):
        best_seq = None
        best_obj = float("inf")
        for pos in range(k + 1):
            trial = result[:pos] + [ordered[k]] + result[pos:]
            obj = decoder(trial)
            if obj < best_obj:
                best_obj = obj
                best_seq = trial
        result = best_seq

    return result
