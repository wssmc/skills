from pathlib import Path

TEST_FILES = [
    "tests/unit/test_data_reader.py",
    "tests/unit/test_problem.py",
    "tests/unit/test_solution.py",
    "tests/unit/test_decoder.py",
    "tests/unit/test_objective.py",
    "tests/unit/test_operators.py",
    "tests/feasibility/test_machine_capacity.py",
    "tests/feasibility/test_operation_precedence.py",
    "tests/feasibility/test_missing_operations.py",
    "tests/feasibility/test_objective_recompute.py",
    "tests/consistency/test_main_loop_matches_pseudocode.py",
    "tests/consistency/test_initialization_matches_paper.py",
    "tests/consistency/test_operator_set_matches_paper.py",
    "tests/consistency/test_acceptance_matches_paper.py",
    "tests/consistency/test_stopping_condition_matches_protocol.py",
    "tests/consistency/test_parameters_match_registry.py",
    "tests/consistency/test_ablation_switches.py",
    "tests/regression/test_small_known_instance.py",
    "tests/regression/test_seed_reproducibility.py",
]

def main(out="."):
    out = Path(out)
    for f in TEST_FILES:
        p = out / f
        p.parent.mkdir(parents=True, exist_ok=True)
        if not p.exists():
            p.write_text("import pytest\n\n\ndef test_placeholder_fails_until_specified():\n    pytest.fail('Replace placeholder with paper-specific test')\n", encoding="utf-8")
    print(f"Created test skeleton under {out / 'tests'}")

if __name__ == "__main__":
    import sys
    main(sys.argv[1] if len(sys.argv) > 1 else ".")
