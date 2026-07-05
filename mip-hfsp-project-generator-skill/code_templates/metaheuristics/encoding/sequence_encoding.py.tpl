"""置换序列编码 — src/metaheuristics/encoding/sequence_encoding.py

全作业的一个排列 + 机器分配。
"""
from __future__ import annotations

import random
from dataclasses import dataclass, field

import sys
sys.path.insert(0, str(__import__("pathlib").Path(__file__).resolve().parent.parent.parent))
from core.domain import Instance


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


def generate_random_encoding(instance: Instance, seed: int | None = None) -> SequenceEncoding:
    """生成随机编码。"""
    rng = random.Random(seed)
    seq = list(range(instance.num_jobs))
    rng.shuffle(seq)
    assignment = {}
    for j in range(instance.num_jobs):
        for s in range(instance.num_stages):
            machines = instance.stage_machines.get(s, [0])
            assignment[(j, s)] = rng.choice(machines)
    return SequenceEncoding(job_sequence=seq, machine_assignment=assignment)
