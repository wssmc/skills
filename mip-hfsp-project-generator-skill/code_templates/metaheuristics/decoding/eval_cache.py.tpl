"""计算缓存 — src/metaheuristics/decoding/eval_cache.py

FIFO 队列保存编码→目标值映射，队列大小限制 500。
在评估时优先查缓存命中，未命中再解码计算。
"""
from __future__ import annotations

from collections import OrderedDict


class EvalCache:
    """计算缓存（FIFO 队列）。

    用 FIFO 队列保存已计算的编码→目标值映射，避免内存过大。
    队列大小限制 500。
    """

    MAX_SIZE = 500

    def __init__(self, max_size: int = MAX_SIZE):
        self._cache: OrderedDict = OrderedDict()
        self.max_size = max_size
        self.hits = 0
        self.misses = 0

    def get(self, key):
        """查缓存。

        Args:
            key: 编码的哈希键（如 tuple(job_sequence)）

        Returns:
            目标值，如果未命中返回 None
        """
        if key in self._cache:
            self.hits += 1
            return self._cache[key]
        self.misses += 1
        return None

    def put(self, key, value):
        """存入缓存。如果超过大小限制，弹出最旧的条目。"""
        if key in self._cache:
            self._cache.move_to_end(key)
            self._cache[key] = value
            return

        self._cache[key] = value
        if len(self._cache) > self.max_size:
            self._cache.popitem(last=False)

    def get_or_compute(self, key, compute_fn):
        """查缓存，未命中则计算并缓存。"""
        val = self.get(key)
        if val is not None:
            return val
        val = compute_fn()
        self.put(key, val)
        return val

    def clear(self):
        """清空缓存。"""
        self._cache.clear()
        self.hits = 0
        self.misses = 0

    @property
    def hit_rate(self) -> float:
        total = self.hits + self.misses
        return self.hits / total if total > 0 else 0.0

    def stats(self) -> dict:
        """返回缓存统计。"""
        return {
            "size": len(self._cache),
            "max_size": self.max_size,
            "hits": self.hits,
            "misses": self.misses,
            "hit_rate": self.hit_rate,
        }
