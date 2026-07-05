"""列表解码器 — src/metaheuristics/decoding/list_decoder.py

将编码转化为可行排程并计算目标值。
"""
from __future__ import annotations

import sys
sys.path.insert(0, str(__import__("pathlib").Path(__file__).resolve().parent.parent.parent))
from core.domain import Instance, Schedule, Operation


def decode(job_sequence: list[int], machine_assignment: dict, instance: Instance) -> Schedule:
    """串行调度生成方案解码。

    Args:
        job_sequence: 作业排列
        machine_assignment: {(job_id, stage_id): machine_id}
        instance: 算例数据

    Returns:
        Schedule 对象
    """
    machine_available = {}  # machine_id -> available_time
    job_completion = {}     # job_id -> {stage_id: completion_time}

    schedule = Schedule()
    schedule.operations = []

    for j in job_sequence:
        for s in range(instance.num_stages):
            m = machine_assignment.get((j, s), 0)
            pt = instance.processing_times.get(j, {}).get(s, 0.0)

            # 作业在该 Stage 的最早开始时间
            job_ready = instance.release_times.get(j, 0.0)
            if s > 0:
                job_ready = max(job_ready, job_completion.get(j, {}).get(s - 1, 0.0))

            # 机器可用时间
            machine_ready = machine_available.get(m, 0.0)

            start = max(job_ready, machine_ready)
            end = start + pt

            op = Operation(
                job_id=j, stage_id=s, machine_id=m,
                start=start, end=end, processing_time=pt,
            )
            schedule.operations.append(op)

            machine_available[m] = end
            if j not in job_completion:
                job_completion[j] = {}
            job_completion[j][s] = end

    # 计算 makespan
    if schedule.operations:
        schedule.objective = max(op.end for op in schedule.operations)
        schedule.metrics["makespan"] = schedule.objective

    return schedule


def decode_and_evaluate(job_sequence: list[int], machine_assignment: dict,
                        instance: Instance) -> float:
    """解码并返回目标值（makespan）。"""
    schedule = decode(job_sequence, machine_assignment, instance)
    return schedule.objective
