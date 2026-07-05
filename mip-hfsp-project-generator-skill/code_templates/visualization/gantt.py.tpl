"""甘特图绘制 — src/visualization/gantt.py

基础甘特图。
"""
from __future__ import annotations

from pathlib import Path

import matplotlib
matplotlib.use("Agg")
import matplotlib.pyplot as plt

import sys
sys.path.insert(0, str(__import__("pathlib").Path(__file__).resolve().parent.parent))
from core.domain import Schedule


def plot_gantt(schedule: Schedule, output_path: str, title: str = "Gantt Chart",
               show_makespan: bool = True):
    """绘制甘特图。

    Args:
        schedule: 排程结果
        output_path: 输出路径（.png 或 .pdf）
        title: 图标题
        show_makespan: 是否显示 makespan 线
    """
    if not schedule.operations:
        return

    # 按 machine 分组
    by_machine = {}
    for op in schedule.operations:
        by_machine.setdefault(op.machine_id, []).append(op)

    machines = sorted(by_machine.keys())
    fig, ax = plt.subplots(figsize=(14, max(4, len(machines) * 0.8)))

    colors = plt.cm.Set3(range(max(schedule.operations, key=lambda o: o.job_id).job_id + 1))

    for m_idx, m in enumerate(machines):
        for op in by_machine[m]:
            color = colors[op.job_id % len(colors)]
            ax.barh(m_idx, op.end - op.start, left=op.start, height=0.6,
                    color=color, edgecolor="black", linewidth=0.5)
            ax.text(op.start + (op.end - op.start) / 2, m_idx,
                    f"J{op.job_id}-S{op.stage_id}", ha="center", va="center", fontsize=7)

    ax.set_yticks(range(len(machines)))
    ax.set_yticklabels([f"M{m}" for m in machines])
    ax.set_xlabel("Time")
    ax.set_title(title)

    if show_makespan and schedule.objective < float("inf"):
        ax.axvline(x=schedule.objective, color="red", linestyle="--", linewidth=1.5,
                   label=f"Cmax = {schedule.objective:.2f}")
        ax.legend()

    ax.grid(axis="x", alpha=0.3)
    plt.tight_layout()

    output = Path(output_path)
    output.parent.mkdir(parents=True, exist_ok=True)
    plt.savefig(output, dpi=200)
    plt.close()
