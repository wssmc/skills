"""Validate this skill package and execute its generated core templates in isolation."""
from __future__ import annotations

import json
import os
import re
import shutil
import subprocess
import sys
import tempfile
from pathlib import Path


SKILL_ROOT = Path(__file__).resolve().parent.parent
PYTHON_TEMPLATE_ROOTS = {"core", "math_models", "metaheuristics", "visualization"}


def require(condition: bool, message: str) -> None:
    if not condition:
        raise AssertionError(message)


def validate_metadata() -> None:
    content = (SKILL_ROOT / "SKILL.md").read_text(encoding="utf-8")
    match = re.match(r"^---\n(.*?)\n---\n", content, flags=re.DOTALL)
    require(match is not None, "SKILL.md must start with YAML frontmatter")
    frontmatter = match.group(1)
    keys = set(re.findall(r"^([a-zA-Z0-9-]+):", frontmatter, re.MULTILINE))
    require(keys <= {"name", "description", "license", "allowed-tools", "metadata"},
            f"frontmatter contains unsupported keys: {sorted(keys)}")
    require(re.search(r"^name:\s*mip-hfsp-project-generator-skill\s*$", frontmatter, re.MULTILINE) is not None,
            "frontmatter name is missing or incorrect")
    description_match = re.search(r"^description:\s*(\S.*)$", frontmatter, re.MULTILINE)
    require(description_match is not None, "frontmatter description is missing")
    description = description_match.group(1).strip()
    require(len(description) <= 1024, "frontmatter description exceeds 1024 characters")
    require("<" not in description and ">" not in description,
            "frontmatter description contains angle brackets")
    openai_yaml = SKILL_ROOT / "agents" / "openai.yaml"
    require(openai_yaml.is_file(), "agents/openai.yaml is missing")
    openai_content = openai_yaml.read_text(encoding="utf-8")
    require("$mip-hfsp-project-generator-skill" in openai_content,
            "agents/openai.yaml default_prompt must mention the skill explicitly")
    require((SKILL_ROOT / "code_templates" / "README.md.tpl").is_file(), "root README template is missing")
    required_config_templates = {
        "problem_statement.md.tpl",
        "constraints_spec.md.tpl",
        "algorithm_requirements.md.tpl",
        "experiment_plan.md.tpl",
        "conventions.md.tpl",
        "problem_fingerprint.json.tpl",
    }
    config_templates = {path.name for path in (SKILL_ROOT / "templates" / "configs").glob("*.tpl")}
    require(
        config_templates == required_config_templates,
        f"config template set drifted: {sorted(config_templates)}",
    )
    manifest = json.loads((SKILL_ROOT / "manifest.json").read_text(encoding="utf-8"))
    require((SKILL_ROOT / manifest["structure_spec"]).is_file(), "manifest structure_spec is dangling")


def validate_templates() -> None:
    errors = []
    for path in sorted(SKILL_ROOT.rglob("*.py.tpl")):
        try:
            compile(path.read_text(encoding="utf-8"), str(path), "exec")
        except SyntaxError as exc:
            errors.append(f"{path.relative_to(SKILL_ROOT)}: {exc}")
    require(not errors, "Python template syntax errors: " + "; ".join(errors))

    batch = (SKILL_ROOT / "code_templates" / "scripts" / "sh_batch_instances_algorithms.sh.tpl").read_text(encoding="utf-8")
    require("--unified-cache" not in batch, "batch script must not advertise cross-algorithm cache sharing")
    require("|| true" not in batch, "batch script must propagate failures")
    single = (SKILL_ROOT / "code_templates" / "scripts" / "sh_single_instance.sh.tpl").read_text(encoding="utf-8")
    require("eval " not in single, "single script must not execute a string through eval")
    audit = (SKILL_ROOT / "code_templates" / "PROJECT_AUDIT.md.tpl").read_text(encoding="utf-8")
    require("Overall: NOT_RUN" in audit, "audit template must start as NOT_RUN")
    require(
        not (SKILL_ROOT / "code_templates" / "metaheuristics" / "decoding" / "incremental_eval.py.tpl").exists(),
        "a full re-decode wrapper must not be advertised as incremental evaluation",
    )
    all_python = "\n".join(
        path.read_text(encoding="utf-8")
        for path in sorted((SKILL_ROOT / "code_templates").rglob("*.py.tpl"))
    )
    require('"objective": 0.0' not in all_python, "executable templates contain a fake objective")
    registry = (SKILL_ROOT / "code_templates" / "metaheuristics" / "registry.py.tpl").read_text(encoding="utf-8")
    for name in ("random_search", "sa_basic", "ma_basic", "ig_basic", "ga_basic", "ts_basic"):
        require(f'"{name}"' in registry, f"registry is missing {name}")
    decoder = (SKILL_ROOT / "code_templates" / "metaheuristics" / "decoding" / "list_decoder.py.tpl").read_text(encoding="utf-8")
    checker = (SKILL_ROOT / "code_templates" / "metaheuristics" / "decoding" / "feasibility_checker.py.tpl").read_text(encoding="utf-8")
    require("resource_key = (s, m)" in decoder, "decoder resource key is not stage-aware")
    require("op.resource_key" in checker, "feasibility checker resource key is not stage-aware")


def materialize(project_root: Path) -> None:
    for template in (SKILL_ROOT / "code_templates").rglob("*.py.tpl"):
        relative = template.relative_to(SKILL_ROOT / "code_templates")
        output_relative = Path(str(relative)[:-4])
        destination = (
            project_root / "src" / output_relative
            if relative.parts[0] in PYTHON_TEMPLATE_ROOTS
            else project_root / output_relative
        )
        destination.parent.mkdir(parents=True, exist_ok=True)
        shutil.copy2(template, destination)
    demo = project_root / "data" / "demo" / "demo_01_10_5"
    shutil.copytree(SKILL_ROOT / "examples" / "demo_01_10_5", demo)


def validate_integration() -> None:
    with tempfile.TemporaryDirectory(prefix="mip_hfsp_skill_validation_") as temporary:
        project_root = Path(temporary)
        materialize(project_root)
        environment = os.environ.copy()
        environment["HFSP_SMOKE_SKIP_VISUALIZATION"] = "1"
        process = subprocess.run(
            [sys.executable, str(project_root / "tests" / "smoke_test.py")],
            cwd=project_root,
            env=environment,
            text=True,
            capture_output=True,
            check=False,
        )
        require(
            process.returncode == 0,
            f"materialized smoke test failed:\nSTDOUT:\n{process.stdout}\nSTDERR:\n{process.stderr}",
        )
        require("ALL SMOKE TESTS PASSED" in process.stdout, "smoke test did not report success")

        doe_script = """
import csv
import json
import random
import sys
import types
from pathlib import Path

from data.generate import generate_instance, write_instance
from data.loader import load_instance
from scripts.doe.run_doe import run_doe

fake_gantt = types.ModuleType('visualization.gantt')
def plot_gantt(schedule, output_path, title=''):
    Path(output_path).write_bytes(b'validation-gantt')
fake_gantt.plot_gantt = plot_gantt
sys.modules['visualization.gantt'] = fake_gantt
from scripts.run_baselines import run_single

runner_result = run_single(
    'data/demo/demo_01_10_5',
    'random_search',
    time_limit=0.02,
    seed=5,
    output_dir='outputs/runner_validation',
    txt_output=True,
    verbose=0,
)
runner_dir = Path('outputs/runner_validation/demo_01_10_5')
assert runner_result['violations'] == []
for suffix in ('result.json', 'schedule.json', 'trace.csv', 'gantt.png'):
    assert (runner_dir / f'random_search_{suffix}').is_file(), suffix

bad_dir = Path('data/bad_index')
bad_dir.mkdir(parents=True)
(bad_dir / 'index.json').write_text(json.dumps({
    'problem_type': 'HFSP',
    'files': {'processing_times.txt': '../demo/demo_01_10_5/processing_times.txt'},
}), encoding='utf-8')
try:
    load_instance(bad_dir)
except ValueError as exc:
    assert 'directly inside instance directory' in str(exc)
else:
    raise AssertionError('loader accepted an indexed path outside the instance directory')

seed = 123
data = generate_instance(2, 2, random.Random(seed))
write_instance(Path('data/small'), 'inst_001_2_2_01', data, seed)
path = run_doe(
    'sa_basic',
    {'initial_temperature_multiplier': [5.0], 'cooling_rate': [0.99]},
    'small',
    'outputs/doe_validation',
)
rows = list(csv.DictReader(path.open(encoding='utf-8')))
assert len(rows) == 3, rows
assert all(float(row['objective']) > 0 for row in rows), rows
print('DOE VALIDATION PASSED')
"""
        doe = subprocess.run(
            [sys.executable, "-c", doe_script],
            cwd=project_root,
            env=environment,
            text=True,
            capture_output=True,
            check=False,
        )
        require(
            doe.returncode == 0,
            f"materialized DOE validation failed:\nSTDOUT:\n{doe.stdout}\nSTDERR:\n{doe.stderr}",
        )
        require("DOE VALIDATION PASSED" in doe.stdout, "DOE validation did not report success")


def main() -> None:
    checks = [
        ("metadata", validate_metadata),
        ("templates", validate_templates),
        ("integration", validate_integration),
    ]
    for name, check in checks:
        check()
        print(f"PASS {name}")
    print("SKILL VALIDATION PASSED")


if __name__ == "__main__":
    main()
