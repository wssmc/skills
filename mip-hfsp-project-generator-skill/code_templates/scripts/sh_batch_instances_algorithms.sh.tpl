#!/bin/bash
# ============================================================
# sh_batch_instances_algorithms.sh — 全量批量 · 多轮
#
# 用法:
#   bash scripts/sh_batch_instances_algorithms.sh [small|large|all] [time_factor]
#
# 默认参数:
#   规模: all (small + large)
#   time_factor: 0.1 (批量)
#   轮数: 7
#   并行: 小规模 W=4, 大规模 W=2
# ============================================================

set -e

# 默认参数
SCALE="all"
TIME_FACTOR=0.1
ROUNDS=7
BATCH_NAME="batch_$(date +%Y%m%d_%H%M%S)"

# 解析参数
if [[ $# -ge 1 ]]; then
    SCALE="$1"
fi
if [[ $# -ge 2 ]]; then
    TIME_FACTOR="$2"
fi

# 确定规模
SCALES=()
if [[ "$SCALE" == "all" ]]; then
    SCALES=("small" "large")
else
    SCALES=("$SCALE")
fi

# 默认算法
ALGOS=("sa_basic" "ma_basic" "ig_basic" "ga_basic" "ts_basic")

echo "=========================================="
echo "Batch Experiment"
echo "  Scales: ${SCALES[*]}"
echo "  Algorithms: ${ALGOS[*]}"
echo "  Rounds: $ROUNDS"
echo "  Time Factor: $TIME_FACTOR"
echo "  Batch: $BATCH_NAME"
echo "=========================================="

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

            # 从种子文件读取
            SEED=$(python -c "
import json
seeds = json.load(open('data/batch_seeds/$S/round${ROUND}.json'))
print(seeds.get('$INST_NAME', 42))
" 2>/dev/null || echo "42")

            # 计算时间限制: N_jobs * M_stages * factor
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
                    --workers 1 || true
            done
        done
    done
done

echo ""
echo "=========================================="
echo "Batch experiment complete!"
echo "Output: outputs/batch/${BATCH_NAME}/"
echo "=========================================="
