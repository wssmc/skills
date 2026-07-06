#!/bin/bash
# ============================================================
# sh_bench_instance.sh — 单算例 · 多算法对比
#
# 用法:
#   bash scripts/sh_bench_instance.sh [算例路径|N_M_K|N_M] [算法1 算法2 ...]
#
# 默认参数:
#   算例: data/small/ 下第一个算例
#   算法: sa_basic ma_basic ig_basic ga_basic ts_basic
#   时间: 30 秒
# ============================================================

set -e

# 默认参数
INST=""
# 默认运行所有已注册且状态为 complete 或 runnable_mvp 的算法
ALGOS=($(python -c "
from metaheuristics.registry import get_runnable_algorithms
print(' '.join(get_runnable_algorithms()))
" 2>/dev/null || echo "sa_basic ma_basic ig_basic ga_basic ts_basic"))
TIME_LIMIT=30
OUTPUT_DIR="outputs/bench"

# 解析参数
if [[ $# -ge 1 ]]; then
    INST="$1"
    shift
fi
if [[ $# -ge 1 ]]; then
    ALGOS=("$@")
fi

# 如果 INST 为空，取 small 下第一个
if [[ -z "$INST" ]]; then
    INST=$(ls -d data/small/*/ 2>/dev/null | head -1)
    if [[ -z "$INST" ]]; then
        echo "No instances found in data/small/"
        exit 1
    fi
fi

# 自动拼接路径
if [[ ! "$INST" == */* && ! "$INST" == /* ]]; then
    for SCALE in demo small large; do
        if [[ -d "data/$SCALE/$INST" ]]; then
            INST="data/$SCALE/$INST"
            break
        fi
    done
fi

INST_NAME=$(basename "$INST")
OUTPUT_DIR="${OUTPUT_DIR}_${INST_NAME}"

echo "=========================================="
echo "Benchmark: $INST_NAME"
echo "Algorithms: ${ALGOS[*]}"
echo "Time Limit: ${TIME_LIMIT}s"
echo "=========================================="

for ALGO in "${ALGOS[@]}"; do
    echo ""
    echo "--- Running $ALGO ---"
    python scripts/run_baselines.py --inst "$INST" --algo "$ALGO" --time "$TIME_LIMIT" --out "$OUTPUT_DIR" || true
done

echo ""
echo "=========================================="
echo "Benchmark complete!"
echo "Output: $OUTPUT_DIR/${INST_NAME}/"
echo "=========================================="
