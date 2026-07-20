"""目标值计算 — src/metaheuristics/decoding/metrics.py

计算 makespan, total_tardiness, average_flow_time 等。
"""
from __future__ import annotations

import sys
sys.path.insert(0, str(__import__("pathlib").Path(__file__).resolve().parent.parent.parent))
from core.domain import Instance, Schedule


def calculate_makespan(schedule: Schedule) -> float:
    """计算 makespan（最大完工时间）。"""
    if not schedule.operations:
        return float("inf")
    return max(op.end for op in schedule.operations)


def calculate_total_tardiness(instance: Instance, schedule: Schedule) -> float:
    """计算总延迟。"""
    job_completion = {}
    for op in schedule.operations:
        job_completion[op.job_id] = max(
            job_completion.get(op.job_id, 0.0), op.end
        )

    total_tardiness = 0.0
    for j, completion in job_completion.items():
        due = instance.due_dates.get(j, float("inf"))
        weight = instance.due_weights.get(j, 1.0)
        tardiness = max(0.0, completion - due)
        total_tardiness += weight * tardiness
    return total_tardiness


def calculate_average_flow_time(instance: Instance, schedule: Schedule) -> float:
    """计算平均流程时间。"""
    job_completion = {}
    for op in schedule.operations:
        job_completion[op.job_id] = max(
            job_completion.get(op.job_id, 0.0), op.end
        )

    total_flow = 0.0
    for j, completion in job_completion.items():
        release = instance.release_times.get(j, 0.0)
        total_flow += (completion - release)

    return total_flow / max(len(job_completion), 1)


def evaluate_schedule(instance: Instance, schedule: Schedule) -> dict:
    """计算所有指标并更新 schedule.metrics。"""
    schedule.metrics["makespan"] = calculate_makespan(schedule)
    schedule.metrics["total_tardiness"] = calculate_total_tardiness(instance, schedule)
    schedule.metrics["average_flow_time"] = calculate_average_flow_time(instance, schedule)
    schedule.objective = schedule.metrics["makespan"]
    return schedule.metrics
