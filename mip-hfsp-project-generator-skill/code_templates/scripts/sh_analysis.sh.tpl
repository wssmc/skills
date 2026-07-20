#!/usr/bin/env bash
# 基础结果汇总：读取 *_result.json，打印并写出 analysis_summary.csv。

set -euo pipefail

if [[ $# -ne 1 ]]; then
    echo "Usage: bash scripts/sh_analysis.sh <result-directory>" >&2
    exit 2
fi
RESULT_DIR="$1"

echo "=========================================="
echo "Analysis"
echo "  Result dir: $RESULT_DIR"
echo "=========================================="

python -c "
import csv, json
import sys
from pathlib import Path

result_dir = Path(sys.argv[1]).resolve()
if not result_dir.is_dir():
    raise SystemExit(f'Not a directory: {result_dir}')
results = []
for f in result_dir.rglob('*_result.json'):
    data = json.loads(f.read_text(encoding='utf-8'))
    data['source_file'] = str(f.relative_to(result_dir))
    results.append(data)

if not results:
    raise SystemExit('No *_result.json files found')
rows = sorted(results, key=lambda item: (item.get('instance', ''), item.get('objective', float('inf'))))
fields = ['instance', 'method', 'objective', 'runtime', 'status', 'seed', 'source_file']
output = result_dir / 'analysis_summary.csv'
with output.open('w', newline='', encoding='utf-8') as stream:
    writer = csv.DictWriter(stream, fieldnames=fields, extrasaction='ignore')
    writer.writeheader()
    writer.writerows(rows)
print(f'Found {len(rows)} result files')
for row in rows:
    print(f\"  {row.get('instance', '?'):20s} {row.get('method', '?'):15s} obj={float(row['objective']):.4f}\")
print(f'Wrote {output}')
" "$RESULT_DIR"

echo "Analysis complete."
