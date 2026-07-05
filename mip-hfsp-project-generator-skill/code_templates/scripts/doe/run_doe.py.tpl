"""DOE 实验入口 — scripts/doe/run_doe.py

参数校核实验：因子筛选、参数调优、验证。
"""
from __future__ import annotations

import argparse
import json
import sys
from itertools import product
from pathlib import Path

PROJECT_ROOT = Path(__file__).resolve().parent.parent.parent
sys.path.insert(0, str(PROJECT_ROOT))
sys.path.insert(0, str(Path(__file__).resolve().parent.parent))
from ablation.quick_test_config import get_quick_config, calc_time_limit


def run_doe(algo: str, params: dict, scale: str = "small",
            output_dir: str = "outputs/doe") -> None:
    """运行 DOE 实验。

    Args:
        algo: 算法名称
        params: {param_name: [value1, value2, ...]}
        scale: 算例规模
        output_dir: 输出目录
    """
    from data.loader import load_instance
    config = get_quick_config(scale)
    instance = load_instance(config["instance"])
    time_limit = calc_time_limit(instance.num_jobs, instance.num_stages)

    # 全因子实验
    param_names = list(params.keys())
    param_values = list(params.values())

    results = []
    for combo in product(*param_values):
        param_combo = dict(zip(param_names, combo))
        # 运行算法（具体实现由问题决定）
        # solver = _get_solver(algo)
        # schedule, trace, best_seq = solver(instance, time_limit=time_limit, **param_combo)
        # results.append({**param_combo, "objective": schedule.objective})
        print(f"  Testing {param_combo} ...")
        results.append({**param_combo, "objective": 0.0})  # placeholder

    # 写结果
    out = Path(output_dir) / algo
    out.mkdir(parents=True, exist_ok=True)

    import csv
    with open(out / "doe_results.csv", "w", newline="", encoding="utf-8") as f:
        if results:
            writer = csv.DictWriter(f, fieldnames=results[0].keys())
            writer.writeheader()
            writer.writerows(results)

    print(f"DOE results saved to {out}/doe_results.csv")


def main():
    parser = argparse.ArgumentParser(description="DOE parameter experiment")
    parser.add_argument("--algo", type=str, required=True, help="Algorithm name")
    parser.add_argument("--scale", type=str, default="small", help="Instance scale")
    parser.add_argument("--out", type=str, default="outputs/doe", help="Output directory")
    args = parser.parse_args()

    # 默认参数网格（由具体问题修改）
    default_params = {
        "temperature": [0.1, 0.5, 1.0, 2.0],
        "cooling_rate": [0.95, 0.99, 0.995],
    }

    run_doe(args.algo, default_params, args.scale, args.out)


if __name__ == "__main__":
    main()
