from pathlib import Path

FILES = {
    "adapted/adapter.py": "",
    "adapted/adapted_algorithm.py": "",
    "adapted/config.py": "",
    "adapted/run_adapted.py": "",
    "adapted/tests/test_adapter_interface.py": "import pytest\n\ndef test_adapter_interface_placeholder():\n    pytest.fail('Define target environment interface test')\n",
    "adapted/tests/test_target_feasibility.py": "import pytest\n\ndef test_target_feasibility_placeholder():\n    pytest.fail('Define target feasibility test')\n",
    "adapted/tests/test_objective_recompute.py": "import pytest\n\ndef test_objective_recompute_placeholder():\n    pytest.fail('Define objective recomputation test')\n",
}

def main(out="."):
    out = Path(out)
    for f, content in FILES.items():
        p = out / f
        p.parent.mkdir(parents=True, exist_ok=True)
        if not p.exists():
            p.write_text(content, encoding="utf-8")
    print(f"Created adapter skeleton under {out / 'adapted'}")

if __name__ == "__main__":
    import sys
    main(sys.argv[1] if len(sys.argv) > 1 else ".")
