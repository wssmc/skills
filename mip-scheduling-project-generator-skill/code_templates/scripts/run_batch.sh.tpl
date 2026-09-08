#!/usr/bin/env bash
set -euo pipefail

project_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$project_root"

instance_root="${1:?usage: scripts/run_batch.sh INSTANCE_ROOT SOLVE_SEEDS_FILE [ALGORITHM...]}"
seed_file="${2:?usage: scripts/run_batch.sh INSTANCE_ROOT SOLVE_SEEDS_FILE [ALGORITHM...]}"
shift 2
algorithms=("$@")
if [[ -z "${SCHED_OUTPUT_ROOT:-}" ]]; then
  SCHED_OUTPUT_ROOT="$(bash scripts/lib/allocate_result_root.sh "${BASH_SOURCE[0]}" "${RESULT_VARIANT:-}")"
  export SCHED_OUTPUT_ROOT
fi
if [[ ${#algorithms[@]} -eq 0 ]]; then
  algorithms=(random_search sa_basic ma_basic ig_basic ga_basic ts_basic)
fi

[[ -d "$instance_root" ]] || { echo "instance root not found: $instance_root" >&2; exit 2; }
[[ -f "$seed_file" ]] || { echo "seed file not found: $seed_file" >&2; exit 2; }

mapfile -t seeds < <(sed -e 's/#.*$//' -e '/^[[:space:]]*$/d' "$seed_file")
[[ ${#seeds[@]} -gt 0 ]] || { echo "seed file has no seeds" >&2; exit 2; }
declare -A seen_seed=()
for seed in "${seeds[@]}"; do
  [[ "$seed" =~ ^[0-9]+$ ]] || { echo "invalid solve seed: $seed" >&2; exit 2; }
  [[ -z "${seen_seed[$seed]+x}" ]] || { echo "duplicate solve seed: $seed" >&2; exit 2; }
  seen_seed["$seed"]=1
done

mapfile -d '' -t instances < <(find "$instance_root" -mindepth 1 -maxdepth 1 -type d -print0 | sort -z)
[[ ${#instances[@]} -gt 0 ]] || { echo "no instance directories under $instance_root" >&2; exit 2; }

for index in "${!seeds[@]}"; do
  round=$((index + 1))
  solve_seed="${seeds[$index]}"
  for instance_dir in "${instances[@]}"; do
    for algorithm in "${algorithms[@]}"; do
      if [[ "$algorithm" == "cplex_mip_python" ]]; then
        scripts/run_mip.sh "$instance_dir" "$solve_seed" "$round"
      else
        scripts/run_single.sh "$instance_dir" "$algorithm" "$solve_seed" "$round"
      fi
    done
  done
done
