"""Solve the reference flow-shop MIP with IBM's low-level CPLEX Python API."""
from __future__ import annotations

import argparse
import csv
import json
import math
import os
import time
from dataclasses import dataclass
from pathlib import Path

import cplex
from cplex.exceptions import CplexError


@dataclass(frozen=True)
class Instance:
    instance_id: str
    instance_seed: int
    processing_times: list[list[float]]
    machines_per_stage: list[int]


def _numeric_rows(path: Path) -> list[list[float]]:
    rows: list[list[float]] = []
    for raw in path.read_text(encoding="utf-8").splitlines():
        tokens = raw.split()
        if not tokens:
            continue
        try:
            rows.append([float(token) for token in tokens])
        except ValueError:
            continue  # one header row is allowed
    if not rows:
        raise ValueError(f"no numeric data in {path}")
    return rows


def _last_integer_values(path: Path) -> list[int]:
    values: list[int] = []
    for raw in path.read_text(encoding="utf-8").splitlines():
        tokens = raw.split()
        if not tokens:
            continue
        try:
            value = int(tokens[-1])
        except ValueError:
            continue  # one header row is allowed
        values.append(value)
    if not values:
        raise ValueError(f"no integer data in {path}")
    return values


def load_instance(directory: Path) -> Instance:
    seed = int((directory / "instance_seed.txt").read_text(encoding="utf-8").strip())
    machines = _last_integer_values(directory / "stage_machines.txt")
    processing_rows = _numeric_rows(directory / "processing_times.txt")
    processing = [row[1:] for row in processing_rows]
    if not processing or not machines or any(len(row) != len(machines) for row in processing):
        raise ValueError("processing-time dimensions do not match stages")
    if any(value <= 0 or not math.isfinite(value) for row in processing for value in row):
        raise ValueError("processing times must be finite and positive")
    if any(count <= 0 for count in machines):
        raise ValueError("machine counts must be positive")
    return Instance(directory.name, seed, processing, machines)


def add_constraint(
    model: cplex.Cplex,
    indices: list[int],
    values: list[float],
    sense: str,
    rhs: float,
    name: str,
) -> None:
    model.linear_constraints.add(
        lin_expr=[cplex.SparsePair(ind=indices, val=values)],
        senses=[sense],
        rhs=[rhs],
        names=[name],
    )


def solve(instance: Instance, solve_seed: int, round_id: int, time_limit: float) -> dict[str, object]:
    model = cplex.Cplex()
    model.objective.set_sense(model.objective.sense.minimize)
    jobs = range(len(instance.processing_times))
    stages = range(len(instance.machines_per_stage))
    horizon = sum(sum(row) for row in instance.processing_times)

    start: dict[tuple[int, int], int] = {}
    assigned: dict[tuple[int, int, int], int] = {}
    ordered: dict[tuple[int, int, int, int], int] = {}

    for job in jobs:
        for stage in stages:
            name = f"start_{job}_{stage}"
            model.variables.add(names=[name], lb=[0.0], types=[model.variables.type.continuous])
            start[job, stage] = model.variables.get_num() - 1
            for machine in range(instance.machines_per_stage[stage]):
                name = f"assign_{job}_{stage}_{machine}"
                model.variables.add(names=[name], types=[model.variables.type.binary])
                assigned[job, stage, machine] = model.variables.get_num() - 1

    for first in jobs:
        for second in range(first + 1, len(instance.processing_times)):
            for stage in stages:
                for machine in range(instance.machines_per_stage[stage]):
                    name = f"order_{first}_{second}_{stage}_{machine}"
                    model.variables.add(names=[name], types=[model.variables.type.binary])
                    ordered[first, second, stage, machine] = model.variables.get_num() - 1

    model.variables.add(
        obj=[1.0], names=["makespan"], lb=[0.0], types=[model.variables.type.continuous]
    )
    makespan = model.variables.get_num() - 1

    for job in jobs:
        for stage in stages:
            machine_vars = [
                assigned[job, stage, machine]
                for machine in range(instance.machines_per_stage[stage])
            ]
            add_constraint(model, machine_vars, [1.0] * len(machine_vars), "E", 1.0, f"assign_once_{job}_{stage}")
        for stage in range(len(instance.machines_per_stage) - 1):
            add_constraint(
                model,
                [start[job, stage + 1], start[job, stage]],
                [1.0, -1.0],
                "G",
                instance.processing_times[job][stage],
                f"precedence_{job}_{stage}",
            )
        last = len(instance.machines_per_stage) - 1
        add_constraint(
            model,
            [makespan, start[job, last]],
            [1.0, -1.0],
            "G",
            instance.processing_times[job][last],
            f"makespan_{job}",
        )

    for first in jobs:
        for second in range(first + 1, len(instance.processing_times)):
            for stage in stages:
                for machine in range(instance.machines_per_stage[stage]):
                    first_x = assigned[first, stage, machine]
                    second_x = assigned[second, stage, machine]
                    order = ordered[first, second, stage, machine]
                    add_constraint(
                        model,
                        [start[second, stage], start[first, stage], first_x, second_x, order],
                        [1.0, -1.0, -horizon, -horizon, -horizon],
                        "G",
                        instance.processing_times[first][stage] - 3.0 * horizon,
                        f"no_overlap_forward_{first}_{second}_{stage}_{machine}",
                    )
                    add_constraint(
                        model,
                        [start[first, stage], start[second, stage], first_x, second_x, order],
                        [1.0, -1.0, -horizon, -horizon, horizon],
                        "G",
                        instance.processing_times[second][stage] - 2.0 * horizon,
                        f"no_overlap_reverse_{first}_{second}_{stage}_{machine}",
                    )

    model.parameters.timelimit.set(time_limit)
    model.parameters.threads.set(1)
    model.parameters.randomseed.set(solve_seed)
    model.parameters.parallel.set(model.parameters.parallel.values.deterministic)

    started = time.perf_counter()
    model.solve()
    runtime = time.perf_counter() - started
    feasible = model.solution.is_primal_feasible()
    status = model.solution.get_status_string()
    objective = model.solution.get_objective_value() if feasible else None
    best_bound = model.solution.MIP.get_best_objective() if feasible else None
    relative_gap = model.solution.MIP.get_mip_relative_gap() if feasible else None
    operations: list[dict[str, int | float]] = []
    sequence: list[int] = []
    if feasible:
        sequence = sorted(jobs, key=lambda job: model.solution.get_values(start[job, 0]))
        for job in jobs:
            for stage in stages:
                machine = max(
                    range(instance.machines_per_stage[stage]),
                    key=lambda item: model.solution.get_values(assigned[job, stage, item]),
                )
                begin = model.solution.get_values(start[job, stage])
                operations.append(
                    {
                        "job_id": job,
                        "stage_id": stage,
                        "machine_id": machine,
                        "start": begin,
                        "end": begin + instance.processing_times[job][stage],
                    }
                )
    return {
        "result": {
            "instance_id": instance.instance_id,
            "instance_seed": instance.instance_seed,
            "algorithm": "cplex_mip_python",
            "round": round_id,
            "solve_seed": solve_seed,
            "objective": objective,
            "runtime_seconds": runtime,
            "feasible": feasible,
            "status": status,
            "best_bound": best_bound,
            "relative_gap": relative_gap,
        },
        "solution": {"job_sequence": sequence, "operations": operations},
    }


def write_outputs(payload: dict[str, object], output: Path) -> None:
    output.mkdir(parents=True, exist_ok=True)
    result = payload["result"]
    solution = payload["solution"]
    assert isinstance(result, dict) and isinstance(solution, dict)
    (output / "result.json").write_text(
        json.dumps(result, ensure_ascii=False, indent=2) + "\n", encoding="utf-8"
    )
    (output / "solution.json").write_text(
        json.dumps(solution, ensure_ascii=False, indent=2) + "\n", encoding="utf-8"
    )
    with (output / "schedule.csv").open("w", encoding="utf-8", newline="") as stream:
        writer = csv.DictWriter(stream, fieldnames=["job_id", "stage_id", "machine_id", "start", "end"])
        writer.writeheader()
        writer.writerows(solution["operations"])
    (output / "trace.csv").write_text("iteration,elapsed_seconds,objective\n", encoding="utf-8")


def output_root() -> Path:
    root = Path(os.environ.get("SCHED_OUTPUT_ROOT", "outputs/tmp/unclassified"))
    if root.is_absolute() or not root.parts or root.parts[0] != "outputs" or ".." in root.parts:
        raise ValueError("SCHED_OUTPUT_ROOT must be a relative path under outputs/")
    return root


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("--instance", type=Path, required=True)
    parser.add_argument("--solve-seed", type=int, required=True)
    parser.add_argument("--round", type=int, required=True, dest="round_id")
    parser.add_argument("--time-limit", type=float, default=3600.0)
    args = parser.parse_args()
    if args.solve_seed < 0 or args.round_id <= 0 or args.time_limit <= 0:
        parser.error("solve seed must be non-negative; round and time limit must be positive")
    instance = load_instance(args.instance)
    output = (
        output_root()
        / instance.instance_id
        / "cplex_mip_python"
        / f"round_{args.round_id}_seed_{args.solve_seed}"
    )
    try:
        write_outputs(solve(instance, args.solve_seed, args.round_id, args.time_limit), output)
    except CplexError as error:
        raise SystemExit(f"CPLEX Python API error: {error}") from error


if __name__ == "__main__":
    main()
