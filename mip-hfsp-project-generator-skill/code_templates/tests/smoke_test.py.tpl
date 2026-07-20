"""基础 HFSP 模板的端到端冒烟测试。"""
from __future__ import annotations

import csv
import json
import os
import sys
from pathlib import Path

PROJECT_ROOT = Path(__file__).resolve().parent.parent
sys.path[:0] = [str(PROJECT_ROOT), str(PROJECT_ROOT / "src")]


def run_smoke(output_root: Path) -> dict:
    from core.domain import Instance
    from data.loader import load_instance
    from metaheuristics.decoding.eval_cache import EvalCache
    from metaheuristics.decoding.feasibility_checker import check_feasibility
    from metaheuristics.decoding.list_decoder import decode
    from metaheuristics.encoding.sequence_encoding import (
        deserialize_machine_assignment,
        generate_random_encoding,
    )
    from metaheuristics.registry import get_algorithm, get_runnable_algorithms
    skip_visualization = os.environ.get("HFSP_SMOKE_SKIP_VISUALIZATION") == "1"
    if not skip_visualization:
        from visualization.gantt import plot_gantt

    demo_dirs = sorted(path for path in (PROJECT_ROOT / "data" / "demo").iterdir() if path.is_dir())
    assert demo_dirs, "No demo instances found"
    instance = load_instance(demo_dirs[0])
    encoding = generate_random_encoding(instance, seed=42)
    assert encoding.validate(instance)
    decoded = decode(encoding.job_sequence, encoding.machine_assignment, instance)
    assert check_feasibility(instance, decoded) == []

    # 回归：不同 Stage 中编号相同的机器必须被视为不同资源。
    tiny = Instance(
        name="two_stage_pipeline",
        problem_type="HFSP",
        num_jobs=2,
        num_stages=2,
        processing_times={0: {0: 1.0, 1: 1.0}, 1: {0: 1.0, 1: 1.0}},
        stage_machines={0: [0], 1: [0]},
        release_times={0: 0.0, 1: 0.0},
    )
    pipeline = decode([0, 1], {(j, s): 0 for j in range(2) for s in range(2)}, tiny)
    assert pipeline.objective == 3.0
    assert check_feasibility(tiny, pipeline) == []

    fifo_cache = EvalCache(max_size=500)
    for index in range(501):
        fifo_cache.put(("candidate", index), float(index))
    assert len(fifo_cache) == 500
    assert fifo_cache.get(("candidate", 0)) is None
    assert fifo_cache.get(("candidate", 500)) == 500.0
    try:
        get_algorithm("sa_basic")(
            instance, time_limit=0.01, seed=7, cache=fifo_cache, verbose=0
        )
    except ValueError as exc:
        assert "empty EvalCache" in str(exc)
    else:
        raise AssertionError("solver accepted a pre-populated cross-run cache")

    output_root.mkdir(parents=True, exist_ok=True)
    results = {}
    for algo in get_runnable_algorithms():
        cache = EvalCache(max_size=500)
        schedule, trace, best_seq = get_algorithm(algo)(
            instance, time_limit=0.02, seed=7, cache=cache, verbose=0
        )
        assert trace
        assert cache.misses > 0, f"{algo} bypassed EvalCache"
        assert check_feasibility(instance, schedule) == []
        json.dumps(best_seq, allow_nan=False)
        assignment = deserialize_machine_assignment(best_seq["machine_assignment"])
        reproduced = decode(best_seq["job_sequence"], assignment, instance)
        assert abs(reproduced.objective - schedule.objective) < 1e-9
        results[algo] = schedule.objective

        algo_dir = output_root / algo
        algo_dir.mkdir(parents=True, exist_ok=True)
        (algo_dir / "result.json").write_text(
            json.dumps(
                {"algorithm": algo, "objective": schedule.objective, "best_seq": best_seq},
                indent=2,
                allow_nan=False,
            ),
            encoding="utf-8",
        )
        with (algo_dir / "trace.csv").open("w", newline="", encoding="utf-8") as stream:
            writer = csv.writer(stream)
            writer.writerow(["iteration", "time", "objective"])
            writer.writerows(trace)
        if not skip_visualization:
            plot_gantt(schedule, str(algo_dir / "gantt.png"), title=algo)
            assert (algo_dir / "gantt.png").is_file()

    return {
        "demo": instance.name,
        "algorithms": results,
        "visualization": "SKIPPED" if skip_visualization else "PASS",
    }


def test_core_pipeline(tmp_path: Path) -> None:
    run_smoke(tmp_path / "smoke")


def main() -> None:
    summary = run_smoke(PROJECT_ROOT / "outputs" / "smoke_test")
    print(json.dumps(summary, indent=2, ensure_ascii=False, allow_nan=False))
    print("ALL SMOKE TESTS PASSED")


if __name__ == "__main__":
    main()
