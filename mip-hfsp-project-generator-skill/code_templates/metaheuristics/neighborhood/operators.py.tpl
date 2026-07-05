"""邻域算子 — src/metaheuristics/neighborhood/operators.py

集中管理所有邻域移动操作，供 SA / IG / MA / GA / TS 等算法共享调用。
"""
from __future__ import annotations

import random
from enum import Enum


class NeighborhoodType(Enum):
    """邻域算子类型。"""
    INSERT = "insert"          # 插入移动
    SWAP = "swap"              # 交换移动
    BLOCK_MOVE = "block_move"  # 块移动
    REVERSE = "reverse"        # 片段逆序


def insert_move(sequence: list[int], from_pos: int, to_pos: int) -> list[int]:
    """插入移动：将 from_pos 位置的元素移到 to_pos 位置。"""
    new_seq = sequence.copy()
    job = new_seq.pop(from_pos)
    new_seq.insert(to_pos, job)
    return new_seq


def swap_move(sequence: list[int], pos_i: int, pos_j: int) -> list[int]:
    """交换移动：交换 pos_i 和 pos_j 位置的元素。"""
    new_seq = sequence.copy()
    new_seq[pos_i], new_seq[pos_j] = new_seq[pos_j], new_seq[pos_i]
    return new_seq


def block_move(sequence: list[int], start: int, end: int, to_pos: int) -> list[int]:
    """块移动：将 [start, end) 范围的块移到 to_pos 位置。"""
    new_seq = sequence.copy()
    block = new_seq[start:end]
    rest = new_seq[:start] + new_seq[end:]
    insert_pos = to_pos if to_pos < start else to_pos - (end - start)
    rest[insert_pos:insert_pos] = block
    return rest


def reverse_move(sequence: list[int], start: int, end: int) -> list[int]:
    """片段逆序：将 [start, end) 范围的子序列逆序。"""
    new_seq = sequence.copy()
    new_seq[start:end] = reversed(new_seq[start:end])
    return new_seq


def random_insert(sequence: list[int], rng: random.Random) -> list[int]:
    """随机插入移动。"""
    n = len(sequence)
    from_pos = rng.randint(0, n - 1)
    to_pos = rng.randint(0, n - 1)
    while to_pos == from_pos:
        to_pos = rng.randint(0, n - 1)
    return insert_move(sequence, from_pos, to_pos)


def random_swap(sequence: list[int], rng: random.Random) -> list[int]:
    """随机交换移动。"""
    n = len(sequence)
    i = rng.randint(0, n - 1)
    j = rng.randint(0, n - 1)
    while j == i:
        j = rng.randint(0, n - 1)
    return swap_move(sequence, i, j)


def get_neighbor(sequence: list[int], move_type: NeighborhoodType,
                 rng: random.Random) -> list[int]:
    """根据指定的邻域类型生成邻居。"""
    if move_type == NeighborhoodType.INSERT:
        return random_insert(sequence, rng)
    elif move_type == NeighborhoodType.SWAP:
        return random_swap(sequence, rng)
    elif move_type == NeighborhoodType.BLOCK_MOVE:
        n = len(sequence)
        start = rng.randint(0, n - 2)
        end = rng.randint(start + 1, n)
        to_pos = rng.randint(0, n - (end - start))
        return block_move(sequence, start, end, to_pos)
    elif move_type == NeighborhoodType.REVERSE:
        n = len(sequence)
        start = rng.randint(0, n - 2)
        end = rng.randint(start + 1, n)
        return reverse_move(sequence, start, end)
    else:
        return random_swap(sequence, rng)
