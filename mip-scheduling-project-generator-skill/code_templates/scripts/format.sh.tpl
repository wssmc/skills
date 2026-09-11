#!/usr/bin/env bash
set -euo pipefail

project_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$project_root"
mode="${1:---write}"
case "$mode" in
    --write|--check) ;;
    *) printf 'usage: format.sh [--write|--check]\n' >&2; exit 2 ;;
esac
formatter="${CLANG_FORMAT:-clang-format}"
if ! command -v "$formatter" >/dev/null 2>&1; then
    printf 'NOT_RUN: clang-format unavailable\n' >&2
    exit 3
fi
while IFS= read -r -d '' source; do
    if [[ "$mode" == --check ]]; then
        "$formatter" --style=file --dry-run --Werror "$source"
    else
        "$formatter" --style=file -i "$source"
    fi
done < <(find cpp -type f \( -name '*.cpp' -o -name '*.hpp' -o -name '*.h' \) -print0)
