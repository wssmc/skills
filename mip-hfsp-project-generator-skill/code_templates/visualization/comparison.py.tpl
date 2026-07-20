"""实验对比图绘制 — src/visualization/comparison.py

ARPD 柱状图、多算例对比图、消融实验汇总图。
使用 plot_utils 定义的配色和导出规范。
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
    PALETTE_12,
    figure_width,
    figure_height,
    save_figure,
    FONT_SIZE_TICK,
    FONT_SIZE_LABEL,
    FONT_SIZE_LEGEND,
    FONT_SIZE_ANNOTATION,
)


def plot_arpd(
    data: dict[str, list[float]],
    output_path: str = "outputs/arpd.png",
    title: str = "ARPD Comparison",
    y_label: str = "ARPD (%)",
    double_col: bool = False,
):
    """绘制 ARPD 对比柱状图。

    Args:
        data: {algo_name: [arpd_per_instance, ...]} 每个算法的 ARPD 序列
        output_path: 输出路径
        title: 图标题
        y_label: Y 轴标签
        double_col: 是否双栏宽度
    """
    algo_names = list(data.keys())
    n = len(algo_names)
    w = figure_width(n, double_col)
    h = figure_height(n)
    fig, ax = plt.subplots(figsize=(w, h))

    means = [np.mean(data[name]) for name in algo_names]
    stds = [np.std(data[name]) for name in algo_names]

    x_pos = np.arange(n)
    colors = [PALETTE_12[i % 12] for i in range(n)]

    bars = ax.bar(
        x_pos, means, yerr=stds,
        color=colors,
        edgecolor="white",
        linewidth=0.5,
        capsize=3,
        error_kw={"linewidth": 0.8, "ecolor": "#333333"},
        width=0.6,
    )

    for bar, mean in zip(bars, means):
        ax.text(
            bar.get_x() + bar.get_width() / 2,
            bar.get_height() + max(stds) * 0.05,
            f"{mean:.2f}",
            ha="center",
            va="bottom",
            fontsize=FONT_SIZE_ANNOTATION,
        )

    ax.set_xticks(x_pos)
    ax.set_xticklabels(algo_names, rotation=30, ha="right", fontsize=FONT_SIZE_TICK)
    ax.set_ylabel(y_label, fontsize=FONT_SIZE_LABEL)
    if title:
        ax.set_title(title, fontsize=FONT_SIZE_LABEL + 1)
    ax.grid(axis="y", alpha=0.3, linewidth=0.3)
    ax.spines["top"].set_visible(False)
    ax.spines["right"].set_visible(False)

    fig.tight_layout(pad=1.0)
    save_figure(fig, output_path)


def plot_bar_comparison(
    results: dict[str, list[float]],
    output_path: str = "outputs/comparison.png",
    title: str = "",
    y_label: str = "Makespan",
    group_labels: list[str] | None = None,
    double_col: bool = False,
):
    """多算例多算法柱状对比图。

    Args:
        results: {algo_name: [objective_per_instance, ...]}
        output_path: 输出路径
        title: 图标题（可空）
        y_label: Y 轴标签
        group_labels: 每组（算例）标签，默认用索引
        double_col: 是否双栏宽度
    """
    algo_names = list(results.keys())
    n_algos = len(algo_names)
    values = np.array([results[name] for name in algo_names])
    n_instances = values.shape[1]

    w = figure_width(n_instances, double_col)
    h = figure_height(n_algos)
    fig, ax = plt.subplots(figsize=(w, h))

    group_width = 0.8
    bar_width = group_width / n_algos
    x = np.arange(n_instances)

    for i, name in enumerate(algo_names):
        offset = (i - n_algos / 2 + 0.5) * bar_width
        color = PALETTE_12[i % 12]
        ax.bar(
            x + offset, values[i],
            width=bar_width * 0.9,
            color=color,
            edgecolor="white",
            linewidth=0.3,
            label=name,
            alpha=0.85,
        )

    ax.set_xticks(x)
    ax.set_xticklabels(
        group_labels if group_labels else [f"Inst {i+1}" for i in range(n_instances)],
        rotation=20,
        ha="right",
        fontsize=FONT_SIZE_TICK,
    )
    ax.set_ylabel(y_label, fontsize=FONT_SIZE_LABEL)
    if title:
        ax.set_title(title, fontsize=FONT_SIZE_LABEL + 1)
    ax.legend(fontsize=FONT_SIZE_LEGEND, framealpha=0.85, edgecolor="#cccccc")
    ax.grid(axis="y", alpha=0.3, linewidth=0.3)
    ax.spines["top"].set_visible(False)
    ax.spines["right"].set_visible(False)

    fig.tight_layout(pad=1.0)
    save_figure(fig, output_path)


def plot_ablation(
    data: dict[str, float],
    output_path: str = "outputs/ablation.png",
    title: str = "Ablation Study",
    y_label: str = "Objective",
    double_col: bool = False,
):
    """消融实验柱状图（单值对比，按值排序）。"""
    sorted_items = sorted(data.items(), key=lambda x: x[1])
    names = [item[0] for item in sorted_items]
    values = [item[1] for item in sorted_items]
    n = len(names)

    w = figure_width(n, double_col)
    h = figure_height(n)
    fig, ax = plt.subplots(figsize=(w, h))

    x_pos = np.arange(n)
    colors = [PALETTE_12[i % 12] for i in range(n)]

    bars = ax.bar(
        x_pos, values,
        color=colors,
        edgecolor="white",
        linewidth=0.5,
        width=0.5,
    )

    best_val = min(values)
    for bar, val in zip(bars, values):
        ax.text(
            bar.get_x() + bar.get_width() / 2,
            bar.get_height() + max(values) * 0.01,
            f"{val:.2f}",
            ha="center",
            va="bottom",
            fontsize=FONT_SIZE_ANNOTATION,
            weight="bold" if val == best_val else "normal",
        )

    ax.set_xticks(x_pos)
    ax.set_xticklabels(names, rotation=30, ha="right", fontsize=FONT_SIZE_TICK)
    ax.set_ylabel(y_label, fontsize=FONT_SIZE_LABEL)
    if title:
        ax.set_title(title, fontsize=FONT_SIZE_LABEL + 1)
    ax.grid(axis="y", alpha=0.3, linewidth=0.3)
    ax.spines["top"].set_visible(False)
    ax.spines["right"].set_visible(False)

    fig.tight_layout(pad=1.0)
    save_figure(fig, output_path)
