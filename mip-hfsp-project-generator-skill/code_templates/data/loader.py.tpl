"""数据读取 — data/loader.py

统一接口: load_instance(dir) -> Instance
从算例目录读取所有 txt 文件 + index.json，构建 Instance 对象。
"""
from __future__ import annotations

import json
from pathlib import Path

import sys
sys.path.insert(0, str(Path(__file__).resolve().parent.parent / "src"))
from core.domain import Instance


def _read_txt(path: Path) -> list[list[str]]:
    """读取 tab 分隔的 txt 文件，返回二维列表（去掉表头后的数据行）。"""
    lines = path.read_text(encoding="utf-8").strip().split("\n")
    rows = []
    for line in lines[1:]:  # 跳过表头
        parts = line.strip().split("\t")
        if len(parts) > 1:
            rows.append(parts)
    return rows


def load_instance(instance_dir: str | Path) -> Instance:
    """从算例目录加载 Instance。

    Args:
        instance_dir: 算例目录路径（包含 index.json 和 txt 文件）

    Returns:
        Instance 对象
    """
    instance_dir = Path(instance_dir)
    index_path = instance_dir / "index.json"
    if not index_path.exists():
        raise FileNotFoundError(f"index.json not found in {instance_dir}")

    index = json.loads(index_path.read_text(encoding="utf-8"))
    problem_type = index.get("problem_type", "Unknown")
    files = index.get("files", {})

    inst = Instance(name=instance_dir.name, problem_type=problem_type)

    # --- processing_times.txt ---
    pt_path = instance_dir / files.get("processing_times.txt", "processing_times.txt")
    if pt_path.exists():
        rows = _read_txt(pt_path)
        for row in rows:
            job_id = int(row[0])
            if job_id not in inst.processing_times:
                inst.processing_times[job_id] = {}
            for s, val in enumerate(row[1:]):
                inst.processing_times[job_id][s] = float(val)
        inst.num_jobs = len(inst.processing_times)
        if inst.num_jobs > 0:
            inst.num_stages = len(next(iter(inst.processing_times.values())))

    # --- stage_machines.txt ---
    sm_path = instance_dir / files.get("stage_machines.txt", "stage_machines.txt")
    if sm_path.exists():
        rows = _read_txt(sm_path)
        for row in rows:
            stage_id = int(row[0].replace("Stage_", ""))
            count = int(row[1])
            inst.stage_machines[stage_id] = list(range(count))

    # --- release_times.txt ---
    rt_path = instance_dir / files.get("release_times.txt", "release_times.txt")
    if rt_path.exists():
        rows = _read_txt(rt_path)
        for row in rows:
            inst.release_times[int(row[0])] = float(row[1])

    # --- due_dates.txt ---
    dd_path = instance_dir / files.get("due_dates.txt", "due_dates.txt")
    if dd_path.exists():
        rows = _read_txt(dd_path)
        for row in rows:
            inst.due_dates[int(row[0])] = float(row[1])
            if len(row) > 2:
                inst.due_weights[int(row[0])] = float(row[2])

    return inst
