"""邻域选择框架 — src/metaheuristics/neighborhood/frameworks.py

VNS / ALNS / 随机均匀等邻域选择框架。
"""
from __future__ import annotations

import random
from abc import ABC, abstractmethod
from collections import defaultdict

from metaheuristics.neighborhood.operators import (
    NeighborhoodType, get_neighbor, random_insert, random_swap,
)


class NeighborhoodFramework(ABC):
    """邻域选择框架基类。"""

    def __init__(self, neighborhood_types: list[NeighborhoodType]):
        self.neighborhood_types = neighborhood_types

    @abstractmethod
    def select_and_move(self, sequence: list[int], rng: random.Random) -> tuple[list[int], NeighborhoodType]:
        """选择邻域并执行移动，返回新序列和使用的邻域类型。"""
        ...

    @abstractmethod
    def update(self, neighborhood_type: NeighborhoodType, improvement: float):
        """根据移动结果更新框架状态。"""
        ...


class UniformRandomState(NeighborhoodFramework):
    """均匀随机选择：所有算子等概率。"""

    def select_and_move(self, sequence: list[int], rng: random.Random) -> tuple[list[int], NeighborhoodType]:
        nt = rng.choice(self.neighborhood_types)
        new_seq = get_neighbor(sequence, nt, rng)
        return new_seq, nt

    def update(self, neighborhood_type: NeighborhoodType, improvement: float):
        pass  # 均匀随机不需要更新


class VnsState(NeighborhoodFramework):
    """变邻域搜索：按固定顺序 N1→NK 遍历，接受最优改进时回 N1。"""

    def __init__(self, neighborhood_types: list[NeighborhoodType]):
        super().__init__(neighborhood_types)
        self.current_idx = 0

    def select_and_move(self, sequence: list[int], rng: random.Random) -> tuple[list[int], NeighborhoodType]:
        nt = self.neighborhood_types[self.current_idx]
        new_seq = get_neighbor(sequence, nt, rng)
        return new_seq, nt

    def update(self, neighborhood_type: NeighborhoodType, improvement: float):
        if improvement > 0:
            self.current_idx = 0  # 改进时回到第一个邻域
        else:
            self.current_idx = (self.current_idx + 1) % len(self.neighborhood_types)


class AlnsState(NeighborhoodFramework):
    """自适应大邻域搜索：根据算子历史表现动态调整权重。"""

    def __init__(self, neighborhood_types: list[NeighborhoodType],
                 initial_weight: float = 1.0, decay: float = 0.9):
        super().__init__(neighborhood_types)
        self.weights = {nt: initial_weight for nt in neighborhood_types}
        self.decay = decay
        self._scores = defaultdict(float)

    def select_and_move(self, sequence: list[int], rng: random.Random) -> tuple[list[int], NeighborhoodType]:
        total = sum(self.weights.values())
        r = rng.random() * total
        cum = 0.0
        selected = self.neighborhood_types[0]
        for nt in self.neighborhood_types:
            cum += self.weights[nt]
            if r <= cum:
                selected = nt
                break
        new_seq = get_neighbor(sequence, selected, rng)
        return new_seq, selected

    def update(self, neighborhood_type: NeighborhoodType, improvement: float):
        # 衰减旧权重，加上新得分
        for nt in self.weights:
            self.weights[nt] *= self.decay
        if improvement > 0:
            self.weights[neighborhood_type] += improvement
        else:
            self.weights[neighborhood_type] *= 0.95
