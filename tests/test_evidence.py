import json
import os
import subprocess
import sys
from pathlib import Path
import pytest
from deepspec.alignment import audit, verify_artifacts
from deepspec import prompts

ROOT = Path(__file__).parents[1]


@pytest.fixture(scope="module")
def report():
    return audit(ROOT)


def test_saved_results_match_registered_evidence(report):
    assert report == json.loads(
        (ROOT / "experiments/reports/alignment.json").read_text()
    )
    assert report["main_count_matches"] == 18
    assert report["fig6_exact"] == 10 and report["fig6_compatible"] == 11
    assert {
        r["run_id"] for r in report["results"] if r["status"] == "count_mismatch"
    } == {"gpt4o_baseline", "gpt4omini_deepspec"}
    assert (
        len(report["methods"]) == 11
        and len(report["settings"]) == 6
        and len(report["fig7"]) == 9
    )
    assert all(not r["mismatched_logs"] for r in report["prompts"])


def test_vrank_and_dv_provenance(report):
    other = [
        v["counts"]
        for k, v in report["vrank_choices"].items()
        if not k.startswith("flash_") or k.startswith("flash_lite_")
    ]
    assert sum(x.get("discriminating_tasks", 0) for x in other) == 32
    assert all(
        x["first_pick"] == x["discriminating_tasks"] and x.get("largest_pick", 0) == 0
        for x in other
    )
    assert sum(len(r["exceptions"]) for r in report["dv_specs"]) == 4


def test_every_exported_file_matches_its_publication_manifest():
    result = verify_artifacts(ROOT)
    assert result["checked"] == 107809
    assert result["failures"] == []


def test_live_prompts_preserve_original_strings():
    original = {}
    exec((ROOT / "tests/fixtures/legacy/prompts.py").read_text(), original)
    for name, value in vars(prompts).items():
        if not name.startswith("_") and isinstance(value, str):
            assert value == original[name]


def test_import_and_cli_do_not_require_api_keys():
    env = {
        k: v
        for k, v in os.environ.items()
        if not k.endswith("API_KEY") and k not in {"GOOGLE_APPLICATION_CREDENTIALS"}
    }
    result = subprocess.run(
        [
            sys.executable,
            "-c",
            "import deepspec.workflow, deepspec.providers, deepspec.runner; import langchain_google_genai, langchain_openai",
        ],
        env=env,
        capture_output=True,
        text=True,
    )
    assert result.returncode == 0, result.stderr
    result = subprocess.run(
        [
            sys.executable,
            "-m",
            "deepspec",
            "run",
            "--config",
            str(ROOT / "configs/gpt4o_deepspec.json"),
            "--task-id",
            "notgate",
            "--dry-run",
        ],
        env=env,
        capture_output=True,
        text=True,
    )
    assert result.returncode == 0, result.stderr
    assert json.loads(result.stdout)["network_calls"] == 0
