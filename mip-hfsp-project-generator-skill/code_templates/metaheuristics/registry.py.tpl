"""算法注册表 — src/metaheuristics/registry.py

所有可运行算法必须注册到此表。
占位算法默认不注册。
"""
from __future__ import annotations

import sys
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parent.parent))

from core.domain import Instance, Schedule


# ============================================================
# 算法状态
# ============================================================
ALGORITHM_STATUS = {
    # Baselines (complete)
    "fifo": "complete",
    "spt_total": "complete",
    "lpt_total": "complete",
    "neh_basic": "complete",
    "random_search": "complete",
    # Problem-specific heuristics (complete)
    # (generated based on problem fingerprint)
    # Metaheuristics (runnable_mvp)
    "sa": "runnable_mvp",
    "ma": "runnable_mvp",
    "ig": "runnable_mvp",
    "ga": "runnable_mvp",
    "ts": "runnable_mvp",
}


# ============================================================
# 算法注册表
# ============================================================
def _build_registry() -> dict:
    """构建算法注册表。

    从各模块导入 solver 函数，返回 {algo_name: solve_func} 映射。
    占位算法不在此注册表中。
    """
    registry = {}

    # Baselines
    from metaheuristics.baselines.baseline_template import solve_baseline_template
    registry["random_search"] = solve_baseline_template

    # SA
    from metaheuristics.sa.sa_basic import solve_sa_basic
    registry["sa"] = solve_sa_basic

    # MA
    from metaheuristics.ma.ma_basic import solve_ma_basic
    registry["ma"] = solve_ma_basic

    # IG
    from metaheuristics.ig.ig_basic import solve_ig_basic
    registry["ig"] = solve_ig_basic

    # GA
    from metaheuristics.ga.ga_basic import solve_ga_basic
    registry["ga"] = solve_ga_basic

    # TS
    from metaheuristics.ts.ts_basic import solve_ts_basic
    registry["ts"] = solve_ts_basic

    return registry


ALGORITHM_REGISTRY = _build_registry()


def get_algorithm(algo_name: str):
    """获取算法函数。

    Args:
        algo_name: 算法名称

    Returns:
        solver 函数

    Raises:
        ValueError: 如果算法未注册或是占位
        NotImplementedError: 如果算法是占位
    """
    if algo_name not in ALGORITHM_REGISTRY:
        if algo_name in ALGORITHM_STATUS and ALGORITHM_STATUS[algo_name] == "placeholder":
            raise NotImplementedError(
                f"Algorithm '{algo_name}' is a placeholder and cannot be run. "
                f"See PLACEHOLDER.md in the algorithm directory."
            )
        raise ValueError(
            f"Algorithm '{algo_name}' is not registered. "
            f"Available algorithms: {list(ALGORITHM_REGISTRY.keys())}"
        )
    return ALGORITHM_REGISTRY[algo_name]


def get_runnable_algorithms() -> list[str]:
    """获取所有可运行算法名称（状态为 complete 或 runnable_mvp）。"""
    return [
        name for name in ALGORITHM_REGISTRY.keys()
        if ALGORITHM_STATUS.get(name, "placeholder") in ("complete", "runnable_mvp")
    ]


def get_algorithm_status(algo_name: str) -> str:
    """获取算法状态。"""
    return ALGORITHM_STATUS.get(algo_name, "placeholder")