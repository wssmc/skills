"""置换序列编码 — src/metaheuristics/encoding/sequence_encoding.py

全作业的一个排列 + 机器分配。
"""
from __future__ import annotations

import random
from dataclasses import dataclass, field

import sys
sys.path.insert(0, str(__import__("pathlib").Path(__file__).resolve().parent.parent.parent))
from core.domain import Instance


def serialize_machine_assignment(assignment: dict) -> list[dict]:
    """把内部 tuple-key 映射转换为稳定、JSON 安全的公开格式。"""
    return [
        {"job_id": int(j), "stage_id": int(s), "machine_id": int(m)}
        for (j, s), m in sorted(assignment.items())
    ]


def deserialize_machine_assignment(records: list[dict]) -> dict:
    """把公开记录列表转换为解码器使用的 tuple-key 映射。"""
    assignment = {}
    for record in records:
        key = (int(record["job_id"]), int(record["stage_id"]))
        if key in assignment:
            raise ValueError(f"Duplicate machine assignment for job/stage {key}")
        assignment[key] = int(record["machine_id"])
    return assignment


@dataclass
class SequenceEncoding:
    """置换序列编码。"""
    job_sequence: list[int] = field(default_factory=list)
    machine_assignment: dict = field(default_factory=dict)  # (job_id, stage_id) -> machine_id

    def validate(self, instance: Instance) -> bool:
        """校验编码是否合法。"""
        if sorted(self.job_sequence) != list(range(instance.num_jobs)):
            return False
        for j in range(instance.num_jobs):
            for s in range(instance.num_stages):
                if (j, s) not in self.machine_assignment:
                    return False
                m = self.machine_assignment[(j, s)]
                if m not in instance.stage_machines.get(s, []):
                    return False
        return True

    def to_dict(self) -> dict:
        return {
            "job_sequence": list(self.job_sequence),
            "machine_assignment": serialize_machine_assignment(self.machine_assignment),
        }


def generate_random_encoding(instance: Instance, seed: int | None = None) -> SequenceEncoding:
    """生成随机编码。"""
    errors = instance.validate()
    if errors:
        raise ValueError(f"Invalid instance: {errors}")
    rng = random.Random(seed)
    seq = list(range(instance.num_jobs))
    rng.shuffle(seq)
    assignment = {}
    for j in range(instance.num_jobs):
        for s in range(instance.num_stages):
            machines = instance.stage_machines[s]
            assignment[(j, s)] = rng.choice(machines)
    return SequenceEncoding(job_sequence=seq, machine_assignment=assignment)
