"""绘图工具与样式常量 — src/visualization/plot_utils.py

集中管理全项目中所有可视化使用的配色、线型、标记、字体和导出参数，
确保所有输出图风格一致且接近投稿质量。

通用配色规则（适用于所有图表类型）:
  1. 类别变量（算法、Job、方法）→ 使用 PALETTE_12 定性色板，按出现顺序分配
  2. 顺序变量（迭代、时间、误差幅）→ 使用 viridis / plasma 等感知均匀色图
  3. 发散变量（正负偏差、相关性）→ 使用 发散色板（如 vik）
  4. 永远不使用 jet / rainbow / 纯红绿组合
  5. 颜色不是唯一编码：类别必配线型/标记/剖面线
"""
from __future__ import annotations

from pathlib import Path

import matplotlib
matplotlib.use("Agg")
import matplotlib.pyplot as plt


# ============================================================
# 1. 12 色定性色板（色盲友好、灰度友好、白底可读）
# ============================================================
# 来源：Tol (2021) + Wong (Nature Methods 2011) + ColorBrewer
# 前 6 色为高对比组，后 6 色为扩展组
PALETTE_12 = [
    "#0072B2",  #  1 深蓝     — 优先用于 Proposed / 主方法
    "#D55E00",  #  2 朱红     — 强基线
    "#009E73",  #  3 蓝绿     — 基线 2
    "#CC79A7",  #  4 紫红     — 基线 3
    "#F0E442",  #  5 黄       — 仅搭配深色标记/粗线使用
    "#56B4E9",  #  6 天蓝     — 基线 4
    "#E69F00",  #  7 橙       — 基线 5
    "#000000",  #  8 黑       — 特殊强调
    "#332288",  #  9 靛蓝     — 扩展 1
    "#88CCEE",  # 10 浅青     — 扩展 2
    "#44AA99",  # 11 青绿     — 扩展 3
    "#AA4499",  # 12 紫       — 扩展 4
]

# ColorBrewer 9 色定性（短序列备用）
PALETTE_9 = [
    "#e41a1c", "#377eb8", "#4daf4a",
    "#984ea3", "#ff7f00", "#ffff33",
    "#a65628", "#f781bf", "#999999",
]

# ============================================================
# 2. 线型（4 种） + 标记（6 种）
# ============================================================
# 组合规则：12 条曲线 = 12 种 (color, linestyle, marker) 唯一组合
LINE_STYLES = ["-", "--", "-.", ":"]
MARKERS = ["", "o", "s", "^", "D", "v"]  # 空=无标记, o=圆, s=方, ^=三角, D=钻石, v=下三角

def get_curve_style(index: int) -> dict:
    """返回第 index 条曲线的 (color, linestyle, marker, linewidth) 字典。

    分配规则:
      index 0–3:  颜色 0–3 + 实线  + 无标记
      index 4–7:  颜色 4–7 + 虚线  + 圆圈标记
      index 8–11: 颜色 8–11 + 点划线 + 方块标记
      超出 12 则环绕，标记递增
    """
    if index < 4:
        return {
            "color": PALETTE_12[index],
            "linestyle": LINE_STYLES[0],
            "marker": MARKERS[0],
            "linewidth": 1.0 if index > 0 else 1.2,  # index 0 略粗 = 主方法
        }
    elif index < 8:
        return {
            "color": PALETTE_12[index],
            "linestyle": LINE_STYLES[1],
            "marker": MARKERS[1],
            "markevery": 10,
            "linewidth": 0.9,
        }
    elif index < 12:
        return {
            "color": PALETTE_12[index],
            "linestyle": LINE_STYLES[2],
            "marker": MARKERS[2],
            "markevery": 12,
            "linewidth": 0.8,
        }
    else:
        base = index % 12
        return {
            "color": PALETTE_12[base],
            "linestyle": LINE_STYLES[index // 4 % 4],
            "marker": MARKERS[index // 3 % 6],
            "markevery": 15,
            "linewidth": 0.8,
        }


# ============================================================
# 3. 字体
# ============================================================
FONT_FAMILY = "Arial"
FONT_SIZE_TICK = 7
FONT_SIZE_LABEL = 7.5
FONT_SIZE_LEGEND = 7
FONT_SIZE_TITLE = 8
FONT_SIZE_ANNOTATION = 6.5

plt.rcParams.update({
    "font.family": "sans-serif",
    "font.sans-serif": [FONT_FAMILY, "Helvetica", "Liberation Sans"],
    "font.size": FONT_SIZE_TICK,
    "axes.titlesize": FONT_SIZE_TITLE,
    "axes.labelsize": FONT_SIZE_LABEL,
    "xtick.labelsize": FONT_SIZE_TICK,
    "ytick.labelsize": FONT_SIZE_TICK,
    "legend.fontsize": FONT_SIZE_LEGEND,
    "figure.dpi": 300,
    "savefig.dpi": 300,
    "savefig.bbox": "tight",
})


# ============================================================
# 4. 导出常量
# ============================================================
SINGLE_COL_WIDTH_MM = 89    # 单栏宽（mm）
DOUBLE_COL_WIDTH_MM = 183   # 双栏宽（mm）
DEFAULT_DPI = 300
VECTOR_FORMATS = {".pdf", ".eps", ".svg"}
RASTER_FORMATS = {".png", ".jpg", ".tiff"}


def figure_width(n_curves: int, double_col: bool = False) -> float:
    """根据曲线数量和栏宽返回合适图宽（英寸）。"""
    base_mm = DOUBLE_COL_WIDTH_MM if double_col else SINGLE_COL_WIDTH_MM
    return base_mm / 25.4  # mm → inch


def figure_height(n_curves: int) -> float:
    return figure_width(n_curves) * 0.65  # 高宽比约 0.65


def save_figure(fig: plt.Figure, output_path: str, dpi: int = DEFAULT_DPI):
    """统一保存图片，自动检测格式。"""
    path = Path(output_path)
    path.parent.mkdir(parents=True, exist_ok=True)
    fmt = path.suffix.lower()
    supported = VECTOR_FORMATS | RASTER_FORMATS
    if fmt not in supported:
        plt.close(fig)
        raise ValueError(f"Unsupported figure format {fmt!r}; expected one of {sorted(supported)}")
    if fmt in VECTOR_FORMATS:
        fig.savefig(path, format=fmt.lstrip("."), dpi=dpi)
    else:
        fig.savefig(path, dpi=dpi)
    plt.close(fig)


# ============================================================
# 5. 颜色分配工具
# ============================================================

def job_color(job_id: int) -> str:
    """Job → 颜色映射（循环使用 12 色色板）。"""
    return PALETTE_12[job_id % 12]


def algo_color(algo_index: int) -> str:
    """算法索引 → 颜色（优先使用前 6 高对比色）。"""
    return PALETTE_12[algo_index % 12]


def category_color(category_index: int, offset: int = 0) -> str:
    """通用类别 → 颜色映射。"""
    return PALETTE_12[(category_index + offset) % 12]
