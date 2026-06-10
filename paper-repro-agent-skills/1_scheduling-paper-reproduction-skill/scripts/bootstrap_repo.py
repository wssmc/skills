from pathlib import Path

DIRS = [
    "src/core", "src/data", "src/algorithm", "src/experiments",
    "tests/smoke", "tests/unit", "tests/feasibility", "tests/consistency", "tests/regression",
    "docs", "artifacts"
]
FILES = {
    "src/core/problem.py": "",
    "src/core/solution.py": "",
    "src/core/decoder.py": "",
    "src/core/objective.py": "",
    "src/core/constraints.py": "",
    "src/data/data_reader.py": "",
    "src/data/data_generator.py": "",
    "src/algorithm/initialization.py": "",
    "src/algorithm/operators.py": "",
    "src/algorithm/local_search.py": "",
    "src/algorithm/acceptance.py": "",
    "src/algorithm/main_algorithm.py": "",
    "src/experiments/run_single.py": "",
    "src/experiments/run_batch.py": "",
    "requirements.txt": "pytest\n",
}

def main(out="reproduction_workspace"):
    out = Path(out)
    for d in DIRS:
        (out / d).mkdir(parents=True, exist_ok=True)
    for f, content in FILES.items():
        p = out / f
        p.parent.mkdir(parents=True, exist_ok=True)
        if not p.exists():
            p.write_text(content, encoding="utf-8")
    print(f"Created reproduction repo skeleton at {out}")

if __name__ == "__main__":
    import sys
    main(sys.argv[1] if len(sys.argv) > 1 else "reproduction_workspace")
