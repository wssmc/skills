"""统一的单个算例 × 单个算法运行入口。"""
from __future__ import annotations

import argparse
import csv
import json
import math
import sys
import time
from pathlib import Path

PROJECT_ROOT = Path(__file__).resolve().parent.parent
sys.path.insert(0, str(PROJECT_ROOT))
sys.path.insert(0, str(PROJECT_ROOT / "src"))

from data.loader import load_instance
from metaheuristics.decoding.feasibility_checker import check_feasibility
from metaheuristics.decoding.list_decoder import decode
from metaheuristics.decoding.metrics import evaluate_schedule
from metaheuristics.encoding.sequence_encoding import deserialize_machine_assignment
from metaheuristics.registry import get_algorithm, get_runnable_algorithms


SUPPORTED_ALGOS = tuple(get_runnable_algorithms())
POPULATION_ALGOS = {"ga_basic", "ma_basic"}


def resolve_output_dir(output_dir: str | Path) -> Path:
    candidate = Path(output_dir)
    resolved = candidate.resolve() if candidate.is_absolute() else (PROJECT_ROOT / candidate).resolve()
    outputs_root = (PROJECT_ROOT / "outputs").resolve()
    try:
        resolved.relative_to(outputs_root)
    except ValueError as exc:
        raise ValueError(f"Output directory must stay inside project outputs: {resolved}") from exc
    return resolved


def write_json(path: Path, data: dict | list) -> None:
    temporary = path.with_suffix(path.suffix + ".tmp")
    temporary.write_text(
        json.dumps(data, indent=2, ensure_ascii=False, allow_nan=False),
        encoding="utf-8",
    )
    temporary.replace(path)


def run_single(instance_dir: str, algo: str, time_limit: float = 30.0,
               seed: int | None = None, output_dir: str = "outputs/single",
               txt_output: bool = False, **solver_kwargs) -> dict:
    instance = load_instance(instance_dir)
    validation_errors = instance.validate()
    if validation_errors:
        raise ValueError(f"Invalid instance: {validation_errors}")
    if algo not in SUPPORTED_ALGOS:
        raise ValueError(f"Unsupported algorithm '{algo}'. Supported: {SUPPORTED_ALGOS}")

    started = time.perf_counter()
    schedule, trace, best_seq = get_algorithm(algo)(
        instance, time_limit=time_limit, seed=seed, **solver_kwargs
    )
    runtime = time.perf_counter() - started
    evaluate_schedule(instance, schedule)
    violations = check_feasibility(instance, schedule)
    if violations:
        raise RuntimeError(f"Algorithm '{algo}' produced an infeasible schedule: {violations}")
    if not math.isfinite(schedule.objective):
        raise RuntimeError(f"Algorithm '{algo}' produced a non-finite objective")
    assignment = deserialize_machine_assignment(best_seq["machine_assignment"])
    reproduced = decode(best_seq["job_sequence"], assignment, instance)
    evaluate_schedule(instance, reproduced)
    reproduced_violations = check_feasibility(instance, reproduced)
    if reproduced_violations or not math.isclose(
        reproduced.objective, schedule.objective, rel_tol=1e-9, abs_tol=1e-9
    ):
        raise RuntimeError(
            f"Algorithm '{algo}' returned a best_seq that does not reproduce its schedule: "
            f"objective={reproduced.objective}, violations={reproduced_violations}"
        )
    for row in trace:
        if len(row) != 3 or not all(
            isinstance(value, (int, float)) and math.isfinite(value) for value in row
        ):
            raise RuntimeError(f"Algorithm '{algo}' returned an invalid trace row: {row!r}")

    instance_name = Path(instance_dir).name
    out = resolve_output_dir(output_dir) / instance_name
    out.mkdir(parents=True, exist_ok=True)
    result_data = {
        "method": algo,
        "status": "Feasible",
        "objective": schedule.objective,
        "makespan": schedule.metrics["makespan"],
        "runtime": runtime,
        "seed": seed,
        "instance": instance_name,
        "best_seq": best_seq,
        "violations": [],
    }
    write_json(out / f"{algo}_schedule.json", schedule.to_records())

    with (out / f"{algo}_trace.csv").open("w", newline="", encoding="utf-8") as stream:
        writer = csv.writer(stream)
        writer.writerow(["iteration", "time", "objective"])
        writer.writerows(trace)

    from visualization.gantt import plot_gantt
    plot_gantt(schedule, str(out / f"{algo}_gantt.png"), title=f"{algo} - {instance_name}")

    if txt_output:
        lines = ["# job_sequence", " ".join(str(job) for job in best_seq["job_sequence"])]
        lines.append("# machine_assignment (job_id stage_id machine_id)")
        for record in best_seq["machine_assignment"]:
            lines.append(
                f"{record['job_id']} {record['stage_id']} {record['machine_id']}"
            )
        (out / f"{algo}.txt").write_text("\n".join(lines) + "\n", encoding="utf-8")

    # result.json 是任务完成标记，因此在所有必需产物成功后最后原子写入。
    write_json(out / f"{algo}_result.json", result_data)

    return result_data


def select_initialization(algo: str, single_method: str, population_method: str) -> dict:
    if algo in POPULATION_ALGOS:
        if population_method == "random_pop":
            from metaheuristics.initial.population.random_pop import generate_random_population
            return {"population_generator": generate_random_population}
        if population_method == "neh_pop":
            from metaheuristics.initial.population.neh_pop import generate_neh_population
            return {"population_generator": generate_neh_population}
        raise ValueError(f"Unknown population initialization: {population_method}")

    if single_method == "random":
        from metaheuristics.initial.single.random_init import init_random
        return {"init_fn": init_random}
    if single_method == "neh":
        from metaheuristics.initial.single.neh import init_neh
        return {"init_fn": init_neh}
    if single_method in {"spt", "lpt", "edd"}:
        from metaheuristics.initial.single import dispatching
        return {"init_fn": getattr(dispatching, f"init_{single_method}")}
    raise ValueError(f"Unknown single-solution initialization: {single_method}")


def main() -> None:
    parser = argparse.ArgumentParser(description="Run one HFSP algorithm on one instance")
    parser.add_argument("--inst", required=True, help="Instance directory")
    parser.add_argument("--algo", required=True, choices=SUPPORTED_ALGOS)
    parser.add_argument("--time", type=float, default=30.0)
    parser.add_argument("--seed", type=int, default=0)
    parser.add_argument("--out", default="outputs/single")
    parser.add_argument("--txt", action="store_true")
    parser.add_argument("--verbose", type=int, choices=(0, 1, 2), default=1)
    parser.add_argument("--unified-init", action="store_true")
    parser.add_argument("--init-method-single", default="neh")
    parser.add_argument("--init-method-pop", default="neh_pop")
    args = parser.parse_args()

    solver_kwargs = {"verbose": args.verbose}
    if args.unified_init:
        solver_kwargs.update(
            select_initialization(args.algo, args.init_method_single, args.init_method_pop)
        )
    result = run_single(
        args.inst,
        args.algo,
        args.time,
        args.seed,
        args.out,
        txt_output=args.txt,
        **solver_kwargs,
    )
    print(
        f"{result['instance']} x {result['method']}: "
        f"objective={result['objective']:.4f}, runtime={result['runtime']:.2f}s"
    )


if __name__ == "__main__":
    main()
