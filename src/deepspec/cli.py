"""CLI operations are offline unless the run command is explicitly invoked."""

import argparse
import importlib.util
import json
import os
import shutil
from pathlib import Path
from .config import RunConfig
from .alignment import audit, write_report, verify_artifacts, load_tasks
from .evaluation import evaluate


def main(argv=None):
    parser = argparse.ArgumentParser(prog="deepspec")
    parser.add_argument(
        "--root",
        type=Path,
        default=Path(__file__).resolve().parents[2],
        help="Release checkout containing data/ and experiments/",
    )
    sub = parser.add_subparsers(dest="command", required=True)
    sub.add_parser("doctor")
    align = sub.add_parser("align")
    align.add_argument("--check", action="store_true")
    align.add_argument("--verify-data", action="store_true")
    align.add_argument("--output", type=Path)
    ev = sub.add_parser("evaluate")
    ev.add_argument("--run-dir", type=Path, required=True)
    ev.add_argument("--view", choices=["paper", "strict"], default="paper")
    run = sub.add_parser("run")
    run.add_argument("--config", type=Path, required=True)
    run.add_argument("--task-id", action="append")
    run.add_argument("--output", type=Path)
    run.add_argument("--dry-run", action="store_true")
    run.add_argument("--resume", action="store_true")
    run.add_argument("--fresh-spec", action="store_true")
    args = parser.parse_args(argv)
    root = args.root.resolve()
    if args.command == "doctor":
        print(
            json.dumps(
                {
                    "root": str(root),
                    "benchmark": (root / "data/benchmark.jsonl").is_file(),
                    "iverilog": shutil.which("iverilog"),
                    "vvp": shutil.which("vvp"),
                    "google_api_adapter": bool(
                        importlib.util.find_spec("langchain_google_genai")
                    ),
                    "openai_api_adapter": bool(
                        importlib.util.find_spec("langchain_openai")
                    ),
                    "GEMINI_API_KEY_set": bool(os.getenv("GEMINI_API_KEY")),
                    "OPENAI_API_KEY_set": bool(os.getenv("OPENAI_API_KEY")),
                },
                indent=2,
            )
        )
        return 0
    if args.command == "align":
        report = audit(root)
        changed = False
        if args.check:
            expected = json.loads(
                (root / "experiments/reports/alignment.json").read_text()
            )
            changed = report != expected
        integrity = verify_artifacts(root) if args.verify_data else None
        if args.output:
            if (
                args.output.resolve() == (root / "experiments/reports").resolve()
                and args.check
            ):
                raise ValueError("--check cannot overwrite its reference report")
            write_report(report, args.output)
        print(
            json.dumps(
                {
                    "main_matches": report["main_count_matches"],
                    "fig6_compatible": report["fig6_compatible"],
                    "unexpected_report_change": changed,
                    "integrity": integrity,
                },
                indent=2,
            )
        )
        return int(changed or integrity is not None and bool(integrity["failures"]))
    if args.command == "evaluate":
        tasks = load_tasks(root)
        manifest = args.run_dir / "manifest.json"
        if manifest.exists():
            tasks = {k: tasks[k] for k in json.loads(manifest.read_text())["tasks"]}
        result = evaluate(args.run_dir, tasks)
        if args.view == "paper":
            summary = {
                k: {
                    "total": v["total"],
                    "functional": v["functional"],
                    "syntax": v["syntax_paper"],
                }
                for k, v in result["summary"].items()
            }
        else:
            summary = {
                k: {**v, "functional": v["functional_strict"]}
                for k, v in result["summary"].items()
            }
        print(json.dumps({"view": args.view, "summary": summary}, indent=2))
        return 0
    config_path = args.config if args.config.exists() else root / args.config
    config = RunConfig.load(config_path)
    tasks = load_tasks(root)
    ids = args.task_id or list(tasks)
    if len(ids) != len(set(ids)) or set(ids) - set(tasks):
        parser.error("Unknown or duplicate task IDs")
    if args.dry_run:
        print(
            json.dumps(
                {
                    "config": config.model_dump(),
                    "task_ids": ids,
                    "output": str(args.output) if args.output else None,
                    "network_calls": 0,
                },
                indent=2,
            )
        )
        return 0
    if not args.output:
        parser.error("run requires --output; use a new directory for each experiment")
    from .runner import run as execute

    result = execute(root, config, ids, args.output, args.resume, args.fresh_spec)
    print(json.dumps(result, indent=2))
    return int(any(x["status"] == "error" for x in result))


if __name__ == "__main__":
    raise SystemExit(main())
