"""中央调度枢纽 — scripts/run_baselines.py

注册全部算法，解析算例目录，ProcessPoolExecutor 并行调度，统一写产物。

输出（每个 算例 × 算法）:
  {out}/{instance}/{algo}_result.json
  {out}/{instance}/{algo}_schedule.json
  {out}/{instance}/{algo}_trace.csv
  {out}/{instance}/{algo}_gantt.png
"""
from __future__ import annotations

import argparse
import csv
import json
import os
import sys
import time
from concurrent.futures import ProcessPoolExecutor, as_completed
from dataclasses import dataclass
from pathlib import Path

# 确保项目根目录在 path 中
PROJECT_ROOT = Path(__file__).resolve().parent.parent
sys.path.insert(0, str(PROJECT_ROOT))

from data.loader import load_instance
from core.domain import Instance, Result
from metaheuristics.decoding.feasibility_checker import check_feasibility
from metaheuristics.decoding.metrics import evaluate_schedule


# ============================================================
# 1. 算法标识常量
# ============================================================
ALGO_SA_BASIC = "sa_basic"
ALGO_MA_BASIC = "ma_basic"
ALGO_IG_BASIC = "ig_basic"
ALGO_GA_BASIC = "ga_basic"
ALGO_TS_BASIC = "ts_basic"

# ============================================================
# 2. 算法元数据
# ============================================================
@dataclass
class AlgoInfo:
    name: str
    short_name: str
    full_name: str
    zh_name: str
    comment: str

ALGO_INFO = {
    ALGO_SA_BASIC: AlgoInfo("sa_basic", "SA", "Simulated Annealing", "模拟退火", "基础SA"),
    ALGO_MA_BASIC: AlgoInfo("ma_basic", "MA", "Memetic Algorithm", "模因算法", "基础MA"),
    ALGO_IG_BASIC: AlgoInfo("ig_basic", "IG", "Iterated Greedy", "迭代贪心", "基础IG"),
    ALGO_GA_BASIC: AlgoInfo("ga_basic", "GA", "Genetic Algorithm", "遗传算法", "基础GA"),
    ALGO_TS_BASIC: AlgoInfo("ts_basic", "TS", "Tabu Search", "禁忌搜索", "基础TS"),
}

# ============================================================
# 3. 默认参数
# ============================================================
ALGO_DEFAULTS = {
    ALGO_SA_BASIC: {},
    ALGO_MA_BASIC: {},
    ALGO_IG_BASIC: {},
    ALGO_GA_BASIC: {},
    ALGO_TS_BASIC: {},
}

# ============================================================
# 4. solver 函数映射
# ============================================================
def _get_solver(algo: str):
    """从注册表获取算法函数。"""
    from metaheuristics.registry import get_algorithm
    return get_algorithm(algo)

# ============================================================
# 5. 可运行算法列表（从注册表获取）
# ============================================================
from metaheuristics.registry import get_runnable_algorithms, get_algorithm_status
SUPPORTED_ALGOS = tuple(get_runnable_algorithms())


def run_single(instance_dir: str, algo: str, time_limit: float = 30.0,
                seed: int | None = None, output_dir: str = "outputs/single",
                txt_output: bool = False) -> dict:
    """运行单个 算例 × 算法。"""
    instance = load_instance(instance_dir)
    inst_name = Path(instance_dir).name

    solver = _get_solver(algo)
    t0 = time.time()
    # 算法返回 (Schedule, trace, best_seq)
    schedule, trace, best_seq = solver(instance, time_limit=time_limit, seed=seed)
    runtime = time.time() - t0

    # 评估
    evaluate_schedule(instance, schedule)
    violations = check_feasibility(instance, schedule)

    result = Result(
        method=algo,
        status="Feasible" if not violations else "Infeasible",
        objective=schedule.objective,
        makespan=schedule.metrics.get("makespan", schedule.objective),
        runtime=runtime,
        schedule=schedule,
        extra={
            "seed": seed,
            "best_seq": best_seq,  # 保存算法返回的最优编码序列，不从 schedule 反推
            "violations": violations,
            "instance": inst_name,
        },
    )

    # 写产物
    out = Path(output_dir) / inst_name
    out.mkdir(parents=True, exist_ok=True)

    # result.json (不含 best_seq，避免过大)
    (out / f"{algo}_result.json").write_text(json.dumps({
        "method": result.method,
        "status": result.status,
        "objective": result.objective,
        "makespan": result.makespan,
        "runtime": result.runtime,
        "extra": {k: v for k, v in result.extra.items() if k not in ("violations", "best_seq")},
        "violations": violations,
    }, indent=2, ensure_ascii=False), encoding="utf-8")

    # schedule.json
    (out / f"{algo}_schedule.json").write_text(json.dumps(schedule.to_records(), indent=2), encoding="utf-8")

    # trace.csv
    with open(out / f"{algo}_trace.csv", "w", newline="", encoding="utf-8") as f:
        writer = csv.writer(f)
        writer.writerow(["iteration", "time", "objective"])
        for row in trace:
            writer.writerow(row)

    # gantt.png
    try:
        from visualization.gantt import plot_gantt
        plot_gantt(schedule, str(out / f"{algo}_gantt.png"), title=f"{algo} - {inst_name}")
    except Exception:
        pass

    # txt: 保存 best_seq（算法返回的最优编码序列，不从 schedule 反推）
    if txt_output:
        txt_path = out / f"{algo}.txt"
        lines = ["# job_sequence"]
        lines.append(" ".join(str(j) for j in best_seq.get("job_sequence", [])))
        lines.append("# machine_assignment (job_id stage_id machine_id)")
        for (j, s), m in sorted(best_seq.get("machine_assignment", {}).items()):
            lines.append(f"{j} {s} {m}")
        txt_path.write_text("\n".join(lines) + "\n", encoding="utf-8")

    return {
        "instance": inst_name,
        "algo": algo,
        "objective": result.objective,
        "runtime": result.runtime,
        "status": result.status,
        "best_seq": best_seq,
    }


def main():
    parser = argparse.ArgumentParser(description="Central dispatch for all algorithms")
    parser.add_argument("--inst", type=str, required=True, help="Instance directory")
    parser.add_argument("--algo", type=str, required=True, help="Algorithm name")
    parser.add_argument("--time", type=float, default=30.0, help="Time limit (seconds)")
    parser.add_argument("--seed", type=int, default=None, help="Random seed")
    parser.add_argument("--workers", type=int, default=1, help="Parallel workers")
    parser.add_argument("--out", type=str, default="outputs/single", help="Output directory")
    parser.add_argument("--txt", action="store_true", help="Also output txt format")
    parser.add_argument("--verbose", type=int, default=0, help="Verbose level")
    args = parser.parse_args()

    if args.algo not in SUPPORTED_ALGOS:
        print(f"Error: unsupported algorithm '{args.algo}'. Supported: {SUPPORTED_ALGOS}")
        sys.exit(1)

    result = run_single(args.inst, args.algo, args.time, args.seed, args.out, txt_output=args.txt)

    print(f"Cmax: {result['objective']:.4f}")
    print(f"Runtime: {result['runtime']:.2f}s")
    print(f"Status: {result['status']}")
    print(f"Seed: {args.seed}")
    print(f"Instance: {result['instance']}")
    print(f"Algorithm: {result['algo']}")
    if args.txt:
        print(f"Best seq saved to: {args.out}/{result['instance']}/{args.algo}.txt")


if __name__ == "__main__":
    main()
