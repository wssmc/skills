"""结果复现 — src/metaheuristics/decoding/result_reproducer.py

从 txt 文件中的 best_seq 复现目标值，并校验约束条件。
txt 保存的是算法返回的 best_seq（编码序列），不是从 schedule 反推的结果。
复现结果必须与原始结果一致。
"""
from __future__ import annotations

from pathlib import Path

import sys
sys.path.insert(0, str(__import__("pathlib").Path(__file__).resolve().parent.parent.parent))
from core.domain import Instance, Schedule
from metaheuristics.decoding.list_decoder import decode
from metaheuristics.decoding.metrics import evaluate_schedule
from metaheuristics.decoding.feasibility_checker import check_feasibility
from metaheuristics.encoding.sequence_encoding import deserialize_machine_assignment


def parse_txt(txt_path: str) -> dict:
    """解析 txt 文件中的 best_seq。

    txt 文件格式:
        # job_sequence
        0 3 1 2 4 5 6 7 8 9
        # machine_assignment (job_id stage_id machine_id)
        0 0 1
        0 1 0
        ...

    Returns:
        {"job_sequence": [...], "machine_assignment": [{job_id, stage_id, machine_id}, ...]}
    """
    lines = Path(txt_path).read_text(encoding="utf-8").strip().split("\n")

    job_sequence = []
    machine_assignment = []

    section = None
    for line in lines:
        line = line.strip()
        if not line:
            continue
        if line.startswith("#"):
            if "job_sequence" in line:
                section = "seq"
            elif "machine_assignment" in line:
                section = "assign"
            continue

        if section == "seq":
            job_sequence = [int(x) for x in line.split()]
        elif section == "assign":
            parts = line.split()
            if len(parts) >= 3:
                j, s, m = int(parts[0]), int(parts[1]), int(parts[2])
                machine_assignment.append({"job_id": j, "stage_id": s, "machine_id": m})

    return {"job_sequence": job_sequence, "machine_assignment": machine_assignment}


def reproduce_from_txt(txt_path: str, instance: Instance) -> dict:
    """从 txt 文件中的 best_seq 复现结果。

    Args:
        txt_path: txt 文件路径（保存的是算法返回的 best_seq）
        instance: 算例数据

    Returns:
        dict: {
            "makespan": float,
            "total_tardiness": float,
            "violations": list[str],
            "feasible": bool,
            "best_seq": dict,
        }
    """
    best_seq = parse_txt(txt_path)
    job_sequence = best_seq["job_sequence"]
    machine_assignment = deserialize_machine_assignment(best_seq["machine_assignment"])

    # 解码
    schedule = decode(job_sequence, machine_assignment, instance)

    # 计算指标
    metrics = evaluate_schedule(instance, schedule)

    # 校验可行性
    violations = check_feasibility(instance, schedule)

    return {
        "makespan": metrics["makespan"],
        "total_tardiness": metrics["total_tardiness"],
        "violations": violations,
        "feasible": len(violations) == 0,
        "best_seq": best_seq,
    }


def verify_reproduction(txt_path: str, instance: Instance,
                        original_makespan: float, tolerance: float = 1e-4) -> bool:
    """验证复现结果是否与原始结果一致。

    Args:
        txt_path: txt 文件路径（保存的是算法返回的 best_seq）
        instance: 算例数据
        original_makespan: 原始结果的 makespan
        tolerance: 容差

    Returns:
        True 如果复现结果与原始结果一致
    """
    result = reproduce_from_txt(txt_path, instance)
    return abs(result["makespan"] - original_makespan) < tolerance
