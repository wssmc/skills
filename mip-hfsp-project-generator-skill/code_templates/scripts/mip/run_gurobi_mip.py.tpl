"""Gurobi MIP 精确求解 — scripts/mip/run_gurobi_mip.py

独立入口，不走 run_baselines.py。
输出 LB + 最优可行解，默认时限 60s（小规模测试）。
结果必须经过 check_feasibility 校核。

输出:
  outputs/mip/{mip_batch_name}/{instance}/
    result.json   (status, objective, LB, gap, runtime, violations)
    schedule.csv  (仅有解时)
    gantt.png     (仅有解时)
"""
from __future__ import annotations

import argparse
import csv
import json
import math
import sys
from pathlib import Path

PROJECT_ROOT = Path(__file__).resolve().parent.parent.parent
sys.path[:0] = [str(PROJECT_ROOT), str(PROJECT_ROOT / "src")]

from data.loader import load_instance
from math_models.gurobi_model import build_and_solve
from metaheuristics.decoding.feasibility_checker import check_feasibility


def main():
    parser = argparse.ArgumentParser(description="Gurobi MIP solver")
    parser.add_argument("--inst", type=str, required=True, help="Instance directory")
    parser.add_argument("--time", type=float, default=60.0, help="Time limit (seconds)")
    parser.add_argument("--gap", type=float, default=0.001, help="MIP gap")
    parser.add_argument("--threads", type=int, default=0, help="Threads (0=auto)")
    parser.add_argument("--out", type=str, default="outputs/mip", help="Output directory")
    parser.add_argument("--log", type=int, default=1, help="Log output (1=yes, 0=no)")
    args = parser.parse_args()

    instance = load_instance(args.inst)
    inst_name = Path(args.inst).name

    print(f"Solving {inst_name} with Gurobi MIP (time_limit={args.time}s)...")
    result = build_and_solve(
        instance,
        time_limit=args.time,
        mip_gap=args.gap,
        threads=args.threads,
        log_output=bool(args.log),
    )
    if result.status == "Error":
        raise RuntimeError(result.extra.get("error", "Gurobi solve failed"))

    # 校核
    violations = []
    if result.schedule.operations:
        violations = check_feasibility(instance, result.schedule)
        if violations:
            raise RuntimeError(f"MIP returned an infeasible schedule: {violations}")

    # 写产物
    outputs_root = (PROJECT_ROOT / "outputs").resolve()
    out_base = (PROJECT_ROOT / args.out).resolve()
    if out_base != outputs_root and outputs_root not in out_base.parents:
        raise ValueError("Output directory must stay inside the project outputs directory")
    out_dir = out_base / inst_name
    out_dir.mkdir(parents=True, exist_ok=True)

    def finite_or_none(value):
        return value if isinstance(value, (int, float)) and math.isfinite(value) else None

    result_data = {
        "method": "MIP",
        "status": result.status,
        "objective": finite_or_none(result.objective),
        "makespan": finite_or_none(result.makespan),
        "LB": finite_or_none(result.extra.get("LB", float("inf"))),
        "gap": finite_or_none(result.extra.get("gap")),
        "runtime": result.runtime,
        "violations": violations,
        "instance": inst_name,
    }
    # schedule.csv
    if result.schedule.operations:
        with open(out_dir / "schedule.csv", "w", newline="", encoding="utf-8") as f:
            writer = csv.writer(f)
            writer.writerow(["job_id", "stage_id", "machine_id", "start", "end", "processing_time"])
            for op in result.schedule.operations:
                writer.writerow([op.job_id, op.stage_id, op.machine_id, op.start, op.end, op.processing_time])

        from visualization.gantt import plot_gantt
        plot_gantt(result.schedule, str(out_dir / "gantt.png"), title=f"MIP - {inst_name}")

    temporary_result = out_dir / "result.json.tmp"
    temporary_result.write_text(
        json.dumps(result_data, indent=2, ensure_ascii=False, allow_nan=False), encoding="utf-8"
    )
    temporary_result.replace(out_dir / "result.json")

    print(f"\nResult:")
    print(f"  Status: {result.status}")
    objective_text = f"{result.objective:.4f}" if math.isfinite(result.objective) else "N/A"
    gap = result.extra.get("gap")
    gap_text = f"{gap:.4%}" if isinstance(gap, (int, float)) and math.isfinite(gap) else "N/A"
    print(f"  Objective: {objective_text}")
    print(f"  LB: {result.extra.get('LB', 'N/A')}")
    print(f"  Gap: {gap_text}")
    print(f"  Runtime: {result.runtime:.2f}s")
    print(f"  Violations: {len(violations)}")
    print(f"  Output: {out_dir}")


if __name__ == "__main__":
    main()
