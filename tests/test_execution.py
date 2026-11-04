import os
from pathlib import Path
import pytest
from deepspec.config import RunConfig, Policy
from deepspec.runner import run
from deepspec.evaluation import classify, evaluate, simulate, task_map
from deepspec.vrank import choose
from deepspec.alignment import load_tasks
from fakes import FakeProvider

ROOT = Path(__file__).parents[1]


class FakeRTLProvider(FakeProvider):
    def __init__(self, *_):
        super().__init__()

    def chat(self, stage, prompt, schema=None):
        if stage == "codegen":
            return (
                ROOT / "paper_results/flash_baseline/notgate/top_module.v"
            ).read_text()
        return super().chat(stage, prompt, schema)


@pytest.mark.parametrize(
    "rid", [p.stem for p in sorted((ROOT / "configs").glob("*.json"))]
)
def test_all_modes_with_fake_llm_and_real_iverilog(tmp_path, rid):
    config = RunConfig.load(ROOT / f"configs/{rid}.json")
    out = tmp_path / "run"
    result = run(ROOT, config, ["notgate"], out, provider_factory=FakeRTLProvider)
    assert result[0]["status"] == "completed", result
    assert result[0]["evaluation"]["functional"]
    assert (
        evaluate(out, {"notgate": load_tasks(ROOT)["notgate"]})["summary"]["all"][
            "functional_strict"
        ]
        == 1
    )
    assert (
        run(
            ROOT,
            config,
            ["notgate"],
            out,
            resume=True,
            provider_factory=lambda *_: pytest.fail("resume reissued API call"),
        )
        == result
    )
    with pytest.raises(FileExistsError):
        run(ROOT, config, ["notgate"], out, provider_factory=FakeRTLProvider)


@pytest.mark.parametrize(
    "content,paper,strict,status",
    [
        ("PASS: Code compiled, but simulation timeout", False, False, "timeout"),
        (
            "PASS: Compilation successful, simulation had issues\nSimulation Error Output:",
            False,
            False,
            "runtime_error",
        ),
        ("Mismatches: 0\nMismatches: 2", True, False, "mismatch"),
        ("Mismatches: 01", True, False, "mismatch"),
        ("Mismatches: 0", True, True, "pass"),
        ("ERROR: something failed", False, False, "unclassified"),
        ("FAIL: Compilation failed", False, False, "compile_fail"),
    ],
)
def test_paper_and_strict_differ(tmp_path, content, paper, strict, status):
    path = tmp_path / "test_result.txt"
    path.write_text(content)
    r = classify(path)
    assert (r["functional"], r["functional_strict"], r["status"]) == (
        paper,
        strict,
        status,
    )


def test_normalization_detects_collision(tmp_path):
    (tmp_path / "circuit8").mkdir()
    (tmp_path / "circuit8 ").mkdir()
    with pytest.raises(ValueError, match="Duplicate"):
        task_map(tmp_path)


@pytest.mark.parametrize(
    "variant,status", [("broken", "fail"), ("timeout", "timeout"), ("mismatch", "pass")]
)
def test_real_simulator_failure_modes(tmp_path, variant, status):
    before = os.getcwd()
    (tmp_path / "top_module.v").write_text(
        "this is broken" if variant == "broken" else "module top_module; endmodule"
    )
    (tmp_path / "tb.v").write_text(
        "module tb; initial forever #1; endmodule"
        if variant == "timeout"
        else 'module tb; initial begin $display("Mismatches: 2"); $finish; end endmodule'
    )
    result = simulate(tmp_path, timeout=0.2)
    assert (
        result["compile_status" if variant == "broken" else "simulation_status"]
        == status
    )
    assert not result["functional"]
    assert os.getcwd() == before


def test_cluster_policies_and_eligibility():
    candidates = [
        {"sequence": [{"scenario": 1, "q": 1}], "passed": True},
        {"sequence": [{"scenario": 1, "q": 0}], "passed": False},
        {"sequence": [{"scenario": 1, "q": 0}], "passed": True},
    ]
    assert Policy().cluster_selection == "largest"
    assert choose(candidates, ["q"], "first")[0] == 0
    assert choose(candidates, ["q"], "largest")[0] == 2
    with pytest.raises(ValueError):
        choose([{"sequence": [], "passed": False}], [])


def test_resume_rejects_configuration_change(tmp_path):
    config = RunConfig.load(ROOT / "configs/flash_baseline.json")
    out = tmp_path / "run"
    run(ROOT, config, ["notgate"], out, provider_factory=FakeRTLProvider)
    config.models["codegen"].temperature = 0.4
    with pytest.raises(ValueError, match="differ"):
        run(
            ROOT,
            config,
            ["notgate"],
            out,
            resume=True,
            provider_factory=FakeRTLProvider,
        )


def test_fresh_dv_runs_graph(tmp_path):
    config = RunConfig.load(ROOT / "configs/flash_dv.json")
    result = run(
        ROOT,
        config,
        ["notgate"],
        tmp_path / "run",
        fresh_spec=True,
        provider_factory=FakeRTLProvider,
    )
    assert result[0]["evaluation"]["functional"]
    assert (tmp_path / "run/notgate/workflow_result.json").exists()
