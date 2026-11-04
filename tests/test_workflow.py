from pathlib import Path
import pytest
from deepspec.config import RunConfig
from deepspec.workflow import Workflow
from fakes import FakeProvider
from legacy_harness import load_old, initial

ROOT = Path(__file__).parents[1]


def task(kind):
    return {
        "task_id": "fixture",
        "description": "Keep the signal correct.",
        "header": "module top_module(input a, output q);",
        "circuit_type": kind,
    }


@pytest.mark.parametrize("legacy_file", ["graphDplus.py", "gpt_graphDplus.py"])
@pytest.mark.parametrize(
    "kind,failures", [("CMB", 0), ("SEQ", 0), ("SEQ", 1), ("SEQ", 4)]
)
def test_legacy_prompt_and_output_parity(kind, failures, legacy_file):
    cfg = RunConfig.load(ROOT / "configs/flash_deepspec.json")
    cfg.prompt_date = "September 14, 2025"
    old, new = FakeProvider(b_failures=failures), FakeProvider(b_failures=failures)
    legacy = load_old(old, legacy_file)["graph"].invoke(
        initial(task(kind)), {"recursion_limit": 100}
    )
    answer, state = Workflow(cfg, new).run(task(kind))
    assert new.calls == old.calls
    assert answer == legacy["finalized_answer"]
    assert state.get("retry_reflection_count", 0) == legacy.get(
        "retry_reflection_count", 0
    )


@pytest.mark.parametrize("kind", ["CMB", "SEQ"])
def test_stage_a_bug_is_fixed_for_both_types(kind):
    cfg = RunConfig.load(ROOT / "configs/flash_deepspec.json")
    old = FakeProvider(low_a=1)
    with pytest.raises(NameError, match="result"):
        load_old(old)["graph"].invoke(initial(task(kind)))
    new = FakeProvider(low_a=1)
    answer, state = Workflow(cfg, new).run(task(kind))
    assert state["retry_count"] == 1
    assert state["is_consistent"] is True
    assert answer


def test_strict_exhaustion_is_named_policy():
    cfg = RunConfig.load(ROOT / "configs/flash_deepspec.json")
    cfg.policy.exhausted = "error"
    with pytest.raises(RuntimeError, match="retries exhausted"):
        Workflow(cfg, FakeProvider(b_failures=99)).run(task("SEQ"))


def test_multiple_queries_keep_all_results():
    cfg = RunConfig.load(ROOT / "configs/flash_deepspec.json")
    provider = FakeProvider(queries=2)
    _, state = Workflow(cfg, provider).run(task("CMB"))
    assert len(state["web_research_result"]) == 2
    assert sum(c[0] == "search" for c in provider.calls) == 2


def test_preserve_context_changes_only_retry_payload():
    cfg = RunConfig.load(ROOT / "configs/flash_deepspec.json")
    cfg.policy.retry_context = "preserve_context"
    provider = FakeProvider(b_failures=1)
    Workflow(cfg, provider).run(task("SEQ"))
    cmb_prompts = [
        prompt
        for stage, prompt, schema in provider.calls
        if stage == "finalize" and schema is None and "web evidence" in prompt
    ]
    assert len(cmb_prompts) == 4  # CMB + timing, before and after retry.


def test_search_failure_is_bounded_and_recovers():
    cfg = RunConfig.load(ROOT / "configs/flash_deepspec.json")
    provider = FakeProvider()
    attempts = []

    def search(prompt):
        attempts.append(prompt)
        if len(attempts) < 2:
            raise RuntimeError("temporary")
        return "web evidence"

    provider.search = search
    assert Workflow(cfg, provider).run(task("CMB"))[0]
    assert len(attempts) == 2
    provider.search = lambda _: ""
    with pytest.raises(RuntimeError, match="after 3 attempts"):
        Workflow(cfg, provider).run(task("CMB"))


def test_stage_b_historical_or_rule():
    cfg = RunConfig.load(ROOT / "configs/flash_deepspec.json")
    w = Workflow(cfg, FakeProvider())
    assert (
        w.after_reflection({"jaccard_similarity_value": 0, "is_consistent_B": True})
        == "__end__"
    )
    cfg.policy.stage_b_acceptance = "jaccard_only"
    from langchain_core.messages import HumanMessage

    route = w.after_reflection(
        {
            "jaccard_similarity_value": 0,
            "is_consistent_B": True,
            "messages": [HumanMessage(content="task")],
        }
    )
    assert route.node == "finalize_answer"
