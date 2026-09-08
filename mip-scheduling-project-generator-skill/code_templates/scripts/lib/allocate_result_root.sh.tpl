#!/usr/bin/env bash
set -euo pipefail

project_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
cd "$project_root"

script_path="${1:?usage: scripts/lib/allocate_result_root.sh SCRIPT_PATH [CHANGE_TAG]}"
change_tag="${2:-}"
script_id="$(basename "$script_path" .sh)"

[[ "$script_id" =~ ^[A-Za-z0-9._-]+$ ]] || {
  echo "unsafe formal test script id: $script_id" >&2
  exit 2
}
if [[ -n "$change_tag" && ! "$change_tag" =~ ^[A-Za-z0-9._-]+$ ]]; then
  echo "RESULT_VARIANT must use letters, digits, dot, underscore or hyphen" >&2
  exit 2
fi

base="outputs/formal/$script_id"
if [[ -n "$change_tag" ]]; then
  base="${base}__${change_tag}"
fi
candidate="$base"
rerun=1
while [[ -e "$candidate" ]]; do
  candidate="${base}_${rerun}"
  rerun=$((rerun + 1))
done
mkdir -p "$candidate"
printf '%s\n' "$candidate"
