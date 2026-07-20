"""可运行的 SA 全因子参数实验。"""
from __future__ import annotations

import argparse
import csv
import json
import sys
import time
from itertools import product
from pathlib import Path

PROJECT_ROOT = Path(__file__).resolve().parent.parent.parent
sys.path[:0] = [str(PROJECT_ROOT), str(PROJECT_ROOT / "src")]

from data.loader import load_instance
from metaheuristics.decoding.feasibility_checker import check_feasibility
from metaheuristics.registry import get_algorithm
from scripts.ablation.quick_test_config import calc_time_limit, get_quick_config


SUPPORTED_GRIDS = {
    "sa_basic": {
        "initial_temperature_multiplier": [5.0, 10.0, 20.0],
        "cooling_rate": [0.99, 0.995],
    }
}


def _output_dir(relative: str, algo: str) -> Path:
    candidate = (PROJECT_ROOT / relative / algo).resolve()
    outputs = (PROJECT_ROOT / "outputs").resolve()
    if candidate != outputs and outputs not in candidate.parents:
        raise ValueError("DOE output must stay inside the project outputs directory")
    candidate.mkdir(parents=True, exist_ok=True)
    return candidate


def run_doe(algo: str, params: dict[str, list], scale: str = "small",
            output_dir: str = "outputs/doe") -> Path:
    if algo not in SUPPORTED_GRIDS:
        raise ValueError(
            f"No tested DOE parameter adapter for {algo!r}; supported={sorted(SUPPORTED_GRIDS)}"
        )
    if not params or any(not values for values in params.values()):
        raise ValueError("Every DOE factor must contain at least one value")
    unsupported = set(params) - set(SUPPORTED_GRIDS[algo])
    if unsupported:
        raise ValueError(f"Unsupported DOE factors for {algo}: {sorted(unsupported)}")

    config = get_quick_config(scale)
    instance = load_instance(config["instance"])
    time_limit = max(0.01, calc_time_limit(instance.num_jobs, instance.num_stages))
    solver = get_algorithm(algo)
    names = list(params)
    rows: list[dict] = []

    for values in product(*(params[name] for name in names)):
        combination = dict(zip(names, values))
        for seed in config["seeds"]:
            started = time.perf_counter()
            schedule, _, _ = solver(
                instance, time_limit=time_limit, seed=seed, verbose=0, **combination
            )
            violations = check_feasibility(instance, schedule)
            if violations:
                raise RuntimeError(f"DOE produced an infeasible schedule: {violations}")
            rows.append({
                **combination,
                "seed": seed,
                "objective": schedule.objective,
                "runtime": time.perf_counter() - started,
            })

    out = _output_dir(output_dir, algo)
    result_path = out / "doe_results.csv"
    with result_path.open("w", newline="", encoding="utf-8") as stream:
        writer = csv.DictWriter(stream, fieldnames=list(rows[0]))
        writer.writeheader()
        writer.writerows(rows)
    metadata = {"algorithm": algo, "scale": scale, "factors": params, "runs": len(rows)}
    (out / "doe_metadata.json").write_text(
        json.dumps(metadata, indent=2, allow_nan=False), encoding="utf-8"
    )
    return result_path


def main() -> None:
    parser = argparse.ArgumentParser(description="Tested SA full-factor parameter experiment")
    parser.add_argument("--algo", default="sa_basic", choices=sorted(SUPPORTED_GRIDS))
    parser.add_argument("--scale", default="small", choices=["small", "large"])
    parser.add_argument("--out", default="outputs/doe")
    args = parser.parse_args()
    path = run_doe(args.algo, SUPPORTED_GRIDS[args.algo], args.scale, args.out)
    print(f"DOE results saved to {path}")


if __name__ == "__main__":
    main()
