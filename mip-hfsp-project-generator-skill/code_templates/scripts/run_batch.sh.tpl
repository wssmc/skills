#!/usr/bin/env bash
set -euo pipefail

root="${1:?usage: scripts/run_batch.sh INSTANCE_ROOT ALGORITHM...}"
shift
algorithms=("$@")
if [[ ${#algorithms[@]} -eq 0 ]]; then
  algorithms=(random_search sa_basic ma_basic ig_basic ga_basic ts_basic)
fi
while IFS= read -r -d '' instance_dir; do
  for algorithm in "${algorithms[@]}"; do
    scripts/run_single.sh "$instance_dir" "$algorithm"
  done
done < <(find "$root" -mindepth 1 -maxdepth 1 -type d -print0 | sort -z)
