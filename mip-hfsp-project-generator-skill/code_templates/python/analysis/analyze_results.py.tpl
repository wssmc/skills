"""辅助分析工具：读取 C++ 求解器写出的 JSON/CSV，不实现调度算法。"""
from __future__ import annotations

import argparse
import csv
import json
from pathlib import Path


def collect_results(root: Path) -> list[dict[str, object]]:
    rows: list[dict[str, object]] = []
    for path in sorted(root.rglob("*_result.json")):
        payload = json.loads(path.read_text(encoding="utf-8"))
        rows.append(
            {
                "file": str(path.relative_to(root)),
                "algorithm": payload.get("algorithm", ""),
                "objective": payload.get("objective"),
                "runtime_seconds": payload.get("runtime_seconds"),
                "feasible": payload.get("feasible"),
            }
        )
    return rows


def write_summary(rows: list[dict[str, object]], output: Path) -> None:
    output.parent.mkdir(parents=True, exist_ok=True)
    with output.open("w", encoding="utf-8", newline="") as handle:
        writer = csv.DictWriter(
            handle,
            fieldnames=["file", "algorithm", "objective", "runtime_seconds", "feasible"],
        )
        writer.writeheader()
        writer.writerows(rows)


def main() -> None:
    parser = argparse.ArgumentParser(description="Summarize C++ HFSP result artifacts")
    parser.add_argument("--input", type=Path, required=True)
    parser.add_argument("--output", type=Path, required=True)
    args = parser.parse_args()
    if not args.input.is_dir():
        raise SystemExit(f"result directory does not exist: {args.input}")
    rows = collect_results(args.input)
    if not rows:
        raise SystemExit(f"no *_result.json files found under {args.input}")
    write_summary(rows, args.output)


if __name__ == "__main__":
    main()
