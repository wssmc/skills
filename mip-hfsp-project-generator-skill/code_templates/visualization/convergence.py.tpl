"""收敛曲线绘制 — src/visualization/convergence.py

多算法对比收敛图。
"""
from __future__ import annotations

from pathlib import Path

import matplotlib
matplotlib.use("Agg")
import matplotlib.pyplot as plt


def plot_convergence(traces: dict, output_path: str, title: str = "Convergence Curves"):
    """绘制收敛曲线。

    Args:
        traces: {algo_name: [(iteration, time, objective), ...]}
        output_path: 输出路径
        title: 图标题
    """
    fig, ax = plt.subplots(figsize=(10, 6))

    for algo_name, trace in traces.items():
        if not trace:
            continue
        iterations = [t[0] for t in trace]
        objectives = [t[2] for t in trace]
        ax.plot(iterations, objectives, label=algo_name, linewidth=1.5)

    ax.set_xlabel("Iteration")
    ax.set_ylabel("Objective (Makespan)")
    ax.set_title(title)
    ax.legend()
    ax.grid(alpha=0.3)
    plt.tight_layout()

    output = Path(output_path)
    output.parent.mkdir(parents=True, exist_ok=True)
    plt.savefig(output, dpi=200)
    plt.close()
