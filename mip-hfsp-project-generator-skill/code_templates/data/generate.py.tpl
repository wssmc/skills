"""数据生成入口 — data/generate.py

定义 demo / small / large 三种规模的参数组合，生成算例。
算例生成使用独立的 instance_seed，并写入 index.json 以支持精确再生成。
算法运行种子仍由 data/batch_seeds/ 管理，两类种子不得混用。

算例命名:
  - demo:  demo_0x_n_m
  - 正式:  inst_xxx_n_m_yy
"""
from __future__ import annotations

import json
import random
from pathlib import Path


# ============================================================
# 规模参数定义（由具体问题修改）
# ============================================================

DEMO_CONFIGS = [
    {"n_jobs": 10, "n_stages": 5, "name": "demo_01_10_5"},
]

SMALL_CONFIGS = [
    {"n_jobs": 10, "n_stages": 5, "count": 10},   # inst_001_10_5_01 ~ inst_010_10_5_10
    {"n_jobs": 20, "n_stages": 5, "count": 10},
    {"n_jobs": 30, "n_stages": 5, "count": 10},
]

LARGE_CONFIGS = [
    {"n_jobs": 50, "n_stages": 5, "count": 10},
    {"n_jobs": 100, "n_stages": 5, "count": 10},
    {"n_jobs": 200, "n_stages": 5, "count": 10},
]


def generate_instance(n_jobs: int, n_stages: int, rng: random.Random) -> dict:
    """生成单个算例的数据。

    返回字典，包含各 txt 文件的内容。
    由具体问题实现具体的生成逻辑。
    """
    if n_jobs <= 0 or n_stages <= 0:
        raise ValueError("n_jobs and n_stages must be positive")

    # --- processing_times.txt ---
    # JobID  Stage_0  Stage_1  ...  Stage_{n_stages-1}
    pt_lines = ["JobID\t" + "\t".join(f"Stage_{s}" for s in range(n_stages))]
    for j in range(n_jobs):
        times = [round(rng.uniform(0.1, 2.0), 2) for _ in range(n_stages)]
        pt_lines.append(f"{j}\t" + "\t".join(str(t) for t in times))

    # --- stage_machines.txt ---
    # StageID  MachineCount
    sm_lines = ["StageID\tMachineCount"]
    for s in range(n_stages):
        sm_lines.append(f"Stage_{s}\t{rng.randint(2, 5)}")

    # --- release_times.txt ---
    rt_lines = ["JobID\tReleaseTime"]
    for j in range(n_jobs):
        rt_lines.append(f"{j}\t0.0")

    # --- due_dates.txt ---
    dd_lines = ["JobID\tDueDate\tWeight"]
    for j in range(n_jobs):
        due = round(rng.uniform(n_stages * 2, n_stages * 4), 2)
        dd_lines.append(f"{j}\t{due}\t1.0")

    return {
        "processing_times.txt": "\n".join(pt_lines) + "\n",
        "stage_machines.txt": "\n".join(sm_lines) + "\n",
        "release_times.txt": "\n".join(rt_lines) + "\n",
        "due_dates.txt": "\n".join(dd_lines) + "\n",
    }


def write_instance(output_dir: Path, instance_name: str, data: dict,
                   instance_seed: int, problem_type: str = "HFSP"):
    """将算例数据写入目录，并生成 index.json。"""
    if not instance_name or Path(instance_name).name != instance_name:
        raise ValueError("instance_name must be a single safe path component")
    inst_dir = output_dir / instance_name
    inst_dir.mkdir(parents=True, exist_ok=True)

    for filename, content in data.items():
        (inst_dir / filename).write_text(content, encoding="utf-8")

    index = {
        "problem_type": problem_type,
        "data_format": "txt",
        "instance_name": instance_name,
        "instance_seed": instance_seed,
        "files": {f: f for f in data.keys()},
        "objective": {
            "primary": "makespan",
        },
    }
    (inst_dir / "index.json").write_text(
        json.dumps(index, indent=2, ensure_ascii=False), encoding="utf-8"
    )


def generate_all(base_dir: str = ".", master_seed: int = 42):
    """生成全部 demo / small / large 算例。"""
    data_root = Path(base_dir) / "data"
    seed_rng = random.Random(master_seed)

    def generate_named(output_dir: Path, name: str, n_jobs: int, n_stages: int) -> None:
        instance_seed = seed_rng.randint(0, 2**32 - 1)
        data = generate_instance(n_jobs, n_stages, random.Random(instance_seed))
        write_instance(output_dir, name, data, instance_seed)

    # demo
    for cfg in DEMO_CONFIGS:
        generate_named(data_root / "demo", cfg["name"], cfg["n_jobs"], cfg["n_stages"])
        print(f"  [demo] {cfg['name']}")

    # small
    for cfg in SMALL_CONFIGS:
        for i in range(cfg["count"]):
            name = f"inst_{i+1:03d}_{cfg['n_jobs']}_{cfg['n_stages']}_{i+1:02d}"
            generate_named(data_root / "small", name, cfg["n_jobs"], cfg["n_stages"])
            print(f"  [small] {name}")

    # large
    for cfg in LARGE_CONFIGS:
        for i in range(cfg["count"]):
            name = f"inst_{i+1:03d}_{cfg['n_jobs']}_{cfg['n_stages']}_{i+1:02d}"
            generate_named(data_root / "large", name, cfg["n_jobs"], cfg["n_stages"])
            print(f"  [large] {name}")


if __name__ == "__main__":
    import argparse
    parser = argparse.ArgumentParser(description="Generate reproducible HFSP instances")
    parser.add_argument("--base-dir", default=".")
    parser.add_argument("--master-seed", type=int, default=42)
    args = parser.parse_args()
    print(f"Generating instances in {args.base_dir}/data/ ...")
    generate_all(args.base_dir, args.master_seed)
    print("Done.")
