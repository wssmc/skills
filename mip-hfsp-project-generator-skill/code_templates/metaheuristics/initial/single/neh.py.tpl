"""NEH 启发式（单解生成器）— src/metaheuristics/initial/single/neh.py

⚠ 用途约定：仅用于单解元启发式（SA / IG / TS）的初始解生成。
⚠ 严禁直接用于种群初始化（GA / MA）——NEH 是确定性算法，会产生相同个体。
   种群初始化请使用 `src/metaheuristics/initial/population/` 下的生成器。

函数签名：init_neh(instance, decoder=None) -> list[int]
"""
from __future__ import annotations

import sys
sys.path.insert(0, str(__import__("pathlib").Path(__file__).resolve().parent.parent.parent.parent))
from core.domain import Instance


def init_neh(instance: Instance, decoder=None) -> list[int]:
    """NEH 启发式：按 total processing time 降序，逐步插入最佳位置。"""
    totals = {}
    for j in range(instance.num_jobs):
        totals[j] = sum(instance.processing_times.get(j, {}).get(s, 0.0)
                        for s in range(instance.num_stages))
    ordered = sorted(range(instance.num_jobs), key=lambda j: -totals[j])

    if decoder is None:
        return ordered

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
