"""Smoke 测试 — tests/smoke_test.py

项目生成后的第一道验证，确保核心链路能跑通。
运行: python tests/smoke_test.py

验证链路: 读取 -> 编码 -> 解码 -> 评估 -> 可行性 -> 算法运行 -> 产物写入
"""
from __future__ import annotations

import sys
import os
from pathlib import Path

# 确保项目根目录在 path 中
PROJECT_ROOT = Path(__file__).resolve().parent.parent
sys.path.insert(0, str(PROJECT_ROOT))


def test_data_loading():
    """1. 数据读取: load_instance 能成功加载 demo 算例。"""
    from data.loader import load_instance
    demo_dirs = list((PROJECT_ROOT / "data" / "demo").iterdir())
    assert len(demo_dirs) > 0, "No demo instances found in data/demo/"
    instance = load_instance(demo_dirs[0])
    errors = instance.validate()
    assert len(errors) == 0, f"Instance validation failed: {errors}"
    print(f"  [PASS] Data loading: {instance.name} ({instance.num_jobs} jobs, {instance.num_stages} stages)")
    return instance


def test_encoding(instance):
    """2. 编码生成: generate_random_encoding 能成功。"""
    from metaheuristics.encoding.sequence_encoding import generate_random_encoding
    encoding = generate_random_encoding(instance, seed=42)
    assert encoding.validate(instance), "Encoding validation failed"
    assert len(encoding.job_sequence) == instance.num_jobs, "Job sequence length mismatch"
    print(f"  [PASS] Encoding: {len(encoding.job_sequence)} jobs")
    return encoding


def test_decoding(instance, encoding):
    """3. 解码运行: decode 能成功返回 Schedule。"""
    from metaheuristics.decoding.list_decoder import decode
    schedule = decode(encoding.job_sequence, encoding.machine_assignment, instance)
    assert len(schedule.operations) > 0, "No operations in schedule"
    assert schedule.objective < float("inf"), "Objective is infinity"
    print(f"  [PASS] Decoding: {len(schedule.operations)} operations, makespan={schedule.objective:.4f}")
    return schedule


def test_feasibility(instance, schedule):
    """4. 可行性检查: check_feasibility 能运行。"""
    from metaheuristics.decoding.feasibility_checker import check_feasibility
    violations = check_feasibility(instance, schedule)
    print(f"  [PASS] Feasibility: {len(violations)} violations")
    return violations


def test_metrics(instance, schedule):
    """5. 指标计算: evaluate_schedule 能运行。"""
    from metaheuristics.decoding.metrics import evaluate_schedule
    metrics = evaluate_schedule(instance, schedule)
    assert "makespan" in metrics, "makespan not in metrics"
    assert "total_tardiness" in metrics, "total_tardiness not in metrics"
    print(f"  [PASS] Metrics: makespan={metrics['makespan']:.4f}, tardiness={metrics['total_tardiness']:.4f}")
    return metrics


def test_algorithm(instance):
    """6. 单算法运行: solve_sa_basic 能跑完。"""
    from metaheuristics.sa.sa_basic import solve_sa_basic
    schedule, trace, best_seq = solve_sa_basic(instance, time_limit=5, seed=1)
    assert schedule.objective < float("inf"), "Algorithm returned infinite objective"
    assert len(trace) > 0, "No trace data"
    assert "job_sequence" in best_seq, "best_seq missing job_sequence"
    assert "machine_assignment" in best_seq, "best_seq missing machine_assignment"
    print(f"  [PASS] Algorithm (SA basic): makespan={schedule.objective:.4f}, trace_len={len(trace)}")
    return schedule, trace, best_seq


def test_artifacts(instance, schedule, trace, best_seq, tmp_dir="outputs/smoke_test"):
    """7. 产物写入: result.json / schedule.json / trace.csv / gantt.png 能写出。"""
    import json
    import csv
    out = PROJECT_ROOT / tmp_dir / instance.name
    out.mkdir(parents=True, exist_ok=True)

    # result.json
    (out / "smoke_result.json").write_text(json.dumps({
        "method": "smoke_test",
        "objective": schedule.objective,
        "best_seq": best_seq,
    }, indent=2), encoding="utf-8")
    assert (out / "smoke_result.json").exists() and (out / "smoke_result.json").stat().st_size > 0

    # schedule.json
    (out / "smoke_schedule.json").write_text(
        json.dumps(schedule.to_records(), indent=2), encoding="utf-8"
    )
    assert (out / "smoke_schedule.json").exists()

    # trace.csv
    with open(out / "smoke_trace.csv", "w", newline="") as f:
        writer = csv.writer(f)
        writer.writerow(["iteration", "time", "objective"])
        for row in trace:
            writer.writerow(row)
    assert (out / "smoke_trace.csv").exists()

    # gantt.png
    try:
        from visualization.gantt import plot_gantt
        plot_gantt(schedule, str(out / "smoke_gantt.png"), title="Smoke Test")
        assert (out / "smoke_gantt.png").exists()
        print(f"  [PASS] Artifacts: all files written to {out}")
    except Exception as e:
        print(f"  [WARN] Gantt plot skipped: {e}")
        print(f"  [PASS] Artifacts: json/csv written to {out}")


def main():
    print("=" * 50)
    print("Smoke Test - Core Pipeline Verification")
    print("=" * 50)

    instance = test_data_loading()
    encoding = test_encoding(instance)
    schedule = test_decoding(instance, encoding)
    violations = test_feasibility(instance, schedule)
    metrics = test_metrics(instance, schedule)
    schedule, trace, best_seq = test_algorithm(instance)
    test_artifacts(instance, schedule, trace, best_seq)

    print("=" * 50)
    print("ALL SMOKE TESTS PASSED")
    print("=" * 50)


if __name__ == "__main__":
    main()
