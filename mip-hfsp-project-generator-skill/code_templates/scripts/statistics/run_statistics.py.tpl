"""非参数检验 — scripts/statistics/run_statistics.py

Friedman 检验、配对 Wilcoxon 符号秩检验和 Holm 校正。
输出检验结果与校正后的 p 值；当前入口不声明 CD diagram 能力。
"""
from __future__ import annotations

import argparse
import json
import sys
from pathlib import Path

import numpy as np

try:
    from scipy.stats import friedmanchisquare, wilcoxon
except ImportError:
    friedmanchisquare = None
    wilcoxon = None


def _paired_arrays(data: dict, minimum_algorithms: int) -> tuple[list[str], list[np.ndarray]]:
    if not isinstance(data, dict):
        raise ValueError("Input data must be an object mapping algorithm names to observations")
    names = list(data)
    if len(names) < minimum_algorithms:
        raise ValueError(f"At least {minimum_algorithms} algorithms are required")
    try:
        arrays = [np.asarray(data[name], dtype=float) for name in names]
    except (TypeError, ValueError) as exc:
        raise ValueError(f"Observations must be numeric arrays: {exc}") from exc
    if any(array.ndim != 1 for array in arrays):
        raise ValueError("Each algorithm must have a one-dimensional observation array")
    lengths = {len(array) for array in arrays}
    if len(lengths) != 1 or 0 in lengths:
        raise ValueError("All algorithms must have the same non-zero number of paired observations")
    if not all(np.isfinite(array).all() for array in arrays):
        raise ValueError("Observations must all be finite")
    return names, arrays


def run_friedman_test(data: dict) -> dict:
    """Friedman 检验：多算法整体差异。

    Args:
        data: {algo_name: [obj_inst1, obj_inst2, ...]}

    Returns:
        {statistic, p_value, n_instances, n_algorithms}
    """
    if friedmanchisquare is None:
        raise RuntimeError("scipy is required for the Friedman test")

    algo_names, arrays = _paired_arrays(data, minimum_algorithms=3)
    stat, p = friedmanchisquare(*arrays)
    if not np.isfinite(stat) or not np.isfinite(p):
        raise RuntimeError("Friedman test returned a non-finite result")
    return {
        "statistic": float(stat),
        "p_value": float(p),
        "n_instances": len(arrays[0]) if arrays else 0,
        "n_algorithms": len(algo_names),
    }


def run_wilcoxon_test(data: dict) -> dict:
    """配对 Wilcoxon 符号秩检验：两两算法对比。

    Returns:
        {f"{algo1}_vs_{algo2}": {"statistic": s, "p_value": p}}
    """
    if wilcoxon is None:
        raise RuntimeError("scipy is required for the Wilcoxon test")

    algo_names, arrays = _paired_arrays(data, minimum_algorithms=2)
    paired = dict(zip(algo_names, arrays))
    results = {}
    for i in range(len(algo_names)):
        for j in range(i + 1, len(algo_names)):
            a, b = algo_names[i], algo_names[j]
            try:
                stat, p = wilcoxon(paired[a], paired[b])
                if not np.isfinite(stat) or not np.isfinite(p):
                    raise ValueError("test returned a non-finite result")
                results[f"{a}_vs_{b}"] = {"statistic": float(stat), "p_value": float(p)}
            except ValueError as exc:
                raise ValueError(f"Invalid paired observations for {a} vs {b}: {exc}") from exc
    return results


def holm_correction(p_values: dict, alpha: float = 0.05) -> dict:
    """Holm 校正。"""
    if not 0 < alpha < 1:
        raise ValueError("alpha must be between 0 and 1")
    if any(not isinstance(p, (int, float)) or not 0 <= p <= 1 for p in p_values.values()):
        raise ValueError("p-values must be numeric values in [0, 1]")
    sorted_p = sorted(p_values.items(), key=lambda x: x[1])
    m = len(sorted_p)
    results = {}
    running_adjusted = 0.0
    for i, (key, p) in enumerate(sorted_p):
        adjusted_p = max(running_adjusted, min(p * (m - i), 1.0))
        running_adjusted = adjusted_p
        results[key] = {
            "original_p": p,
            "adjusted_p": adjusted_p,
            "significant": adjusted_p < alpha,
        }
    return results


def main():
    parser = argparse.ArgumentParser(description="Non-parametric statistical tests")
    parser.add_argument("--input", type=str, required=True, help="Input JSON file with results")
    parser.add_argument("--out", type=str, default="outputs/statistics", help="Output directory")
    args = parser.parse_args()

    data = json.loads(Path(args.input).read_text(encoding="utf-8"))

    project_root = Path(__file__).resolve().parent.parent.parent
    outputs_root = (project_root / "outputs").resolve()
    out_dir = (project_root / args.out).resolve()
    if out_dir != outputs_root and outputs_root not in out_dir.parents:
        raise ValueError("Statistics output must stay inside the project outputs directory")
    out_dir.mkdir(parents=True, exist_ok=True)

    # Friedman
    friedman_result = run_friedman_test(data)
    (out_dir / "friedman_test.json").write_text(
        json.dumps(friedman_result, indent=2, allow_nan=False), encoding="utf-8"
    )
    print(f"Friedman test: {friedman_result}")

    # Wilcoxon
    wilcoxon_result = run_wilcoxon_test(data)
    import csv
    with open(out_dir / "wilcoxon_matrix.csv", "w", newline="", encoding="utf-8") as f:
        writer = csv.writer(f)
        writer.writerow(["pair", "statistic", "p_value"])
        for pair, result in wilcoxon_result.items():
            if "p_value" in result:
                writer.writerow([pair, result["statistic"], result["p_value"]])

    # Holm correction
    p_vals = {k: v["p_value"] for k, v in wilcoxon_result.items() if "p_value" in v}
    holm_result = holm_correction(p_vals)
    with open(out_dir / "holm_corrected.csv", "w", newline="", encoding="utf-8") as f:
        writer = csv.writer(f)
        writer.writerow(["pair", "original_p", "adjusted_p", "significant"])
        for pair, result in holm_result.items():
            writer.writerow([pair, result["original_p"], result["adjusted_p"], result["significant"]])

    print(f"\nResults saved to {out_dir}")


if __name__ == "__main__":
    main()
