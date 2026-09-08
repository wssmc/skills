"""Generate reference flow-shop instances with an explicit, recorded seed."""
from __future__ import annotations

import argparse
import json
import random
from pathlib import Path


def generate_instance(output: Path, jobs: int, stages: int, instance_seed: int) -> None:
    if jobs <= 0 or stages <= 0:
        raise ValueError("jobs and stages must be positive")
    if instance_seed < 0:
        raise ValueError("instance_seed must be non-negative")
    rng = random.Random(instance_seed)
    output.mkdir(parents=True, exist_ok=True)

    machine_lines = ["StageID\tMachineCount"]
    machine_lines.extend(f"Stage_{stage}\t2" for stage in range(stages))
    (output / "stage_machines.txt").write_text(
        "\n".join(machine_lines) + "\n", encoding="utf-8"
    )

    header = "JobID\t" + "\t".join(f"Stage_{stage}" for stage in range(stages))
    rows = [
        str(job) + "\t" + "\t".join(str(rng.randint(1, 99)) for _ in range(stages))
        for job in range(jobs)
    ]
    (output / "processing_times.txt").write_text(
        header + "\n" + "\n".join(rows) + "\n", encoding="utf-8"
    )
    (output / "instance_seed.txt").write_text(
        f"{instance_seed}\n", encoding="utf-8"
    )
    metadata = {
        "instance_id": output.name,
        "problem_family": "flow_shop_reference",
        "jobs": jobs,
        "stages": stages,
        "instance_seed": instance_seed,
        "files": [
            "processing_times.txt",
            "stage_machines.txt",
            "instance_seed.txt",
        ],
    }
    (output / "index.json").write_text(
        json.dumps(metadata, ensure_ascii=False, indent=2) + "\n",
        encoding="utf-8",
    )


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("--output", type=Path, required=True)
    parser.add_argument("--jobs", type=int, required=True)
    parser.add_argument("--stages", type=int, required=True)
    parser.add_argument("--seed", type=int, required=True, dest="instance_seed")
    args = parser.parse_args()
    generate_instance(args.output, args.jobs, args.stages, args.instance_seed)


if __name__ == "__main__":
    main()
