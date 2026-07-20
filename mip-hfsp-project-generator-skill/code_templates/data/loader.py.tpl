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
    lines = path.read_text(encoding="utf-8").strip().splitlines()
    if not lines or not lines[0].strip():
        raise ValueError(f"Missing header in {path}")
    rows = []
    for line in lines[1:]:  # 跳过表头
        parts = line.strip().split("\t")
        if len(parts) > 1:
            rows.append(parts)
    return rows


def _indexed_file(instance_dir: Path, files: dict, logical_name: str) -> Path:
    value = files.get(logical_name, logical_name)
    if not isinstance(value, str) or not value:
        raise ValueError(f"Invalid file mapping for {logical_name!r}")
    root = instance_dir.resolve()
    path = (root / value).resolve()
    if path.parent != root:
        raise ValueError(f"Indexed file must stay directly inside instance directory: {value}")
    return path


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
    if not isinstance(index, dict):
        raise ValueError(f"index.json must contain an object: {index_path}")
    problem_type = index.get("problem_type", "Unknown")
    files = index.get("files", {})
    if not isinstance(files, dict):
        raise ValueError("index.json field 'files' must be an object")

    inst = Instance(name=instance_dir.name, problem_type=problem_type, metadata=index)

    # --- processing_times.txt ---
    pt_path = _indexed_file(instance_dir, files, "processing_times.txt")
    if not pt_path.exists():
        raise FileNotFoundError(f"Missing required processing time file: {pt_path}")
    rows = _read_txt(pt_path)
    stage_width = None
    for row in rows:
        job_id = int(row[0])
        if job_id in inst.processing_times:
            raise ValueError(f"Duplicate processing-time row for job {job_id}")
        current_width = len(row) - 1
        if current_width <= 0 or (stage_width is not None and current_width != stage_width):
            raise ValueError("Processing-time rows must have the same positive number of stages")
        stage_width = current_width
        inst.processing_times[job_id] = {}
        for s, val in enumerate(row[1:]):
            inst.processing_times[job_id][s] = float(val)
    inst.num_jobs = len(inst.processing_times)
    if inst.num_jobs > 0:
        inst.num_stages = len(next(iter(inst.processing_times.values())))

    # --- stage_machines.txt ---
    sm_path = _indexed_file(instance_dir, files, "stage_machines.txt")
    if not sm_path.exists():
        raise FileNotFoundError(f"Missing required stage machine file: {sm_path}")
    rows = _read_txt(sm_path)
    for row in rows:
        if not row[0].startswith("Stage_"):
            raise ValueError(f"Invalid stage identifier: {row[0]!r}")
        stage_id = int(row[0].replace("Stage_", ""))
        if stage_id in inst.stage_machines:
            raise ValueError(f"Duplicate stage-machine row for stage {stage_id}")
        count = int(row[1])
        inst.stage_machines[stage_id] = list(range(count))

    # --- release_times.txt ---
    rt_path = _indexed_file(instance_dir, files, "release_times.txt")
    if rt_path.exists():
        rows = _read_txt(rt_path)
        for row in rows:
            job_id = int(row[0])
            if job_id in inst.release_times:
                raise ValueError(f"Duplicate release-time row for job {job_id}")
            inst.release_times[job_id] = float(row[1])

    # --- due_dates.txt ---
    dd_path = _indexed_file(instance_dir, files, "due_dates.txt")
    if dd_path.exists():
        rows = _read_txt(dd_path)
        for row in rows:
            job_id = int(row[0])
            if job_id in inst.due_dates:
                raise ValueError(f"Duplicate due-date row for job {job_id}")
            inst.due_dates[job_id] = float(row[1])
            if len(row) > 2:
                inst.due_weights[job_id] = float(row[2])

    errors = inst.validate()
    if errors:
        raise ValueError(f"Invalid instance in {instance_dir}: {errors}")
    return inst
