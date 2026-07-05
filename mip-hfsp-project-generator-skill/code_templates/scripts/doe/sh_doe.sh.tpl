#!/bin/bash
# ============================================================
# sh_doe.sh — DOE 批量脚本
#
# 用法:
#   bash scripts/doe/sh_doe.sh [算法名] [small|large]
#
# 默认参数:
#   算法: sa_basic
#   规模: small
# ============================================================

set -e

ALGO="${1:-sa_basic}"
SCALE="${2:-small}"

echo "=========================================="
echo "DOE Experiment"
echo "  Algorithm: $ALGO"
echo "  Scale: $SCALE"
echo "=========================================="

python scripts/doe/run_doe.py --algo "$ALGO" --scale "$SCALE"

echo ""
echo "DOE experiment complete."
