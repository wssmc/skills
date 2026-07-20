"""领域模型 — 所有模块共享的核心数据结构。

包含: Instance, Schedule, Result, Operation, PrecedenceArc
被 MIP / decoder / baseline / 元启发式算法共用。
"""
from __future__ import annotations

import math
from dataclasses import dataclass, field
from typing import Any


@dataclass
class Operation:
    """单个操作（作业、阶段、机器、开始/结束时间）。"""
    job_id: int
    stage_id: int
    machine_id: int = -1
    start: float = 0.0
    end: float = 0.0
    processing_time: float = 0.0

    @property
    def resource_key(self) -> tuple[int, int]:
        """返回 HFSP 中全局唯一的资源键。机器编号只在 Stage 内唯一。"""
        return self.stage_id, self.machine_id


@dataclass
class PrecedenceArc:
    """前序弧（作业间的优先约束）。"""
    from_job: int
    to_job: int
    lag: float = 0.0


@dataclass
class Instance:
    """算例数据（工时、机器、前序关系等）。

    此结构直接描述基础 HFSP；扩展问题需同步修改全链适配器与测试。
    """
    name: str = ""
    problem_type: str = ""
    num_jobs: int = 0
    num_stages: int = 0
    processing_times: dict = field(default_factory=dict)  # p[j][s] = float
    stage_machines: dict = field(default_factory=dict)    # stage_id -> list of machine_ids
    release_times: dict = field(default_factory=dict)     # job_id -> float
    due_dates: dict = field(default_factory=dict)         # job_id -> float
    due_weights: dict = field(default_factory=dict)       # job_id -> float
    precedence: list = field(default_factory=list)        # list[PrecedenceArc]
    metadata: dict = field(default_factory=dict)

    def validate(self) -> list[str]:
        """返回验证错误列表，空列表表示通过。"""
        errors = []
        if self.num_jobs <= 0:
            errors.append("num_jobs must be positive")
        if self.num_stages <= 0:
            errors.append("num_stages must be positive")
        expected_jobs = set(range(self.num_jobs))
        if set(self.processing_times) != expected_jobs:
            errors.append("processing_times job identifiers must be contiguous from 0")
        for j in range(self.num_jobs):
            for s in range(self.num_stages):
                if j not in self.processing_times or s not in self.processing_times[j]:
                    errors.append(f"Missing processing time for job {j} stage {s}")
                elif (
                    not isinstance(self.processing_times[j][s], (int, float))
                    or not math.isfinite(self.processing_times[j][s])
                    or self.processing_times[j][s] <= 0
                ):
                    errors.append(f"Processing time must be positive for job {j} stage {s}")
        for s in range(self.num_stages):
            if s not in self.stage_machines or len(self.stage_machines[s]) == 0:
                errors.append(f"Stage {s} has no machines")
            else:
                machines = self.stage_machines[s]
                if not all(isinstance(machine, int) for machine in machines):
                    errors.append(f"Stage {s} machine identifiers must be integers")
                elif len(set(machines)) != len(machines):
                    errors.append(f"Stage {s} contains duplicate machine identifiers")
        for mapping_name, mapping in (
            ("release_times", self.release_times),
            ("due_dates", self.due_dates),
            ("due_weights", self.due_weights),
        ):
            unknown = set(mapping) - expected_jobs
            if unknown:
                errors.append(f"{mapping_name} contains unknown jobs: {sorted(unknown)}")
        for job_id, release in self.release_times.items():
            if (
                not isinstance(release, (int, float))
                or not math.isfinite(release)
                or release < 0
            ):
                errors.append(f"Release time must be non-negative for job {job_id}")
        for job_id, due in self.due_dates.items():
            if not isinstance(due, (int, float)) or not math.isfinite(due):
                errors.append(f"Due date must be finite for job {job_id}")
        for job_id, weight in self.due_weights.items():
            if (
                not isinstance(weight, (int, float))
                or not math.isfinite(weight)
                or weight < 0
            ):
                errors.append(f"Due weight must be non-negative for job {job_id}")
        for arc in self.precedence:
            job_ids_are_valid = (
                isinstance(arc.from_job, int)
                and isinstance(arc.to_job, int)
                and 0 <= arc.from_job < self.num_jobs
                and 0 <= arc.to_job < self.num_jobs
            )
            if not job_ids_are_valid:
                errors.append(f"Invalid precedence arc: {arc.from_job} -> {arc.to_job}")
            elif arc.from_job == arc.to_job:
                errors.append(f"Self precedence is not allowed for job {arc.from_job}")
            if (
                not isinstance(arc.lag, (int, float))
                or not math.isfinite(arc.lag)
                or arc.lag < 0
            ):
                errors.append(f"Precedence lag must be non-negative: {arc.from_job} -> {arc.to_job}")
        valid_arcs = [
            arc for arc in self.precedence
            if isinstance(arc.from_job, int)
            and isinstance(arc.to_job, int)
            and 0 <= arc.from_job < self.num_jobs
            and 0 <= arc.to_job < self.num_jobs
            and arc.from_job != arc.to_job
        ]
        adjacency = {job: set() for job in range(self.num_jobs)}
        indegree = {job: 0 for job in range(self.num_jobs)}
        for arc in valid_arcs:
            if arc.to_job not in adjacency[arc.from_job]:
                adjacency[arc.from_job].add(arc.to_job)
                indegree[arc.to_job] += 1
        queue = [job for job, degree in indegree.items() if degree == 0]
        visited = 0
        while queue:
            job = queue.pop()
            visited += 1
            for successor in adjacency[job]:
                indegree[successor] -= 1
                if indegree[successor] == 0:
                    queue.append(successor)
        if visited != self.num_jobs:
            errors.append("Precedence graph contains a cycle")
        return errors


@dataclass
class Schedule:
    """排程结果（操作列表、目标值）。"""
    operations: list = field(default_factory=list)  # list[Operation]
    objective: float = float("inf")
    metrics: dict = field(default_factory=dict)

    def to_records(self) -> list[dict]:
        """导出为字典列表。"""
        return [
            {
                "job_id": op.job_id,
                "stage_id": op.stage_id,
                "machine_id": op.machine_id,
                "start": op.start,
                "end": op.end,
                "processing_time": op.processing_time,
            }
            for op in self.operations
        ]


@dataclass
class Result:
    """完整结果（方法、状态、目标值、运行时间、排程）。"""
    method: str = ""
    status: str = ""  # "Optimal" / "Feasible" / "Infeasible" / "Timeout"
    objective: float = float("inf")
    makespan: float = float("inf")
    runtime: float = 0.0
    schedule: Schedule = field(default_factory=Schedule)
    extra: dict = field(default_factory=dict)  # {sequence, seed, LB, gap, violations, ...}
