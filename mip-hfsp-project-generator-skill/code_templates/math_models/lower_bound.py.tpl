"""基础 HFSP 的快速下界与 Gurobi best bound。"""
from __future__ import annotations

import math
import sys

sys.path.insert(0, str(__import__("pathlib").Path(__file__).resolve().parent.parent))
from core.domain import Instance


def calc_lower_bound_fast(instance: Instance) -> float:
    """返回阶段负载与单作业工艺路线下界的最大值。"""
    errors = instance.validate()
    if errors:
        raise ValueError(f"Invalid instance: {errors}")

    minimum_release = min(
        (instance.release_times.get(job, 0.0) for job in range(instance.num_jobs)),
        default=0.0,
    )
    stage_bounds = []
    for stage in range(instance.num_stages):
        workload = sum(
            instance.processing_times[job][stage]
            for job in range(instance.num_jobs)
        )
        stage_bounds.append(
            minimum_release + workload / len(instance.stage_machines[stage])
        )

    route_bounds = [
        instance.release_times.get(job, 0.0)
        + sum(instance.processing_times[job][stage] for stage in range(instance.num_stages))
        for job in range(instance.num_jobs)
    ]
    return max(stage_bounds + route_bounds)


def calc_lower_bound_gurobi(instance: Instance, time_limit: float = 60.0) -> float:
    """运行整数模型并返回 Gurobi 在时限内报告的 best bound。"""
    from math_models.gurobi_model import build_and_solve

    result = build_and_solve(
        instance, time_limit=time_limit, mip_gap=0.001, log_output=False
    )
    if result.status == "Error":
        raise RuntimeError(result.extra.get("error", "Gurobi bound computation failed"))
    bound = result.extra.get("LB")
    if not isinstance(bound, (int, float)) or not math.isfinite(bound):
        raise RuntimeError(f"Gurobi did not return a finite lower bound: {bound!r}")
    return float(bound)


def calc_lower_bound(instance: Instance, method: str = "fast") -> float:
    if method == "fast":
        return calc_lower_bound_fast(instance)
    if method == "gurobi_bound":
        return calc_lower_bound_gurobi(instance)
    raise ValueError("method must be 'fast' or 'gurobi_bound'")
