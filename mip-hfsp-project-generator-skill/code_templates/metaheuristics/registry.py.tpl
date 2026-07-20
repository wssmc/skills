"""算法注册表。名称、状态和可调用实现必须一一对应。"""
from __future__ import annotations

import sys
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parent.parent))

from metaheuristics.baselines.baseline_template import solve_random_search
from metaheuristics.ga.ga_basic import solve_ga_basic
from metaheuristics.ig.ig_basic import solve_ig_basic
from metaheuristics.ma.ma_basic import solve_ma_basic
from metaheuristics.sa.sa_basic import solve_sa_basic
from metaheuristics.ts.ts_basic import solve_ts_basic


ALGORITHM_REGISTRY = {
    "random_search": solve_random_search,
    "sa_basic": solve_sa_basic,
    "ma_basic": solve_ma_basic,
    "ig_basic": solve_ig_basic,
    "ga_basic": solve_ga_basic,
    "ts_basic": solve_ts_basic,
}

ALGORITHM_STATUS = {
    "random_search": "runnable_mvp",
    "sa_basic": "runnable_mvp",
    "ma_basic": "runnable_mvp",
    "ig_basic": "runnable_mvp",
    "ga_basic": "runnable_mvp",
    "ts_basic": "runnable_mvp",
}


def get_algorithm(algo_name: str):
    if algo_name not in ALGORITHM_REGISTRY:
        raise ValueError(
            f"Algorithm '{algo_name}' is not registered. "
            f"Available algorithms: {sorted(ALGORITHM_REGISTRY)}"
        )
    return ALGORITHM_REGISTRY[algo_name]


def get_runnable_algorithms() -> list[str]:
    return [
        name for name in ALGORITHM_REGISTRY
        if ALGORITHM_STATUS[name] in {"complete", "runnable_mvp"}
    ]


def get_algorithm_status(algo_name: str) -> str:
    if algo_name not in ALGORITHM_STATUS:
        raise ValueError(f"Unknown algorithm '{algo_name}'")
    return ALGORITHM_STATUS[algo_name]
