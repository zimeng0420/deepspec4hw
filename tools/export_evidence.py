import argparse, ast, hashlib, json, subprocess, tarfile
from pathlib import Path

parser = argparse.ArgumentParser(
    description="Export immutable source artifacts; output must be empty"
)
parser.add_argument("--source-repo", type=Path, required=True)
parser.add_argument("--output", type=Path, required=True)
parser.add_argument("--revision", default="eee5547f9a556cfbf16339f15b8037e93541485c")
args = parser.parse_args()
SRC = args.source_repo
OUT = args.output
if OUT.exists() and any(OUT.iterdir()):
    parser.error("Output directory must be empty")
REV = subprocess.check_output(
    ["git", "rev-parse", args.revision + "^{commit}"], cwd=SRC, text=True
).strip()
runs = []
models = [
    (
        "flash",
        "gemini-2.0-flash",
        "2.0flash",
        [
            "2.0flash_baseline",
            "2.0flash_LLMgen",
            "2.0flash_DeepSpec",
            "2.0flash_VRank",
            "2.0flash_DV",
        ],
        [92, 98, 106, 98, 106],
    ),
    (
        "flash_lite",
        "gemini-2.0-flash-lite",
        "2.0flash-lite",
        [
            "2.0flashlite_basline",
            "2.0flashlite_llm_spec",
            "2.0flashlite_DeepSpec",
            "2.0flashlite_VRank",
            None,
        ],
        [90, 86, 97, 89, 97],
    ),
    (
        "gpt4o",
        "gpt-4o-2024-08-06",
        "gpt4o",
        [
            "gpt4o_baseline",
            "20250911_123029_llmgen_baseline_4o0806",
            "4o_DeepSpec",
            "4o_td_0806_VRank",
            "4o0806_dv",
        ],
        [101, 103, 105, 104, 109],
    ),
    (
        "gpt4omini",
        "gpt-4o-mini-2024-07-18",
        "gpt4omini",
        [
            "4omini_baseline",
            "4omini_LLMgen",
            "4omini_DeepSpec",
            "GPT4Omini_VRank",
            "4omini_dv",
        ],
        [83, 78, 88, 89, 96],
    ),
]
for short, model, folder, names, counts in models:
    for method, name, expected in zip(
        ["baseline", "llmgen", "deepspec", "vrank", "dv"], names, counts
    ):
        runs.append(
            dict(
                run_id=f"{short}_{method}",
                kind="main",
                method=method,
                paper_model=model,
                model_provenance="paper_declared_historical_stage_models_unverified",
                source_path=f"results_in_paper/{folder}/{name}"
                if name
                else "2.0flashlite_dv",
                paper_pass=expected,
                denominator=156,
                cluster_selection="largest"
                if short == "flash"
                else "first"
                if method in ["vrank", "dv"]
                else None,
                spec_source_run=f"{short}_deepspec" if method == "dv" else None,
            )
        )
for key, path in [
    ("wo_reflection", "wo_reflection"),
    ("wo_selection", "wo_selection/ablation_study_2.0flash_wo_selection"),
    ("wo_research", "wo_websearch"),
]:
    runs.append(
        dict(
            run_id=f"flash_{key}",
            kind="ablation",
            method="deepspec",
            paper_model="gemini-2.0-flash",
            model_provenance="historical_stage_models_unverified",
            source_path=f"results_in_paper/2.0flash/ablation_study/{path}",
            paper_pass=None,
            denominator=156,
            ablation=key,
        )
    )
for d in [
    "src/deepspec",
    "experiments/reports",
    "configs",
    "data",
    "tools",
    "licenses",
]:
    (OUT / d).mkdir(parents=True, exist_ok=True)
mapping = {r["source_path"]: "paper_results/" + r["run_id"] for r in runs}
small = {
    "LICENSE": "LICENSE",
    "backend/LICENSE": "licenses/backend-LICENSE",
    "data/total_merged_data.jsonl": "data/benchmark.jsonl",
    "data/HDLBits_circuit_type.jsonl": "data/circuit_types.jsonl",
    "data/all_testbench.jsonl": "data/ranking_testbenches.jsonl",
    "data/origi156_extracted.jsonl": "data/original_specs.jsonl",
}
# Preserve reviewed artifact revisions and their original source provenance.
release_root = Path(__file__).resolve().parents[1]
overrides = {
    item["path"]: item
    for item in map(
        json.loads,
        (release_root / "experiments/artifacts.sha256.jsonl").read_text().splitlines(),
    )
    if "source_sha256" in item
}
allowed = {".v", ".sv", ".txt", ".md", ".json", ".jsonl", ".log"}
p = subprocess.Popen(
    ["git", "archive", REV, *mapping, *small], cwd=SRC, stdout=subprocess.PIPE
)
hashes = []
total = 0
with tarfile.open(fileobj=p.stdout, mode="r|") as tar:
    for item in tar:
        if not item.isfile():
            continue
        target = small.get(item.name)
        if target is None:
            for prefix, dest in mapping.items():
                if item.name.startswith(prefix + "/"):
                    rel = item.name[len(prefix) + 1 :]
                    if Path(rel).suffix not in allowed:
                        break
                    # Keep source bytes; normalize only the task directory's trailing spaces.
                    parts = rel.split("/")
                    parts[0] = parts[0].strip()
                    target = dest + "/" + "/".join(parts)
                    break
        if target is None:
            continue
        data = tar.extractfile(item).read()
        provenance = {}
        if record := overrides.get(target):
            if hashlib.sha256(data).hexdigest() != record["source_sha256"]:
                raise ValueError(f"Source differs from the reviewed artifact: {target}")
            data = (release_root / target).read_bytes()
            if hashlib.sha256(data).hexdigest() != record["sha256"]:
                raise ValueError(f"Reviewed artifact checksum mismatch: {target}")
            provenance = {
                key: record[key]
                for key in [
                    "source_sha256",
                    "source_bytes",
                    "transformation",
                    "executable_ast_sha256",
                ]
                if key in record
            }
        dst = OUT / target
        if dst.exists():
            raise RuntimeError(f"destination collision: {target}")
        dst.parent.mkdir(parents=True, exist_ok=True)
        dst.write_bytes(data)
        hashes.append(
            dict(
                path=target,
                source_path=item.name,
                sha256=hashlib.sha256(data).hexdigest(),
                bytes=len(data),
                **provenance,
            )
        )
        total += len(data)
assert p.wait() == 0
(OUT / "experiments/artifacts.sha256.jsonl").write_text(
    "".join(json.dumps(r, ensure_ascii=False) + "\n" for r in hashes)
)
(OUT / "experiments/runs.json").write_text(
    json.dumps(
        {
            "source_commit": REV,
            "runs": runs,
            "excluded": [
                "waveforms",
                "compiled binaries",
                "unverified 88/156 candidate",
                "w/o Finalization (source missing)",
            ],
        },
        ensure_ascii=False,
        indent=2,
    )
    + "\n"
)


# Extract runtime definitions directly from the committed source revision.
def source_ast(path):
    return ast.parse(
        subprocess.check_output(["git", "show", f"{REV}:{path}"], cwd=SRC, text=True)
    )


prompts = source_ast("backend/src/agent/promptsB.py")
keep = {
    "query_writer_instructions",
    "selection_instructions",
    "web_searcher_instructions",
    "answer_instructions_combinational",
    "mindtrace_instructions",
    "answer_instructions_sequential",
    "Reflection_A_Instructions",
    "Reflection_B_Instructions",
}
(OUT / "src/deepspec/prompts.py").write_text(
    '"""Verbatim live prompt strings from the source commit; see provenance."""\n\n'
    + "\n\n".join(
        ast.unparse(n)
        for n in prompts.body
        if isinstance(n, ast.Assign)
        and any(isinstance(t, ast.Name) and t.id in keep for t in n.targets)
    )
    + "\n"
)
schemas = source_ast("backend/src/agent/tools_and_schemas.py")
keep = {
    "SearchQueryList",
    "AnalyzeReport",
    "MindtraceSchema",
    "Mindtrace",
    "Reflection_A_feedback",
    "Reflection_A",
    "ConflictDetail",
    "Reflection_B",
}
(OUT / "src/deepspec/schemas.py").write_text(
    "from typing import List, Optional\nfrom pydantic import BaseModel, Field\n\n"
    + "\n\n".join(
        ast.unparse(n)
        for n in schemas.body
        if isinstance(n, ast.ClassDef) and n.name in keep
    )
    + "\n"
)
print(
    json.dumps(
        {"runs": len(runs), "files": len(hashes), "bytes": total, "source_commit": REV}
    )
)
