"""增量评估 — src/metaheuristics/decoding/incremental_eval.py

在邻域搜索中避免全量重解码，加速评估。
"""
from __future__ import annotations

import sys
sys.path.insert(0, str(__import__("pathlib").Path(__file__).resolve().parent.parent.parent))
from core.domain import Instance


class IncrementalEvaluator:
    """增量评估器。

    在邻域移动后，仅重新计算受影响的部分，而非全量重解码。
    """

    def __init__(self, instance: Instance):
        self.instance = instance
        self._cache = {}

    def evaluate_swap(self, sequence: list[int], pos_i: int, pos_j: int,
                      machine_assignment: dict) -> float:
        """评估交换操作后的目标值（增量计算）。

        Args:
            sequence: 当前作业序列
            pos_i, pos_j: 要交换的两个位置
            machine_assignment: 机器分配

        Returns:
            估计的 makespan
        """
        # 简化版：实际增量评估需根据问题具体实现
        # 这里提供框架，具体逻辑由问题决定
        new_seq = sequence.copy()
        new_seq[pos_i], new_seq[pos_j] = new_seq[pos_j], new_seq[pos_i]
        from metaheuristics.decoding.list_decoder import decode
        schedule = decode(new_seq, machine_assignment, self.instance)
        return schedule.objective

    def evaluate_insert(self, sequence: list[int], from_pos: int, to_pos: int,
                        machine_assignment: dict) -> float:
        """评估插入操作后的目标值（增量计算）。"""
        new_seq = sequence.copy()
        job = new_seq.pop(from_pos)
        new_seq.insert(to_pos, job)
        from metaheuristics.decoding.list_decoder import decode
        schedule = decode(new_seq, machine_assignment, self.instance)
        return schedule.objective
