"""Read-only historical evaluation and isolated new simulations."""

import json
import re
import subprocess
from pathlib import Path
from collections import Counter


def task_map(root):
    out = {}
    for p in Path(root).iterdir():
        if not p.is_dir():
            continue
        key = p.name.strip()
        if key in out:
            raise ValueError(f"Duplicate normalized task ID: {key}")
        out[key] = p
    return out


def classify(path):
    path = Path(path)
    if not path.exists():
        return dict(
            status="missing",
            syntax_paper=False,
            syntax_strict=None,
            functional=False,
            functional_strict=False,
        )
    text = path.read_text(errors="replace")
    compiled_fail = "Compilation failed" in text
    paper_syntax = not compiled_fail
    counts = [int(n) for n in re.findall(r"Mismatches:\s*(\d+)\b", text)]
    timeout = bool(re.search(r"timeout|timed out", text, re.I))
    runtime = bool(
        re.search(
            r"Simulation (?:fail(?:ed)?|Error|tool_error)|runtime error", text, re.I
        )
    )
    functional = (
        bool(counts)
        and all(n == 0 for n in counts)
        and not any([compiled_fail, timeout, runtime, "FAIL:" in text])
    )
    syntax = (
        False
        if compiled_fail
        else True
        if counts
        or "Simulation completed" in text
        or "Compilation successful" in text
        or "Code compiled" in text
        else None
    )
    status = (
        "compile_fail"
        if compiled_fail
        else "timeout"
        if timeout
        else "runtime_error"
        if runtime
        else "pass"
        if functional
        else "mismatch"
        if counts and any(counts)
        else "unclassified"
    )
    return dict(
        status=status,
        syntax_paper=paper_syntax,
        syntax_strict=syntax,
        functional="Mismatches: 0" in text,
        functional_strict=functional,
        mismatches=counts,
    )


def evaluate(root, tasks):
    paths = task_map(root)
    rows = []
    unknown = set(paths) - set(tasks)
    if unknown:
        raise ValueError(f"Unexpected task IDs: {sorted(unknown)}")
    for tid, task in tasks.items():
        d = paths.get(tid, Path(root) / tid)
        p = d / "test_result.txt"
        if not p.exists():
            p = d / "final_golden_sim/test_result.txt"
        classified = classify(p)
        structured = p.parent / "result.json"
        if structured.exists():
            record = json.loads(structured.read_text())
            classified["syntax_strict"] = (
                True
                if record["compile_status"] == "pass"
                else False
                if record["compile_status"] == "fail"
                else None
            )
            classified["functional_strict"] = (
                record["compile_status"] == "pass"
                and record["simulation_status"] == "pass"
                and record["functional"]
            )
        rows.append(dict(task_id=tid, circuit_type=task["circuit_type"], **classified))
    summary = {}
    for kind in ["all", "CMB", "SEQ"]:
        subset = (
            rows
            if kind == "all"
            else [
                r
                for r in rows
                if (
                    "CMB"
                    if r["circuit_type"].lower() in ["cmb", "combinational"]
                    else "SEQ"
                )
                == kind
            ]
        )
        n = len(subset)
        summary[kind] = {
            "total": n,
            "functional": sum(r["functional"] for r in subset),
            "functional_strict": sum(r["functional_strict"] for r in subset),
            "syntax_paper": sum(r["syntax_paper"] for r in subset),
            "syntax_strict": sum(r["syntax_strict"] is True for r in subset),
            "syntax_unknown": sum(r["syntax_strict"] is None for r in subset),
            "statuses": dict(Counter(r["status"] for r in subset)),
        }
    return {"summary": summary, "tasks": rows}


def simulate(directory, timeout=30, compiler="iverilog", runtime="vvp"):
    directory = Path(directory).resolve()
    directory.mkdir(parents=True, exist_ok=True)
    record = {
        "compile_status": "pending",
        "simulation_status": "not_run",
        "functional": False,
    }
    for stage, cmd in [
        ("compile", [compiler, "-g2012", "-o", "sim.vvp", "top_module.v", "tb.v"]),
        ("simulation", [runtime, "sim.vvp"]),
    ]:
        try:
            result = subprocess.run(
                cmd, cwd=directory, capture_output=True, text=True, timeout=timeout
            )
        except subprocess.TimeoutExpired as e:
            record[stage + "_status"] = "timeout"
            text = e.stdout or ""
            if isinstance(text, bytes):
                text = text.decode(errors="replace")
            (directory / (stage + "_log.txt")).write_text(text)
            break
        except OSError as e:
            record[stage + "_status"] = "tool_error"
            record["error"] = str(e)
            break
        (directory / (stage + "_log.txt")).write_text(result.stdout + result.stderr)
        record[stage + "_returncode"] = result.returncode
        record[stage + "_status"] = "pass" if result.returncode == 0 else "fail"
        if result.returncode:
            break
        if stage == "simulation":
            counts = [
                int(x) for x in re.findall(r"Mismatches:\s*(\d+)\b", result.stdout)
            ]
            record["mismatches"] = counts
            record["functional"] = (
                bool(counts)
                and all(x == 0 for x in counts)
                and not re.search(
                    r"FAIL:|runtime error", result.stdout + result.stderr, re.I
                )
            )
    (directory / "result.json").write_text(json.dumps(record, indent=2) + "\n")
    if record["compile_status"] != "pass":
        content = (
            "FAIL: Compilation failed\n"
            if record["compile_status"] == "fail"
            else "ERROR: compile " + record["compile_status"] + "\n"
        )
    elif record["simulation_status"] != "pass":
        content = "FAIL: Simulation " + record["simulation_status"] + "\n"
    else:
        content = (
            "PASS: Simulation completed without errors\n"
            if record["functional"]
            else "FAIL: Functional test failed\n"
        ) + (directory / "simulation_log.txt").read_text()
    (directory / "test_result.txt").write_text(content)
    return record
