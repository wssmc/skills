"""Summarize C++ and CPLEX result artifacts without recomputing objectives."""
from __future__ import annotations

import argparse
import csv
import json
from pathlib import Path


FIELDS = [
    "file",
    "instance_id",
    "instance_seed",
    "algorithm",
    "round",
    "solve_seed",
    "status",
    "objective",
    "runtime_seconds",
    "feasible",
]


def collect_results(root: Path) -> list[dict[str, object]]:
    rows: list[dict[str, object]] = []
    seen_runs: set[tuple[object, object, object]] = set()
    for path in sorted(root.rglob("result.json")):
        payload = json.loads(path.read_text(encoding="utf-8"))
        required = {
            "instance_id",
            "instance_seed",
            "algorithm",
            "round",
            "solve_seed",
            "objective",
            "runtime_seconds",
            "feasible",
        }
        missing = sorted(required - payload.keys())
        if missing:
            raise ValueError(f"{path} is missing fields: {', '.join(missing)}")
        key = (payload["instance_id"], payload["algorithm"], payload["round"])
        if key in seen_runs:
            raise ValueError(f"duplicate instance/algorithm/round: {key}")
        seen_runs.add(key)
        rows.append({"file": str(path.relative_to(root)), **{key: payload.get(key) for key in FIELDS[1:]}})
    return rows


def write_summary(rows: list[dict[str, object]], output: Path) -> None:
    output.parent.mkdir(parents=True, exist_ok=True)
    with output.open("w", encoding="utf-8", newline="") as handle:
        writer = csv.DictWriter(handle, fieldnames=FIELDS)
        writer.writeheader()
        writer.writerows(rows)


def main() -> None:
    parser = argparse.ArgumentParser(description="Summarize C++ research results")
    parser.add_argument("--input", type=Path, required=True)
    parser.add_argument("--output", type=Path, required=True)
    args = parser.parse_args()
    if not args.input.is_dir():
        raise SystemExit(f"result directory does not exist: {args.input}")
    rows = collect_results(args.input)
    if not rows:
        raise SystemExit(f"no result.json files found under {args.input}")
    write_summary(rows, args.output)


if __name__ == "__main__":
    main()
