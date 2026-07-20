"""基础 HFSP 排程可行性检查。"""
from __future__ import annotations

import math
import sys

sys.path.insert(0, str(__import__("pathlib").Path(__file__).resolve().parent.parent.parent))
from core.domain import Instance, Schedule


EPSILON = 1e-6


def check_operation_coverage(instance: Instance, schedule: Schedule) -> list[str]:
    violations = []
    counts = {}
    for op in schedule.operations:
        key = (op.job_id, op.stage_id)
        counts[key] = counts.get(key, 0) + 1
    for j in range(instance.num_jobs):
        for s in range(instance.num_stages):
            count = counts.get((j, s), 0)
            if count != 1:
                violations.append(f"Operation coverage violated: job {j} stage {s} occurs {count} times")
    for (j, s), count in counts.items():
        if not (0 <= j < instance.num_jobs and 0 <= s < instance.num_stages):
            violations.append(f"Unexpected operation: job {j} stage {s}")
    return violations


def check_stage_precedence(instance: Instance, schedule: Schedule) -> list[str]:
    violations = []
    operations = {(op.job_id, op.stage_id): op for op in schedule.operations}
    for j in range(instance.num_jobs):
        for s in range(1, instance.num_stages):
            previous = operations.get((j, s - 1))
            current = operations.get((j, s))
            if previous is not None and current is not None and current.start < previous.end - EPSILON:
                violations.append(
                    f"Stage precedence violated: job {j} stage {s} starts at {current.start:.4f} "
                    f"before stage {s - 1} ends at {previous.end:.4f}"
                )
    return violations


def check_explicit_precedence(instance: Instance, schedule: Schedule) -> list[str]:
    violations = []
    first_start = {}
    last_end = {}
    for op in schedule.operations:
        first_start[op.job_id] = min(first_start.get(op.job_id, math.inf), op.start)
        last_end[op.job_id] = max(last_end.get(op.job_id, -math.inf), op.end)
    for arc in instance.precedence:
        if arc.from_job in last_end and arc.to_job in first_start:
            required = last_end[arc.from_job] + arc.lag
            if first_start[arc.to_job] < required - EPSILON:
                violations.append(
                    f"Job precedence violated: job {arc.to_job} starts at {first_start[arc.to_job]:.4f}, "
                    f"required >= {required:.4f} after job {arc.from_job}"
                )
    return violations


def check_machine_no_overlap(schedule: Schedule, epsilon: float = EPSILON) -> list[str]:
    violations = []
    by_resource = {}
    for op in schedule.operations:
        by_resource.setdefault(op.resource_key, []).append(op)
    for (stage_id, machine_id), operations in by_resource.items():
        ordered = sorted(operations, key=lambda op: (op.start, op.end, op.job_id))
        for previous, current in zip(ordered, ordered[1:]):
            if current.start < previous.end - epsilon:
                violations.append(
                    f"Machine overlap on stage {stage_id} machine {machine_id}: "
                    f"job {previous.job_id} ends at {previous.end:.4f}, "
                    f"job {current.job_id} starts at {current.start:.4f}"
                )
    return violations


def check_operation_values(instance: Instance, schedule: Schedule) -> list[str]:
    violations = []
    for op in schedule.operations:
        numeric_values = (op.start, op.end, op.processing_time)
        if not all(isinstance(value, (int, float)) and math.isfinite(value) for value in numeric_values):
            violations.append(
                f"Non-finite operation values: job {op.job_id} stage {op.stage_id} "
                f"start={op.start}, end={op.end}, processing_time={op.processing_time}"
            )
            continue
        if op.start < -EPSILON or op.end < op.start - EPSILON:
            violations.append(
                f"Invalid operation interval: job {op.job_id} stage {op.stage_id} "
                f"start={op.start:.4f}, end={op.end:.4f}"
            )
        if not (0 <= op.job_id < instance.num_jobs and 0 <= op.stage_id < instance.num_stages):
            continue
        if op.machine_id not in instance.stage_machines.get(op.stage_id, []):
            violations.append(
                f"Ineligible machine: job {op.job_id} stage {op.stage_id} uses machine {op.machine_id}"
            )
        expected = instance.processing_times[op.job_id][op.stage_id]
        if abs((op.end - op.start) - expected) > EPSILON:
            violations.append(
                f"Processing time mismatch: job {op.job_id} stage {op.stage_id} "
                f"duration={op.end - op.start:.4f}, expected={expected:.4f}"
            )
        if abs(op.processing_time - expected) > EPSILON:
            violations.append(
                f"Operation processing_time field mismatch: job {op.job_id} stage {op.stage_id} "
                f"value={op.processing_time:.4f}, expected={expected:.4f}"
            )
        release = instance.release_times.get(op.job_id, 0.0)
        if op.start < release - EPSILON:
            violations.append(
                f"Release time violated: job {op.job_id} starts at {op.start:.4f}, release={release:.4f}"
            )
    return violations


def check_objective(schedule: Schedule) -> list[str]:
    if not schedule.operations:
        return ["Schedule has no operations"]
    if not all(isinstance(op.end, (int, float)) and math.isfinite(op.end) for op in schedule.operations):
        return ["Cannot compute objective because at least one operation end is non-finite"]
    makespan = max(op.end for op in schedule.operations)
    violations = []
    if not math.isfinite(makespan):
        violations.append(f"Non-finite makespan derived from operations: {makespan}")
    if (
        not isinstance(schedule.objective, (int, float))
        or not math.isfinite(schedule.objective)
        or abs(schedule.objective - makespan) > EPSILON
    ):
        violations.append(f"Objective mismatch: schedule={schedule.objective}, makespan={makespan}")
    metric = schedule.metrics.get("makespan")
    if metric is not None and (
        not isinstance(metric, (int, float))
        or not math.isfinite(metric)
        or abs(metric - makespan) > EPSILON
    ):
        violations.append(f"Makespan metric mismatch: metric={metric}, makespan={makespan}")
    return violations


def check_feasibility(instance: Instance, schedule: Schedule) -> list[str]:
    """返回完整 violation 列表；空列表表示基础 HFSP 排程可行。"""
    violations = []
    violations.extend(check_operation_coverage(instance, schedule))
    violations.extend(check_operation_values(instance, schedule))
    timing_values_valid = all(
        isinstance(value, (int, float)) and math.isfinite(value)
        for op in schedule.operations
        for value in (op.start, op.end)
    )
    if timing_values_valid:
        violations.extend(check_stage_precedence(instance, schedule))
        violations.extend(check_explicit_precedence(instance, schedule))
        violations.extend(check_machine_no_overlap(schedule))
    violations.extend(check_objective(schedule))
    return violations
