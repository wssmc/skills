"""收敛曲线绘制 — src/visualization/convergence.py

支持最多 12 条曲线的发表级收敛图。
使用 plot_utils 定义的配色+线型+标记组合规则。
"""
from __future__ import annotations

from pathlib import Path

import matplotlib
matplotlib.use("Agg")
import matplotlib.pyplot as plt
import numpy as np

import sys
sys.path.insert(0, str(__import__("pathlib").Path(__file__).resolve().parent.parent))
from visualization.plot_utils import (
    get_curve_style,
    figure_width,
    figure_height,
    save_figure,
    FONT_SIZE_LEGEND,
)


def plot_convergence(
    traces: dict[str, list],
    output_path: str = "outputs/convergence.png",
    title: str = "",
    x_label: str = "Iteration",
    y_label: str = "Objective (Makespan)",
    double_col: bool = False,
    highlight: str | None = None,
    show_ci: bool = False,
):
    """绘制多算法收敛曲线。

    Args:
        traces:  {algo_name: [(iteration, time, objective), ...]}
        output_path: 输出路径（.png 或 .pdf）
        title: 图标题（可空）
        x_label: X 轴标签
        y_label: Y 轴标签
        double_col: 是否双栏宽度
        highlight: 需要高亮的算法名（加粗+加粗线宽）
        show_ci: 是否显示置信区间（需要 traces 含重复运行数据）
    """
    algo_names = list(traces.keys())
    n = len(algo_names)
    w = figure_width(n, double_col)
    h = figure_height(n)
    fig, ax = plt.subplots(figsize=(w, h))

    for i, name in enumerate(algo_names):
        trace = traces[name]
        if not trace or len(trace) < 2:
            continue
        arr = np.array(trace)
        its = arr[:, 0]
        objs = arr[:, 2]
        style = get_curve_style(i)
        lw = style["linewidth"]
        if highlight and name == highlight:
            lw = max(lw * 1.3, 1.5)
        ax.plot(
            its, objs,
            color=style["color"],
            linestyle=style["linestyle"],
            linewidth=lw,
            marker=style.get("marker", ""),
            markevery=style.get("markevery", None),
            label=name,
            alpha=0.9,
        )

    ax.set_xlabel(x_label)
    ax.set_ylabel(y_label)
    if title:
        ax.set_title(title)
    ax.legend(
        loc="best",
        frameon=True,
        framealpha=0.85,
        edgecolor="#cccccc",
        fontsize=FONT_SIZE_LEGEND,
    )
    ax.grid(False)
    ax.spines["top"].set_visible(False)
    ax.spines["right"].set_visible(False)

    fig.tight_layout(pad=1.0)
    save_figure(fig, output_path)


def plot_convergence_with_ci(
    traces: dict[str, list[list]],
    output_path: str = "outputs/convergence.png",
    title: str = "",
    x_label: str = "Iteration",
    y_label: str = "Objective (Makespan)",
    double_col: bool = False,
    highlight: str | None = None,
    ci_alpha: float = 0.15,
):
    """带置信区间的收敛曲线（多条运行轨迹）。

    Args:
        traces: {algo_name: [[(it, time, obj), ...], ...]} 每条运行一个轨迹列表
        其余参数同 plot_convergence
    """
    algo_names = list(traces.keys())
    n = len(algo_names)
    w = figure_width(n, double_col)
    h = figure_height(n)
    fig, ax = plt.subplots(figsize=(w, h))

    for i, name in enumerate(algo_names):
        runs = traces[name]
        if not runs:
            continue
        min_len = min(len(r) for r in runs)
        if min_len < 2:
            continue
        truncated = [r[:min_len] for r in runs]
        arr = np.array(truncated)
        its = arr[0, :, 0]
        objs = arr[:, :, 2]
        mean_obj = np.mean(objs, axis=0)
        std_obj = np.std(objs, axis=0)

        style = get_curve_style(i)
        lw = style["linewidth"]
        if highlight and name == highlight:
            lw = max(lw * 1.3, 1.5)

        ax.plot(
            its, mean_obj,
            color=style["color"],
            linestyle=style["linestyle"],
            linewidth=lw,
            marker=style.get("marker", ""),
            markevery=style.get("markevery", None),
            label=name,
            alpha=0.9,
        )
        ax.fill_between(
            its,
            mean_obj - std_obj,
            mean_obj + std_obj,
            color=style["color"],
            alpha=ci_alpha,
            linewidth=0,
        )

    ax.set_xlabel(x_label)
    ax.set_ylabel(y_label)
    if title:
        ax.set_title(title)
    ax.legend(
        loc="best",
        frameon=True,
        framealpha=0.85,
        edgecolor="#cccccc",
        fontsize=FONT_SIZE_LEGEND,
    )
    ax.grid(False)
    ax.spines["top"].set_visible(False)
    ax.spines["right"].set_visible(False)

    fig.tight_layout(pad=1.0)
    save_figure(fig, output_path)
