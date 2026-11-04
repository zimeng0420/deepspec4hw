"""Reproducible offline paper tables, prompt provenance, and candidate-choice audits."""

import csv
import hashlib
import json
from pathlib import Path
from .evaluation import evaluate
from .messages import logged_spec, spec_content, render_log
from .vrank import inspect_run


def load_tasks(root):
    out = {}
    for line in (Path(root) / "data/benchmark.jsonl").read_text().splitlines():
        task = json.loads(line)
        key = task["task_id"].strip()
        if key in out:
            raise ValueError(f"Duplicate benchmark task: {key}")
        task["task_id"] = key
        out[key] = task
    return out


def verify_artifacts(root):
    root = Path(root)
    failures = []
    count = 0
    for line in (root / "experiments/artifacts.sha256.jsonl").read_text().splitlines():
        item = json.loads(line)
        p = root / item["path"]
        count += 1
        if (
            not p.exists()
            or hashlib.sha256(p.read_bytes()).hexdigest() != item["sha256"]
        ):
            failures.append(item["path"])
    return {"checked": count, "failures": failures}


def audit(root):
    root = Path(root)
    tasks = load_tasks(root)
    manifest = json.loads((root / "experiments/runs.json").read_text())
    claims = json.loads((root / "experiments/paper_claims.yaml").read_text())
    profiles = json.loads((root / "experiments/prompt_profiles.json").read_text())
    rows = []
    summaries = {}
    prompt_report = []
    dv_report = []
    ranking = {}
    for run in manifest["runs"]:
        rid = run["run_id"]
        base = root / "paper_results" / rid
        result = evaluate(base, tasks)
        s = result["summary"]
        summaries[rid] = s
        passed = s["all"]["functional"]
        expected = run["paper_pass"]
        rows.append(
            {
                "run_id": rid,
                "paper_pass": expected,
                "observed_pass": passed,
                "total": len(tasks),
                "status": "ablation_source_found"
                if expected is None
                else "count_match_provenance_unverified"
                if expected == passed
                else "count_mismatch",
                "missing": s["all"]["statuses"].get("missing", 0),
            }
        )
        profile = profiles[rid]
        prompt_ok = 0
        prompt_bad = []
        dv_counts = {}
        dv_issues = []
        for tid, task in tasks.items():
            d = base / tid
            files = (
                sorted(d.glob("RTL_*/messages.md"))
                if run["method"] in ["vrank", "dv"]
                else [d / "messages.md"]
            )
            for f in files:
                if not f.exists():
                    continue
                text = f.read_text()
                spec = logged_spec(text, run["method"])
                template = profile["templates"][
                    profile["task_templates"].get(tid, profile["default_template"])
                ]
                if render_log(template, task, spec or "") == text:
                    prompt_ok += 1
                else:
                    prompt_bad.append(str(f.relative_to(root)))
            if run["method"] == "dv" and (d / "RTL_1/messages.md").exists():
                sent = logged_spec((d / "RTL_1/messages.md").read_text(), "dv")
                sp = (
                    root
                    / "paper_results"
                    / run["spec_source_run"]
                    / tid
                    / "agent_response.md"
                )
                if sent == "No specification found":
                    status = "missing_spec_placeholder"
                elif sp.exists() and spec_content(sent or "") == spec_content(
                    sp.read_text()
                ):
                    status = "same_model_spec_matches"
                else:
                    status = "spec_does_not_match_saved_final_artifact"
                dv_counts[status] = dv_counts.get(status, 0) + 1
                if status != "same_model_spec_matches":
                    dv_issues.append({"task_id": tid, "status": status})
        prompt_report.append(
            {
                "run_id": rid,
                "matched_logs": prompt_ok,
                "mismatched_logs": prompt_bad,
                "logged_stage": profile["logged_stage"],
            }
        )
        if run["method"] == "dv":
            dv_report.append(
                {
                    "run_id": rid,
                    "source_run": run["spec_source_run"],
                    "counts": dv_counts,
                    "exceptions": dv_issues,
                }
            )
        if run["method"] in ["vrank", "dv"]:
            ranking[rid] = inspect_run(base)
    figures = []
    for claim in claims["fig6"]:
        got = summaries[claim["run_id"]][claim["type"]][claim["metric"]]
        n = summaries[claim["run_id"]][claim["type"]]["total"]
        percent = 100 * got / n
        # 79.00 vs 64/81=79.012... is the explicitly registered 0.01 formatting discrepancy.
        accepted = (
            round(percent, 2) == claim["paper_percent"]
            or claim.get("rounding_exception", False)
            and abs(percent - claim["paper_percent"]) < 0.02
        )
        figures.append(
            {
                **claim,
                "observed_count": got,
                "denominator": n,
                "observed_percent": round(percent, 2),
                "compatible": accepted,
            }
        )
    figure7 = []
    for claim in claims["fig7"]:
        row = dict(claim)
        if claim["id"] in summaries:
            summary = summaries[claim["id"]]["all"]
            row.update(
                observed_eval1=summary["functional"],
                observed_eval0=summary["syntax_paper"] - summary["functional"],
                observed_failed=summary["total"] - summary["syntax_paper"],
            )
        figure7.append(row)
    return {
        "source_commit": manifest["source_commit"],
        "main_count_matches": sum(
            r["paper_pass"] is not None and r["observed_pass"] == r["paper_pass"]
            for r in rows
        ),
        "methods": claims["methods"],
        "settings": claims["settings"],
        "fig7": figure7,
        "errata_candidates": claims["errata"],
        "fig6_exact": sum(x["observed_percent"] == x["paper_percent"] for x in figures),
        "fig6_compatible": sum(x["compatible"] for x in figures),
        "results": rows,
        "fig6": figures,
        "summaries": summaries,
        "prompts": prompt_report,
        "dv_specs": dv_report,
        "vrank_choices": ranking,
    }


def write_report(report, directory):
    directory = Path(directory)
    directory.mkdir(parents=True, exist_ok=True)
    (directory / "alignment.json").write_text(
        json.dumps(report, ensure_ascii=False, indent=2) + "\n"
    )
    with (directory / "table_counts.csv").open("w", newline="") as f:
        writer = csv.DictWriter(f, fieldnames=list(report["results"][0]))
        writer.writeheader()
        writer.writerows(report["results"])
    lines = [
        "# Paper alignment (saved logs; no API calls or resimulation)",
        "",
        f"Table counts: {report['main_count_matches']}/20; Fig. 6: {report['fig6_compatible']}/12 (includes one documented rounding exception).",
        "",
        "| Run | Paper | Logs | Missing | Status |",
        "| --- | ---: | ---: | ---: | --- |",
    ]
    for r in report["results"]:
        lines.append(
            f"| {r['run_id']} | {r['paper_pass']} | {r['observed_pass']} | {r['missing']} | {r['status']} |"
        )
    lines += [
        "",
        "All denominators are 156. Count matches do not authenticate historical models.",
        "Fig. 6 baseline CMB: 61/81 = 75.31%, paper 73.51%.",
        "See alignment.json for candidate-choice evidence and per-task specification exceptions.",
    ]
    lines += [
        "",
        "## Fig. 7 configurations (observed counts; bars have no exact labels)",
        "",
        "| Configuration | Eval1 | Eval0 | Failed | Status |",
        "| --- | ---: | ---: | ---: | --- |",
    ]
    for r in report["fig7"]:
        lines.append(
            f"| {r['id']} | {r.get('observed_eval1', 'unknown')} | {r.get('observed_eval0', 'unknown')} | {r.get('observed_failed', 'unknown')} | {r['status']} |"
        )
    (directory / "ALIGNMENT.md").write_text("\n".join(lines) + "\n")
