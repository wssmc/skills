"""领域模型 — 所有模块共享的核心数据结构。

包含: Instance, Schedule, Result, Operation, PrecedenceArc
被 MIP / decoder / baseline / 元启发式算法共用。
"""
from __future__ import annotations

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


@dataclass
class PrecedenceArc:
    """前序弧（作业间的优先约束）。"""
    from_job: int
    to_job: int
    lag: float = 0.0


@dataclass
class Instance:
    """算例数据（工时、机器、前序关系等）。

    具体问题继承此类，添加问题特有字段。
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
        for j in range(self.num_jobs):
            for s in range(self.num_stages):
                if j not in self.processing_times or s not in self.processing_times[j]:
                    errors.append(f"Missing processing time for job {j} stage {s}")
        for s in range(self.num_stages):
            if s not in self.stage_machines or len(self.stage_machines[s]) == 0:
                errors.append(f"Stage {s} has no machines")
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
