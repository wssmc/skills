"""数据生成入口 — data/generate.py

定义 demo / small / large 三种规模的参数组合，生成算例。
不在算例生成时传入 seed 参数，不写入 index.json 的 seed 字段。
种子管理统一由测试阶段的 data/batch_seeds/ 种子文件控制。

算例命名:
  - demo:  demo_0x_n_m
  - 正式:  inst_xxx_n_m_yy
"""
from __future__ import annotations

import json
import os
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


def write_instance(output_dir: Path, instance_name: str, data: dict, problem_type: str = "HFSP"):
    """将算例数据写入目录，并生成 index.json。"""
    inst_dir = output_dir / instance_name
    inst_dir.mkdir(parents=True, exist_ok=True)

    for filename, content in data.items():
        (inst_dir / filename).write_text(content, encoding="utf-8")

    index = {
        "problem_type": problem_type,
        "data_format": "txt",
        "instance_name": instance_name,
        "files": {f: f for f in data.keys()},
        "objective": {
            "primary": "makespan",
            "secondary": "total_tardiness",
        },
    }
    (inst_dir / "index.json").write_text(
        json.dumps(index, indent=2, ensure_ascii=False), encoding="utf-8"
    )


def generate_all(base_dir: str = "."):
    """生成全部 demo / small / large 算例。"""
    data_root = Path(base_dir) / "data"
    rng = random.Random(42)  # 生成用固定种子，但不在 index.json 中记录

    # demo
    for cfg in DEMO_CONFIGS:
        data = generate_instance(cfg["n_jobs"], cfg["n_stages"], rng)
        write_instance(data_root / "demo", cfg["name"], data)
        print(f"  [demo] {cfg['name']}")

    # small
    for cfg in SMALL_CONFIGS:
        for i in range(cfg["count"]):
            name = f"inst_{i+1:03d}_{cfg['n_jobs']}_{cfg['n_stages']}_{i+1:02d}"
            data = generate_instance(cfg["n_jobs"], cfg["n_stages"], rng)
            write_instance(data_root / "small", name, data)
            print(f"  [small] {name}")

    # large
    for cfg in LARGE_CONFIGS:
        for i in range(cfg["count"]):
            name = f"inst_{i+1:03d}_{cfg['n_jobs']}_{cfg['n_stages']}_{i+1:02d}"
            data = generate_instance(cfg["n_jobs"], cfg["n_stages"], rng)
            write_instance(data_root / "large", name, data)
            print(f"  [large] {name}")


if __name__ == "__main__":
    import sys
    base = sys.argv[1] if len(sys.argv) > 1 else "."
    print(f"Generating instances in {base}/data/ ...")
    generate_all(base)
    print("Done.")
