"""非参数检验 — scripts/statistics/run_statistics.py

Friedman 检验、Wilcoxon 秩和检验、Holm/Hochberg 校正。
输出 p 值矩阵 + 临界差图（CD diagram）。
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


def run_friedman_test(data: dict) -> dict:
    """Friedman 检验：多算法整体差异。

    Args:
        data: {algo_name: [obj_inst1, obj_inst2, ...]}

    Returns:
        {statistic, p_value, n_instances, n_algorithms}
    """
    if friedmanchisquare is None:
        return {"error": "scipy not available"}

    algo_names = list(data.keys())
    arrays = [np.array(data[name]) for name in algo_names]
    stat, p = friedmanchisquare(*arrays)
    return {
        "statistic": float(stat),
        "p_value": float(p),
        "n_instances": len(arrays[0]) if arrays else 0,
        "n_algorithms": len(algo_names),
    }


def run_wilcoxon_test(data: dict) -> dict:
    """Wilcoxon 秩和检验：两两算法对比。

    Returns:
        {f"{algo1}_vs_{algo2}": {"statistic": s, "p_value": p}}
    """
    if wilcoxon is None:
        return {"error": "scipy not available"}

    algo_names = list(data.keys())
    results = {}
    for i in range(len(algo_names)):
        for j in range(i + 1, len(algo_names)):
            a, b = algo_names[i], algo_names[j]
            try:
                stat, p = wilcoxon(data[a], data[b])
                results[f"{a}_vs_{b}"] = {"statistic": float(stat), "p_value": float(p)}
            except Exception as e:
                results[f"{a}_vs_{b}"] = {"error": str(e)}
    return results


def holm_correction(p_values: dict, alpha: float = 0.05) -> dict:
    """Holm 校正。"""
    sorted_p = sorted(p_values.items(), key=lambda x: x[1])
    m = len(sorted_p)
    results = {}
    for i, (key, p) in enumerate(sorted_p):
        adjusted_p = min(p * (m - i), 1.0)
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

    out_dir = Path(args.out)
    out_dir.mkdir(parents=True, exist_ok=True)

    # Friedman
    friedman_result = run_friedman_test(data)
    (out_dir / "friedman_test.json").write_text(
        json.dumps(friedman_result, indent=2), encoding="utf-8"
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
