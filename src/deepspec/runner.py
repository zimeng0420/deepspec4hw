"""Five experiment modes with explicit output ownership and recorded requests."""

import hashlib
import json
import random
import re
import subprocess
from datetime import datetime
from pathlib import Path
from .alignment import load_tasks
from .messages import render_log, parse_log, logged_spec
from .evaluation import simulate
from .providers import Providers
from .workflow import Workflow
from .vrank import choose, sequence, historical_ports

SYSTEM = "You are the strongest AI in the world. You already have the knowledge of Verilog and hardware designing. Generate Verilog code for the given task. I will tip you $200 if you can fulfill the tasks I give you."
SUFFIX = "Please only reply with the Verilog code after syntax check, no other words.\nPlease always begin with `module top_module()`."


def clean_code(text):
    return re.sub(r"```verilog|```", "", text)


def prompts(root, config, task, spec="", stage="codegen"):
    profiles = json.loads((Path(root) / "experiments/prompt_profiles.json").read_text())
    profile = profiles[config.prompt_profile]
    if stage == "specgen" and profile["logged_stage"] != "specgen":
        # Source-inferred: Gemini's first call was overwritten by its codegen messages log.
        return [
            {
                "role": "user",
                "content": SYSTEM.replace(
                    "Generate Verilog code", "Generate a technical specification"
                )
                + task["description"]
                + "\n\nThe header you have already known is:"
                + task["header"]
                + "\n\n",
            }
        ]
    if stage == "codegen" and profile["logged_stage"] == "specgen":
        # GPT LLMgen codegen was not recorded in messages.md; exact surviving source template.
        return [
            {"role": "system", "content": SYSTEM + task["description"] + "\n\n"},
            {
                "role": "user",
                "content": "The header you have already known is:"
                + task["header"]
                + "\n\nYou can use the technical specification as follows:\n\n"
                + spec
                + "\n\n"
                + SUFFIX,
            },
        ]
    template = profile["templates"][
        profile["task_templates"].get(task["task_id"], profile["default_template"])
    ]
    text = render_log(template, task, spec)
    return parse_log(text, profile["single_message_api_role"])


def run(
    root,
    config,
    task_ids,
    output,
    resume=False,
    fresh_spec=False,
    provider_factory=Providers,
):
    root = Path(root).resolve()
    output = Path(output).resolve()
    tasks = load_tasks(root)
    if output == root or any(
        output.is_relative_to(root / p)
        for p in [
            "paper_results",
            "data",
            "configs",
            "experiments",
            "src",
            "tests",
            "docs",
        ]
    ):
        raise ValueError(
            "Output must be a new run directory, outside release evidence/code directories"
        )
    missing = set(task_ids) - set(tasks)
    if missing:
        raise ValueError(f"Unknown tasks: {sorted(missing)}")
    if len(task_ids) != len(set(task_ids)):
        raise ValueError("Duplicate requested task IDs")
    config = config.model_copy(deep=True)
    if config.prompt_date is None:
        previous = output / "manifest.json"
        config.prompt_date = (
            json.loads(previous.read_text())["config"]["prompt_date"]
            if resume and previous.exists()
            else datetime.now().strftime("%B %d, %Y")
        )
    resolved = config.model_dump()
    identity = {
        "config": resolved,
        "tasks": task_ids,
        "fresh_spec": fresh_spec,
        "benchmark_sha256": hashlib.sha256(
            (root / "data/benchmark.jsonl").read_bytes()
        ).hexdigest(),
        "ranking_tb_sha256": hashlib.sha256(
            (root / "data/ranking_testbenches.jsonl").read_bytes()
        ).hexdigest(),
    }
    fingerprint = hashlib.sha256(
        json.dumps(identity, sort_keys=True).encode()
    ).hexdigest()
    manifest = output / "manifest.json"
    if output.exists():
        if not resume or not manifest.exists():
            raise FileExistsError(
                "Run directory exists; choose a new directory or --resume"
            )
        if json.loads(manifest.read_text())["fingerprint"] != fingerprint:
            raise ValueError("Resume inputs/configuration differ")
    else:
        output.mkdir(parents=True)
        commit = subprocess.run(
            ["git", "rev-parse", "HEAD"], cwd=root, capture_output=True, text=True
        )
        manifest.write_text(
            json.dumps(
                {
                    **identity,
                    "fingerprint": fingerprint,
                    "code_commit": commit.stdout.strip() or None,
                },
                indent=2,
            )
            + "\n"
        )
    ranking_tbs = {
        x["task_id"]: x["tb"]
        for x in map(
            json.loads,
            (root / "data/ranking_testbenches.jsonl").read_text().splitlines(),
        )
    }
    statuses = []
    for tid in task_ids:
        task = tasks[tid]
        directory = output / tid
        done = directory / "complete.json"
        if resume and done.exists():
            statuses.append(json.loads(done.read_text()))
            continue
        directory.mkdir(exist_ok=True)
        provider = provider_factory(config, directory / "calls.jsonl")
        try:
            spec = ""
            if config.method in ["deepspec", "dv"]:
                if config.method == "dv" and config.spec_source_run and not fresh_spec:
                    # Replay the spec actually present in the DV prompt, including documented exceptions.
                    historical = (
                        root
                        / "paper_results"
                        / config.run_id
                        / tid
                        / "RTL_1/messages.md"
                    )
                    if not historical.exists():
                        raise ValueError(
                            f"No archived DV prompt for {tid}; use --fresh-spec"
                        )
                    spec = logged_spec(historical.read_text(), "dv")
                    (directory / "spec_source.json").write_text(
                        json.dumps(
                            {
                                "mode": "archived_prompt_payload",
                                "path": str(historical.relative_to(root)),
                                "sha256": hashlib.sha256(
                                    historical.read_bytes()
                                ).hexdigest(),
                                "declared_parent_run": config.spec_source_run,
                            },
                            indent=2,
                        )
                    )
                else:
                    spec, state = Workflow(config, provider).run(task)
                    (directory / "workflow_result.json").write_text(
                        json.dumps(state, default=str, indent=2)
                    )
                    if (
                        config.method == "dv"
                        and config.models["codegen"].provider == "google"
                    ):
                        spec = f"# Agent Response for Task: {tid}\n\n{spec}"
            elif config.method == "llmgen":
                spec = provider.chat(
                    "specgen", prompts(root, config, task, stage="specgen")
                )
            if spec is not None:
                (directory / "specification.md").write_text(spec)
            messages = prompts(root, config, task, spec or "")
            (directory / "messages.json").write_text(
                json.dumps(messages, ensure_ascii=False, indent=2)
            )
            if config.method in ["vrank", "dv"]:
                candidates = []
                for i in range(config.candidates):
                    d = directory / f"RTL_{i + 1}"
                    d.mkdir(exist_ok=True)
                    try:
                        code = clean_code(provider.chat("codegen", messages))
                        (d / "top_module.v").write_text(code)
                        (d / "tb.v").write_text(ranking_tbs[tid])
                        result = simulate(d)
                        # Retain historical ranking eligibility: nonempty TBout marks a usable run.
                        usable = (d / "TBout.txt").exists() and bool(
                            (d / "TBout.txt").read_text().strip()
                        )
                        usable = (
                            usable
                            or result["compile_status"] == "pass"
                            and result["simulation_status"] == "pass"
                        )
                        candidates.append(
                            {
                                "code": code,
                                "passed": usable,
                                "sequence": sequence(d / "TBout.txt"),
                            }
                        )
                    except Exception as e:
                        (d / "error.json").write_text(json.dumps({"error": str(e)}))
                        candidates.append({"code": "", "passed": False, "sequence": []})
                ports = historical_ports(candidates[0]["code"])
                seed = int(fingerprint[:16], 16)
                selected, clusters = choose(
                    candidates,
                    ports,
                    config.policy.cluster_selection,
                    config.policy.no_cluster,
                    random.Random(seed),
                )
                (directory / "selection.json").write_text(
                    json.dumps(
                        {
                            "policy": config.policy.cluster_selection,
                            "selected_candidate": selected + 1,
                            "clusters": clusters,
                            "fallback_seed": seed,
                            "ports": ports,
                        },
                        indent=2,
                    )
                )
                code = candidates[selected]["code"]
                simdir = directory / "final_golden_sim"
                simdir.mkdir(exist_ok=True)
            else:
                code = clean_code(provider.chat("codegen", messages))
                simdir = directory
            (simdir / "top_module.v").write_text(code)
            (simdir / "tb.v").write_text(clean_code(task["testbench"]))
            result = simulate(simdir)
            status = {"task_id": tid, "status": "completed", "evaluation": result}
            done.write_text(json.dumps(status, indent=2))
        except Exception as e:
            status = {
                "task_id": tid,
                "status": "error",
                "error_type": type(e).__name__,
                "error": str(e),
            }
            (directory / "error.json").write_text(json.dumps(status, indent=2))
        statuses.append(status)
    (output / "summary.json").write_text(json.dumps(statuses, indent=2) + "\n")
    return statuses
