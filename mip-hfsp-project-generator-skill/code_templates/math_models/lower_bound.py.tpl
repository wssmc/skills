"""下界计算 — src/math_models/lower_bound.py

快速下界 + 精确下界。
用于评估启发式算法的 Gap。
"""
from __future__ import annotations

import sys
sys.path.insert(0, str(__import__("pathlib").Path(__file__).resolve().parent.parent))
from core.domain import Instance


def calc_lower_bound_fast(instance: Instance) -> float:
    """快速下界：基于机器负载的简单下界。

    对于每个 Stage，计算总加工时间 / 机器数，取最大值。
    再加上各 Stage 的平均加工时间。
    """
    lb = 0.0
    for s in range(instance.num_stages):
        total_pt = sum(
            instance.processing_times.get(j, {}).get(s, 0.0)
            for j in range(instance.num_jobs)
        )
        num_machines = len(instance.stage_machines.get(s, [1]))
        stage_lb = total_pt / max(num_machines, 1)
        lb = max(lb, stage_lb)

    # 加上第一个 Stage 的最小开始时间
    if instance.num_jobs > 0 and instance.num_stages > 0:
        min_start = min(instance.release_times.get(j, 0.0) for j in range(instance.num_jobs))
        lb += min_start

    return round(lb, 4)


def calc_lower_bound_exact(instance: Instance, time_limit: float = 60.0) -> float:
    """精确下界：用 Gurobi 求解 LP 松弛。

    如果 Gurobi 不可用，返回快速下界。
    """
    try:
        import gurobipy as gp
        from gurobipy import GRB
    except ImportError:
        return calc_lower_bound_fast(instance)

    from math_models.gurobi_model import build_and_solve

    result = build_and_solve(instance, time_limit=time_limit, mip_gap=1.0, log_output=False)
    return result.extra.get("LB", calc_lower_bound_fast(instance))


def calc_lower_bound(instance: Instance, method: str = "fast") -> float:
    """计算下界。

    Args:
        instance: 算例数据
        method: "fast" 或 "exact"

    Returns:
        下界值
    """
    if method == "exact":
        return calc_lower_bound_exact(instance)
    return calc_lower_bound_fast(instance)
