#!/bin/bash
# ============================================================
# sh_single_instance.sh — 单算例 · 单算法
#
# 用法:
#   bash scripts/sh_single_instance.sh --inst <算例名|路径> --algo <算法名> [--time N] [--seed N] [--verbose 1]
#
# 默认参数:
#   --time 30        时间限制 30 秒
#   --seed (随机)     随机种子
#   --verbose 0      详细输出级别
# ============================================================

set -e

# 默认参数
INST=""
ALGO=""
TIME_LIMIT=30
SEED=""
VERBOSE=0
OUTPUT_DIR="outputs/single"

# 解析参数
while [[ $# -gt 0 ]]; do
    case $1 in
        --inst)  INST="$2"; shift 2 ;;
        --algo)  ALGO="$2"; shift 2 ;;
        --time)  TIME_LIMIT="$2"; shift 2 ;;
        --seed)  SEED="$2"; shift 2 ;;
        --verbose) VERBOSE="$2"; shift 2 ;;
        --out)   OUTPUT_DIR="$2"; shift 2 ;;
        *) echo "Unknown option: $1"; exit 1 ;;
    esac
done

if [[ -z "$INST" || -z "$ALGO" ]]; then
    echo "Usage: bash scripts/sh_single_instance.sh --inst <算例名|路径> --algo <算法名> [--time N] [--seed N] [--verbose 1]"
    exit 1
fi

# 如果 INST 不含路径分隔符，自动拼接 data 目录
if [[ ! "$INST" == */* && ! "$INST" == /* ]]; then
    for SCALE in demo small large; do
        if [[ -d "data/$SCALE/$INST" ]]; then
            INST="data/$SCALE/$INST"
            break
        fi
    done
fi

echo "=========================================="
echo "Single Instance Run"
echo "  Instance: $INST"
echo "  Algorithm: $ALGO"
echo "  Time Limit: ${TIME_LIMIT}s"
echo "=========================================="

# 构建命令
CMD="python scripts/run_baselines.py --inst $INST --algo $ALGO --time $TIME_LIMIT --out $OUTPUT_DIR --verbose $VERBOSE"
if [[ -n "$SEED" ]]; then
    CMD="$CMD --seed $SEED"
fi

echo "Command: $CMD"
eval "$CMD"

# 输出路径提示
INST_NAME=$(basename "$INST")
echo ""
echo "Output directory: $OUTPUT_DIR/${INST_NAME}/"
echo "  ${ALGO}_result.json"
echo "  ${ALGO}_schedule.json"
echo "  ${ALGO}_trace.csv"
echo "  ${ALGO}_gantt.png"
