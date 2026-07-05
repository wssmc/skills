#!/bin/bash
# ============================================================
# sh_analysis.sh — 通用结果分析
#
# 用法:
#   bash scripts/sh_analysis.sh <结果目录> [--standard auto|none|xlsx] [--profile auto] [--no-plots]
#
# 默认参数:
#   --standard auto   自动检测标准值来源
#   --profile auto    自动检测分析配置
# ============================================================

set -e

# 默认参数
RESULT_DIR=""
STANDARD="auto"
PROFILE="auto"
NO_PLOTS=false

# 解析参数
while [[ $# -gt 0 ]]; do
    case $1 in
        --standard) STANDARD="$2"; shift 2 ;;
        --profile)  PROFILE="$2"; shift 2 ;;
        --no-plots) NO_PLOTS=true; shift ;;
        *) RESULT_DIR="$1"; shift ;;
    esac
done

if [[ -z "$RESULT_DIR" ]]; then
    echo "Usage: bash scripts/sh_analysis.sh <结果目录> [--standard auto|none|xlsx] [--profile auto] [--no-plots]"
    exit 1
fi

echo "=========================================="
echo "Analysis"
echo "  Result dir: $RESULT_DIR"
echo "  Standard: $STANDARD"
echo "  Profile: $PROFILE"
echo "  No plots: $NO_PLOTS"
echo "=========================================="

# 检查 ExperimentAnalysis 是否可用
if python -c "from src.ExperimentAnalysis import analyzer" 2>/dev/null; then
    CMD="python -m src.ExperimentAnalysis.analyzer --dir $RESULT_DIR --standard $STANDARD --profile $PROFILE"
    if $NO_PLOTS; then
        CMD="$CMD --no-plots"
    fi
    eval "$CMD"
else
    echo "ExperimentAnalysis module not found (自行提供，不实现)."
    echo "Generating basic summary..."

    # 基础汇总
    python -c "
import json, os
from pathlib import Path

result_dir = Path('$RESULT_DIR')
results = []
for f in result_dir.rglob('*_result.json'):
    data = json.loads(f.read_text(encoding='utf-8'))
    results.append(data)

if results:
    print(f'Found {len(results)} result files')
    for r in sorted(results, key=lambda x: x.get('objective', float('inf'))):
        print(f\"  {r.get('method', '?'):15s}  obj={r.get('objective', 0):.4f}  time={r.get('runtime', 0):.2f}s  status={r.get('status', '?')}\")
else:
    print('No result files found.')
"
fi

echo ""
echo "Analysis complete."
