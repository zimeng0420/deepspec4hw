import argparse, sys, json, hashlib, collections
from pathlib import Path

parser = argparse.ArgumentParser(
    description="Regenerate prompt profiles and historical configs from exported logs"
)
parser.add_argument("--root", type=Path, default=Path(__file__).resolve().parents[1])
root = parser.parse_args().root
sys.path.insert(0, str(root / "src"))
from deepspec.messages import template_from_log, render_log, logged_spec

runs = json.loads((root / "experiments/runs.json").read_text())["runs"]
tasks = {
    x["task_id"]: x
    for x in map(json.loads, (root / "data/benchmark.jsonl").read_text().splitlines())
}
registry = {}
reports = []
for run in runs:
    rid = run["run_id"]
    folder = root / "paper_results" / rid
    method = run["method"]
    isg = run["paper_model"].startswith("gpt")
    templates = {}
    assignments = {}
    miss = []
    for tid, task in tasks.items():
        td = folder / tid
        p = (
            td / "RTL_1/messages.md"
            if method in ["vrank", "dv"]
            else td / "messages.md"
        )
        if not p.exists():
            continue
        sp = td / "specification.md" if method == "llmgen" else td / "agent_response.md"
        if method == "dv":
            sp = (
                root
                / "paper_results"
                / run["spec_source_run"]
                / tid
                / "agent_response.md"
            )
        raw = sp.read_text() if sp.exists() else ""
        text = p.read_text()
        sent_spec = logged_spec(text, method)
        tpl = template_from_log(
            text.replace(sent_spec, "@@SPEC@@", 1) if sent_spec else text, task, ""
        )
        # Original-spec VRank used description+header as a single spec input.
        h = hashlib.sha256(tpl.encode()).hexdigest()[:16]
        templates[h] = tpl
        assignments[tid] = h
        if render_log(tpl, task, sent_spec or "", raw) != text:
            miss.append(tid)
    primary = (
        collections.Counter(assignments.values()).most_common(1)[0][0]
        if assignments
        else None
    )
    registry[rid] = {
        "templates": templates,
        "task_templates": assignments,
        "default_template": primary,
        "logged_stage": "specgen" if method == "llmgen" and isg else "codegen",
        "single_message_api_role": "user" if not isg else "system",
        "codegen_provenance": "source_inferred_not_logged"
        if method == "llmgen" and isg
        else "logged_content_api_roles_inferred_from_source",
    }
    reports.append(
        {
            "run_id": rid,
            "logged_tasks": len(assignments),
            "template_groups": len(templates),
            "roundtrip_failures": miss,
        }
    )
    model = run["paper_model"]
    provider = "openai" if isg else "google"
    stage_models = {
        name: {"provider": provider, "model": model, "temperature": temp}
        for name, temp in [
            ("selection", 0.1),
            ("query", 0.3),
            ("finalize", 0.0),
            ("reflection", 0.1),
            ("codegen", 1.0 if method in ["vrank", "dv"] else None if isg else 0.0),
            ("specgen", None if isg else 0.1),
        ]
    }
    stage_models["finalize"]["max_tokens"] = 10000
    stage_models.update(
        search={"provider": "google", "model": "gemini-2.0-flash", "temperature": 0.0},
        embedding={"provider": "google", "model": "gemini-embedding-001"},
    )
    config = dict(
        run_id=rid,
        method=method,
        models=stage_models,
        policy={"cluster_selection": run.get("cluster_selection") or "largest"},
        prompt_profile=rid,
        spec_source_run=run.get("spec_source_run"),
        provenance={
            "model_ids": "paper_declared_not_verified_from_historical_api_metadata",
            "codegen_prompt": registry[rid]["codegen_provenance"],
            "ablation": "inferred_from_missing_search_artifacts"
            if rid == "flash_wo_research"
            else "code_snapshot_available"
            if run["kind"] == "ablation"
            else None,
        },
    )
    if run.get("ablation") == "wo_reflection":
        config["reflection"] = False
    if run.get("ablation") == "wo_selection":
        config["selection"] = False
    if run.get("ablation") == "wo_research":
        config["research"] = False
    (root / "configs" / f"{rid}.json").write_text(
        json.dumps(config, ensure_ascii=False, indent=2) + "\n"
    )
(root / "experiments/prompt_profiles.json").write_text(
    json.dumps(registry, ensure_ascii=False, indent=2) + "\n"
)
(root / "experiments/reports/prompt_templates.json").write_text(
    json.dumps(reports, indent=2) + "\n"
)
for r in reports:
    print(r)
