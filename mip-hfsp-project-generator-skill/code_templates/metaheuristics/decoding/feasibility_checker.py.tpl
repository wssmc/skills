"""可行性检查 — src/metaheuristics/decoding/feasibility_checker.py

check_feasibility(instance, schedule) -> violations
校验排程是否满足所有约束。
"""
from __future__ import annotations

import sys
sys.path.insert(0, str(__import__("pathlib").Path(__file__).resolve().parent.parent.parent))
from core.domain import Instance, Schedule


def check_stage_precedence(instance: Instance, schedule: Schedule) -> list[str]:
    """校验 Stage 顺序约束。"""
    violations = []
    job_stage_end = {}
    for op in schedule.operations:
        if op.stage_id > 0:
            prev_end = job_stage_end.get((op.job_id, op.stage_id - 1), None)
            if prev_end is not None and op.start < prev_end - 1e-6:
                violations.append(
                    f"Stage precedence violated: Job {op.job_id} Stage {op.stage_id} "
                    f"starts at {op.start:.4f} but Stage {op.stage_id-1} ends at {prev_end:.4f}"
                )
        job_stage_end[(op.job_id, op.stage_id)] = op.end
    return violations


def check_machine_no_overlap(schedule: Schedule, epsilon: float = 1e-6) -> list[str]:
    """校验机器非重叠约束。"""
    violations = []
    by_machine = {}
    for op in schedule.operations:
        by_machine.setdefault(op.machine_id, []).append(op)

    for m, ops in by_machine.items():
        ops_sorted = sorted(ops, key=lambda o: o.start)
        for i in range(1, len(ops_sorted)):
            if ops_sorted[i].start < ops_sorted[i - 1].end - epsilon:
                violations.append(
                    f"Machine overlap on M{m}: Job {ops_sorted[i-1].job_id} "
                    f"ends at {ops_sorted[i-1].end:.4f}, Job {ops_sorted[i].job_id} "
                    f"starts at {ops_sorted[i].start:.4f}"
                )
    return violations


def check_release_times(instance: Instance, schedule: Schedule) -> list[str]:
    """校验释放时间约束。"""
    violations = []
    for op in schedule.operations:
        release = instance.release_times.get(op.job_id, 0.0)
        if op.start < release - 1e-6:
            violations.append(
                f"Release time violated: Job {op.job_id} starts at {op.start:.4f} "
                f"but release time is {release:.4f}"
            )
    return violations


def check_feasibility(instance: Instance, schedule: Schedule) -> list[str]:
    """校验排程是否满足所有约束。

    Args:
        instance: 算例数据
        schedule: 排程结果

    Returns:
        violations 列表，空列表表示可行
    """
    violations = []
    violations.extend(check_stage_precedence(instance, schedule))
    violations.extend(check_machine_no_overlap(schedule))
    violations.extend(check_release_times(instance, schedule))
    return violations
