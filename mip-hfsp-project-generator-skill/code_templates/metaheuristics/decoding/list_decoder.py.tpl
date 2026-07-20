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
    expected_jobs = list(range(instance.num_jobs))
    if sorted(job_sequence) != expected_jobs:
        raise ValueError("job_sequence must contain every job exactly once")
    positions = {job: index for index, job in enumerate(job_sequence)}
    for arc in instance.precedence:
        if positions[arc.from_job] >= positions[arc.to_job]:
            raise ValueError(
                f"job_sequence violates precedence {arc.from_job} -> {arc.to_job}"
            )

    machine_available = {}  # (stage_id, machine_id) -> available_time
    job_completion = {}     # job_id -> {stage_id: completion_time}

    schedule = Schedule()
    schedule.operations = []

    for j in job_sequence:
        for s in range(instance.num_stages):
            assignment_key = (j, s)
            if assignment_key not in machine_assignment:
                raise ValueError(f"Missing machine assignment for job {j} stage {s}")
            m = machine_assignment[assignment_key]
            if m not in instance.stage_machines.get(s, []):
                raise ValueError(f"Machine {m} is not eligible for stage {s}")
            pt = instance.processing_times[j][s]

            # 作业在该 Stage 的最早开始时间
            job_ready = instance.release_times.get(j, 0.0)
            if s > 0:
                job_ready = max(job_ready, job_completion.get(j, {}).get(s - 1, 0.0))
            elif instance.precedence:
                predecessor_ready = [
                    job_completion[arc.from_job][instance.num_stages - 1] + arc.lag
                    for arc in instance.precedence
                    if arc.to_job == j
                ]
                if predecessor_ready:
                    job_ready = max(job_ready, max(predecessor_ready))

            # 机器可用时间
            resource_key = (s, m)
            machine_ready = machine_available.get(resource_key, 0.0)

            start = max(job_ready, machine_ready)
            end = start + pt

            op = Operation(
                job_id=j, stage_id=s, machine_id=m,
                start=start, end=end, processing_time=pt,
            )
            schedule.operations.append(op)

            machine_available[resource_key] = end
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
