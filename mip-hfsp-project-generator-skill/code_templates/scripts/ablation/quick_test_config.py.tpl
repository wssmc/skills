"""固化小实验默认配置 — scripts/ablation/quick_test_config.py

所有消融/DOE/参数扫描脚本的默认算例、种子、重复次数。
直接 import 使用，避免每次手动指定算例和种子。
"""
from __future__ import annotations

from pathlib import Path


# 每规模第一个算例（按算例目录排序取第一个）
def _get_first_instance(scale: str) -> str:
    """获取指定规模的第一个算例路径。"""
    data_dir = Path(__file__).resolve().parent.parent.parent / "data" / scale
    if not data_dir.exists():
        return f"data/{scale}/inst_001_10_5_01"  # fallback
    instances = sorted([d for d in data_dir.iterdir() if d.is_dir()])
    if instances:
        return str(instances[0])
    return f"data/{scale}/inst_001_10_5_01"


QUICK_INSTANCES = {
    "small": _get_first_instance("small"),
    "large": _get_first_instance("large"),
}

# 固定种子
QUICK_SEEDS = [1, 2, 3]

# 重复次数
REPEAT = 3

# 时间系数
TIME_FACTOR = 0.05


def get_quick_config(scale: str = "small") -> dict:
    """获取快速测试配置。

    Args:
        scale: "small" 或 "large"

    Returns:
        dict: {instance, seeds, repeat, time_factor}
    """
    return {
        "instance": QUICK_INSTANCES.get(scale, QUICK_INSTANCES["small"]),
        "seeds": QUICK_SEEDS,
        "repeat": REPEAT,
        "time_factor": TIME_FACTOR,
    }


def calc_time_limit(num_jobs: int, num_stages: int, factor: float = None) -> float:
    """计算时间限制: N_jobs * M_stages * factor"""
    if factor is None:
        factor = TIME_FACTOR
    return num_jobs * num_stages * factor


if __name__ == "__main__":
    config = get_quick_config("small")
    print(f"Quick test config (small):")
    print(f"  Instance: {config['instance']}")
    print(f"  Seeds: {config['seeds']}")
    print(f"  Repeat: {config['repeat']}")
    print(f"  Time factor: {config['time_factor']}")
