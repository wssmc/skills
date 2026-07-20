#!/usr/bin/env bash
# 全量批量实验：按任务级结果文件断点续跑；失败立即返回非零状态。

set -euo pipefail
shopt -s nullglob

SCALE="all"
TIME_FACTOR="0.1"
ROUNDS=7
BATCH_NAME=""
UNIFIED_INIT=""
INIT_METHOD_SINGLE="neh"
INIT_METHOD_POP="neh_pop"
POSITIONAL=()

while [[ $# -gt 0 ]]; do
    case "$1" in
        --unified-init) UNIFIED_INIT="$2"; shift 2 ;;
        --init-method-single) INIT_METHOD_SINGLE="$2"; shift 2 ;;
        --init-method-pop) INIT_METHOD_POP="$2"; shift 2 ;;
        --batch-name) BATCH_NAME="$2"; shift 2 ;;
        --rounds) ROUNDS="$2"; shift 2 ;;
        *) POSITIONAL+=("$1"); shift ;;
    esac
done

if [[ ${#POSITIONAL[@]} -ge 1 ]]; then SCALE="${POSITIONAL[0]}"; fi
if [[ ${#POSITIONAL[@]} -ge 2 ]]; then TIME_FACTOR="${POSITIONAL[1]}"; fi
if [[ -z "$BATCH_NAME" ]]; then BATCH_NAME="batch_$(date +%Y%m%d_%H%M%S)"; fi

if [[ -z "$UNIFIED_INIT" ]]; then
    if [[ -t 0 ]]; then
        read -r -p "Use unified initialization within each algorithm family? [y/n] (default: y): " UNIFIED_INIT
        UNIFIED_INIT="${UNIFIED_INIT:-y}"
    else
        UNIFIED_INIT="y"
    fi
fi
if [[ "$UNIFIED_INIT" != "y" && "$UNIFIED_INIT" != "n" ]]; then
    echo "--unified-init must be y or n" >&2
    exit 2
fi

case "$SCALE" in
    all) SCALES=(small large) ;;
    small|large) SCALES=("$SCALE") ;;
    *) echo "Scale must be small, large, or all" >&2; exit 2 ;;
esac

mapfile -t ALGOS < <(PYTHONPATH=src python -c "from metaheuristics.registry import get_runnable_algorithms; print(*get_runnable_algorithms(), sep='\n')")
if [[ ${#ALGOS[@]} -eq 0 ]]; then
    echo "No runnable algorithms are registered" >&2
    exit 1
fi

echo "Batch=$BATCH_NAME scales=${SCALES[*]} rounds=$ROUNDS algorithms=${ALGOS[*]}"
echo "Each algorithm run uses an isolated EvalCache with the same fixed policy."

if [[ -f configs/conventions.md ]]; then
    printf '\n- Batch %s: unified_init=%s, single_init=%s, population_init=%s, rounds=%s, factor=%s\n' \
        "$BATCH_NAME" "$UNIFIED_INIT" "$INIT_METHOD_SINGLE" "$INIT_METHOD_POP" "$ROUNDS" "$TIME_FACTOR" \
        >> configs/conventions.md
fi

for CURRENT_SCALE in "${SCALES[@]}"; do
    python -c "
import json, random, sys
from pathlib import Path
scale, rounds = sys.argv[1], int(sys.argv[2])
seed_dir = Path('data/batch_seeds') / scale
seed_dir.mkdir(parents=True, exist_ok=True)
instances = sorted(path.name for path in (Path('data') / scale).iterdir() if path.is_dir())
rng = random.Random(20260616 + sum(ord(char) for char in scale))
(seed_dir / 'seed_table.json').write_text(json.dumps({name: rng.randrange(2**32) for name in instances}, indent=2), encoding='utf-8')
for round_index in range(1, rounds + 1):
    seeds = {name: rng.randrange(2**32) for name in instances}
    (seed_dir / f'round{round_index}.json').write_text(json.dumps(seeds, indent=2), encoding='utf-8')
" "$CURRENT_SCALE" "$ROUNDS"

    INSTANCE_DIRS=(data/"$CURRENT_SCALE"/*/)
    if [[ ${#INSTANCE_DIRS[@]} -eq 0 ]]; then
        echo "No instances found in data/$CURRENT_SCALE" >&2
        exit 1
    fi

    for ((ROUND=1; ROUND<=ROUNDS; ROUND++)); do
        ROUND_DIR="outputs/batch/$BATCH_NAME/round$ROUND/$CURRENT_SCALE"
        for INSTANCE_PATH in "${INSTANCE_DIRS[@]}"; do
            INSTANCE_NAME="$(basename "$INSTANCE_PATH")"
            SEED="$(python -c "import json,sys; print(json.load(open(sys.argv[1], encoding='utf-8'))[sys.argv[2]])" \
                "data/batch_seeds/$CURRENT_SCALE/round$ROUND.json" "$INSTANCE_NAME")"
            TIME_LIMIT="$(python -c "
import sys
sys.path[:0] = ['.', 'src']
from data.loader import load_instance
instance = load_instance(sys.argv[1])
print(max(1, int(instance.num_jobs * instance.num_stages * float(sys.argv[2]))))
" "$INSTANCE_PATH" "$TIME_FACTOR")"

            for ALGO in "${ALGOS[@]}"; do
                RESULT_FILE="$ROUND_DIR/$INSTANCE_NAME/${ALGO}_result.json"
                if [[ -s "$RESULT_FILE" ]]; then
                    if python -c "
import json, math, sys
data = json.load(open(sys.argv[1], encoding='utf-8'))
assert data.get('status') == 'Feasible'
assert isinstance(data.get('objective'), (int, float)) and math.isfinite(data['objective'])
assert data.get('violations') == []
" "$RESULT_FILE"; then
                        echo "SKIP verified: scale=$CURRENT_SCALE round=$ROUND instance=$INSTANCE_NAME algo=$ALGO"
                        continue
                    fi
                    echo "RERUN invalid completion marker: $RESULT_FILE" >&2
                fi
                COMMAND=(python scripts/run_baselines.py
                    --inst "$INSTANCE_PATH" --algo "$ALGO" --time "$TIME_LIMIT"
                    --seed "$SEED" --out "$ROUND_DIR" --txt --verbose 0)
                if [[ "$UNIFIED_INIT" == "y" ]]; then
                    COMMAND+=(--unified-init --init-method-single "$INIT_METHOD_SINGLE" --init-method-pop "$INIT_METHOD_POP")
                fi
                echo "RUN scale=$CURRENT_SCALE round=$ROUND instance=$INSTANCE_NAME algo=$ALGO time=${TIME_LIMIT}s seed=$SEED"
                "${COMMAND[@]}"
            done
        done
    done
done

echo "Batch complete: outputs/batch/$BATCH_NAME"
