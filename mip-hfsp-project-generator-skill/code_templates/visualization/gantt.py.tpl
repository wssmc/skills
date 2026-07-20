"""甘特图绘制 — src/visualization/gantt.py

发表级甘特图，Job 按 plot_utils 色板着色，
不同 Stage 在同一 Job 内使用同色不同透明度。
"""
from __future__ import annotations

import matplotlib
matplotlib.use("Agg")
import matplotlib.pyplot as plt

import sys
sys.path.insert(0, str(__import__("pathlib").Path(__file__).resolve().parent.parent))
from core.domain import Schedule
from visualization.plot_utils import (
    job_color,
    figure_width,
    save_figure,
    FONT_SIZE_TICK,
    FONT_SIZE_ANNOTATION,
)


def plot_gantt(
    schedule: Schedule,
    output_path: str = "outputs/gantt.png",
    title: str = "",
    show_makespan: bool = True,
    double_col: bool = False,
):
    """绘制发表级甘特图。

    Args:
        schedule: 排程结果
        output_path: 输出路径（.png / .pdf）
        title: 图标题（可空）
        show_makespan: 是否显示 makespan 红色虚线
        double_col: 是否使用双栏宽度
    """
    if not schedule.operations:
        raise ValueError("Cannot plot an empty schedule")

    by_machine: dict[tuple[int, int], list] = {}
    for op in schedule.operations:
        by_machine.setdefault(op.resource_key, []).append(op)

    machines = sorted(by_machine.keys())
    num_machines = len(machines)

    w = figure_width(len(machines), double_col)
    h = max(2.0, num_machines * 0.6)
    fig, ax = plt.subplots(figsize=(w, h))

    for m_idx, m in enumerate(machines):
        ops = sorted(by_machine[m], key=lambda o: o.start)

        for op in ops:
            base_color = job_color(op.job_id)
            stage_alpha = 0.5 + (op.stage_id % 3) * 0.2
            ax.barh(
                m_idx,
                op.end - op.start,
                left=op.start,
                height=0.65,
                color=base_color,
                alpha=stage_alpha,
                edgecolor="white",
                linewidth=0.4,
                zorder=3,
            )
            ax.text(
                op.start + (op.end - op.start) / 2,
                m_idx,
                f"J{op.job_id}",
                ha="center",
                va="center",
                fontsize=FONT_SIZE_ANNOTATION,
                color="black" if stage_alpha > 0.6 else "white",
                weight="bold",
            )

    ax.set_yticks(range(num_machines))
    ax.set_yticklabels(
        [f"S{stage_id}-M{machine_id}" for stage_id, machine_id in machines],
        fontsize=FONT_SIZE_TICK,
    )
    ax.set_xlabel("Time", fontsize=FONT_SIZE_TICK + 0.5)
    if title:
        ax.set_title(title, fontsize=FONT_SIZE_TICK + 1)

    if show_makespan and schedule.objective < float("inf"):
        ax.axvline(
            x=schedule.objective,
            color="#CC3311",
            linestyle="--",
            linewidth=1.0,
            zorder=5,
        )
        ax.text(
            schedule.objective,
            -0.5,
            f"Cmax = {schedule.objective:.1f}",
            ha="right",
            va="top",
            fontsize=FONT_SIZE_ANNOTATION,
            color="#CC3311",
        )

    ax.set_xlim(left=0)
    ax.set_ylim(-0.6, num_machines - 0.4)
    ax.grid(False)
    ax.spines["top"].set_visible(False)
    ax.spines["right"].set_visible(False)
    ax.tick_params(axis="both", length=3)

    fig.tight_layout(pad=0.8)
    save_figure(fig, output_path)


def plot_gantt_by_stage(
    schedule: Schedule,
    output_path: str = "outputs/gantt_stage.png",
    double_col: bool = False,
):
    """按 Stage 分组排列的甘特图（纵轴为 Stage，颜色按 Job）。"""
    if not schedule.operations:
        raise ValueError("Cannot plot an empty schedule")

    by_stage: dict[int, list] = {}
    for op in schedule.operations:
        by_stage.setdefault(op.stage_id, []).append(op)

    stages = sorted(by_stage.keys())
    num_stages = len(stages)
    w = figure_width(num_stages, double_col)
    h = max(2.0, num_stages * 0.6)
    fig, ax = plt.subplots(figsize=(w, h))

    for s_idx, s in enumerate(stages):
        ops = sorted(by_stage[s], key=lambda o: o.machine_id * 1e6 + o.start)
        for op in ops:
            color = job_color(op.job_id)
            ax.barh(
                s_idx,
                op.end - op.start,
                left=op.start,
                height=0.6,
                color=color,
                edgecolor="white",
                linewidth=0.3,
                alpha=0.85,
                zorder=3,
            )

    ax.set_yticks(range(num_stages))
    ax.set_yticklabels([f"Stage {s}" for s in stages], fontsize=FONT_SIZE_TICK)
    ax.set_xlabel("Time", fontsize=FONT_SIZE_TICK + 0.5)
    ax.set_xlim(left=0)
    ax.set_ylim(-0.5, num_stages - 0.5)
    ax.grid(False)
    ax.spines["top"].set_visible(False)
    ax.spines["right"].set_visible(False)

    fig.tight_layout(pad=0.8)
    save_figure(fig, output_path)
