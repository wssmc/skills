#!/bin/bash
# ============================================================
# sh_batch_instances_algorithms.sh — 全量批量 · 多轮
#
# 用法:
#   bash scripts/sh_batch_instances_algorithms.sh [small|large|all] [time_factor] [选项]
#
# 默认参数:
#   规模: all (small + large)
#   time_factor: 0.1 (批量)
#   轮数: 7
#   并行: 小规模 W=4, 大规模 W=2
#
# 一致性开关（若未提供则交互式提示）:
#   --unified-init [y|n]    所有算法使用统一初始化方法 (默认 y)
#   --unified-cache [y|n]   跨算法共享同一 EvalCache 实例 (默认 y)
#   --init-method NAME      统一初始化方法名 (默认 neh_basic)
# ============================================================

set -e

# 默认参数
SCALE="all"
TIME_FACTOR=0.1
ROUNDS=7
BATCH_NAME="batch_$(date +%Y%m%d_%H%M%S)"

# 一致性开关默认值
UNIFIED_INIT=""
UNIFIED_CACHE=""
INIT_METHOD_SINGLE="neh"       # 单解算法（SA/IG/TS）的初始化方法
INIT_METHOD_POP="neh_pop"      # 种群算法（GA/MA）的种群生成器

# 位置参数
POSITIONAL=()
while [[ $# -gt 0 ]]; do
    case $1 in
        --unified-init)
            UNIFIED_INIT="$2"; shift 2 ;;
        --unified-cache)
            UNIFIED_CACHE="$2"; shift 2 ;;
        --init-method-single)
            INIT_METHOD_SINGLE="$2"; shift 2 ;;
        --init-method-pop)
            INIT_METHOD_POP="$2"; shift 2 ;;
        *)
            POSITIONAL+=("$1"); shift ;;
    esac
done
set -- "${POSITIONAL[@]}"

if [[ $# -ge 1 ]]; then SCALE="$1"; fi
if [[ $# -ge 2 ]]; then TIME_FACTOR="$2"; fi

# ============================================================
# 交互式提示（若未提供开关）
# ============================================================
if [[ -z "$UNIFIED_INIT" ]]; then
    if [[ -t 0 ]]; then
        read -p "Use unified initialization for all algorithms? [y/n] (default: y): " UNIFIED_INIT
        UNIFIED_INIT="${UNIFIED_INIT:-y}"
    else
        UNIFIED_INIT="y"
    fi
fi

if [[ -z "$UNIFIED_CACHE" ]]; then
    if [[ -t 0 ]]; then
        read -p "Use unified EvalCache across algorithms? [y/n] (default: y): " UNIFIED_CACHE
        UNIFIED_CACHE="${UNIFIED_CACHE:-y}"
    else
        UNIFIED_CACHE="y"
    fi
fi

# 确定规模
SCALES=()
if [[ "$SCALE" == "all" ]]; then
    SCALES=("small" "large")
else
    SCALES=("$SCALE")
fi

# 默认算法：所有已注册且可运行的算法
ALGOS=($(python -c "
from metaheuristics.registry import get_runnable_algorithms
print(' '.join(get_runnable_algorithms()))
" 2>/dev/null || echo "sa_basic ma_basic ig_basic ga_basic ts_basic"))

echo "=========================================="
echo "Batch Experiment"
echo "  Scales: ${SCALES[*]}"
echo "  Algorithms: ${ALGOS[*]}"
echo "  Rounds: $ROUNDS"
echo "  Time Factor: $TIME_FACTOR"
echo "  Batch: $BATCH_NAME"
echo "  Unified Init: $UNIFIED_INIT (single: $INIT_METHOD_SINGLE, population: $INIT_METHOD_POP)"
echo "  Unified Cache: $UNIFIED_CACHE"
echo "=========================================="

# 记录本次运行的一致性设置到 configs/conventions.md
python -c "
from pathlib import Path
from datetime import date
conv = Path('configs/conventions.md')
if conv.exists():
    line = f'| {date.today()} | Batch run: unified_init=${UNIFIED_INIT}, unified_cache=${UNIFIED_CACHE}, single_init=${INIT_METHOD_SINGLE}, pop_init=${INIT_METHOD_POP} | 批量对比一致性配置 |'
    print(f'  Recording to configs/conventions.md')
    content = conv.read_text(encoding='utf-8')
    if '约定变更历史' in content:
        content = content.replace('| {YYYY-MM-DD} | 初始版本 | 项目生成 |',
                                   '| {YYYY-MM-DD} | 初始版本 | 项目生成 |\n' + line)
        conv.write_text(content, encoding='utf-8')
" 2>/dev/null || true

# 转换开关为 run_baselines.py 参数
EXTRA_ARGS=""
if [[ "$UNIFIED_INIT" == "y" ]]; then
    EXTRA_ARGS="$EXTRA_ARGS --unified-init --init-method-single $INIT_METHOD_SINGLE --init-method-pop $INIT_METHOD_POP"
fi
if [[ "$UNIFIED_CACHE" == "y" ]]; then
    EXTRA_ARGS="$EXTRA_ARGS --unified-cache"
fi

# 生成种子表
echo ""
echo "--- Generating seed tables ---"
python -c "
import json, random, os
from pathlib import Path

scales = ${SCALES[@]@Q}
for scale in scales:
    seed_dir = Path(f'data/batch_seeds/{scale}')
    seed_dir.mkdir(parents=True, exist_ok=True)
    rng = random.Random(20260616 + sum(ord(c) for c in scale))
    instances = sorted([d.name for d in Path(f'data/{scale}').iterdir() if d.is_dir()])
    seed_table = {inst: rng.randint(0, 2**32) for inst in instances}
    (seed_dir / 'seed_table.json').write_text(json.dumps(seed_table, indent=2))
    for r in range(1, 8):
        round_seeds = {inst: rng.randint(0, 2**32) for inst in instances}
        (seed_dir / f'round{r}.json').write_text(json.dumps(round_seeds, indent=2))
    print(f'  {scale}: {len(instances)} instances')
"

# 批量运行
for S in "${SCALES[@]}"; do
    echo ""
    echo "=========================================="
    echo "Scale: $S"
    echo "=========================================="

    # 并行数
    if [[ "$S" == "large" ]]; then
        WORKERS=2
    else
        WORKERS=4
    fi

    INSTANCES=$(ls -d data/$S/*/ 2>/dev/null)
    if [[ -z "$INSTANCES" ]]; then
        echo "No instances found in data/$S/"
        continue
    fi

    for ROUND in $(seq 1 $ROUNDS); do
        ROUND_DIR="outputs/batch/${BATCH_NAME}/round${ROUND}/${S}"
        if [[ -d "$ROUND_DIR" && -n "$(ls -A $ROUND_DIR 2>/dev/null)" ]]; then
            echo "  Round $ROUND: already exists, skipping (resume)"
            continue
        fi

        echo ""
        echo "--- Round $ROUND / $ROUNDS ---"

        for INST_PATH in $INSTANCES; do
            INST_NAME=$(basename "$INST_PATH")

            SEED=$(python -c "
import json
seeds = json.load(open('data/batch_seeds/$S/round${ROUND}.json'))
print(seeds.get('$INST_NAME', 42))
" 2>/dev/null || echo "42")

            TIME_LIMIT=$(python -c "
import sys; sys.path.insert(0, '.')
from data.loader import load_instance
inst = load_instance('$INST_PATH')
print(int(inst.num_jobs * inst.num_stages * $TIME_FACTOR))
" 2>/dev/null || echo "30")

            for ALGO in "${ALGOS[@]}"; do
                echo "  [$S/$ROUND] $INST_NAME x $ALGO (time=${TIME_LIMIT}s, seed=$SEED)"
                python scripts/run_baselines.py \
                    --inst "$INST_PATH" \
                    --algo "$ALGO" \
                    --time "$TIME_LIMIT" \
                    --seed "$SEED" \
                    --out "$ROUND_DIR" \
                    --workers 1 \
                    $EXTRA_ARGS || true
            done
        done
    done
done

echo ""
echo "=========================================="
echo "Batch experiment complete!"
echo "Output: outputs/batch/${BATCH_NAME}/"
echo "Consistency: unified_init=$UNIFIED_INIT, unified_cache=$UNIFIED_CACHE"
echo "=========================================="
