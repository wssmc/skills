"""辅助算例生成工具；求解、解码和可行性检查必须留在 C++ 核心。"""
from __future__ import annotations

import argparse
import random
from pathlib import Path


def generate_instance(output: Path, jobs: int, stages: int, seed: int) -> None:
    rng = random.Random(seed)
    output.mkdir(parents=True, exist_ok=True)
    machine_lines = ["StageID\tMachineCount"]
    machine_lines.extend(f"Stage_{stage}\t2" for stage in range(stages))
    (output / "stage_machines.txt").write_text("\n".join(machine_lines) + "\n", encoding="utf-8")
    header = "JobID\t" + "\t".join(f"Stage_{stage}" for stage in range(stages))
    rows = [
        str(job) + "\t" + "\t".join(str(rng.randint(1, 9)) for _ in range(stages))
        for job in range(jobs)
    ]
    (output / "processing_times.txt").write_text(header + "\n" + "\n".join(rows) + "\n", encoding="utf-8")


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("--output", type=Path, required=True)
    parser.add_argument("--jobs", type=int, default=10)
    parser.add_argument("--stages", type=int, default=5)
    parser.add_argument("--seed", type=int, default=42)
    args = parser.parse_args()
    generate_instance(args.output, args.jobs, args.stages, args.seed)


if __name__ == "__main__":
    main()
