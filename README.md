# deepspec4hw — DeepSpec for Hardware

This repository contains one Python package for the paper's DeepSpec workflow, its five comparison methods, three available ablations, and the saved experimental evidence. Gemini and OpenAI use the same graph. `deepspec4hw` is a standalone Git repository on `main`, created from release commit `5fdf14fea0d29c186ad27d3e5c456688e7fd14ef`. Its public main branch starts with a new English-only root commit; neither the original development history nor earlier non-English release commits are included. The source snapshot is `eee5547f9a556cfbf16339f15b8037e93541485c`.

**The saved logs support 18 of 20 main table counts and 11 of 12 Fig. 6 values**, including one documented 0.01 display discrepancy. They do not establish the actual model used at every historical stage. See [the alignment report](experiments/reports/ALIGNMENT.md) and [paper claim registry](experiments/paper_claims.yaml) before interpreting these artifacts as a reproduction.

## Install and audit without API keys

Use Python 3.12 or newer; Icarus Verilog (`iverilog` and `vvp`) is needed for new simulation and integration tests. Keep this checkout: datasets and evidence are repository assets, not wheel package data.

```bash
python -m venv .venv
. .venv/bin/activate
python -m pip install -r requirements-lock.txt
python -m pip install --no-deps -e .
deepspec doctor
deepspec align --check --verify-data
python tools/check_english.py --history
python -m pytest -q
```

For an audit-only installation, `python -m pip install -e .` suffices. For unpinned development installation use `python -m pip install -e '.[api,test]'`. The lock file records the environment used to validate this release; no model API calls were made during validation. Publication checks reject Han-script content in files, escaped text, PDF text/metadata and reachable Git history.

`align` recomputes results from saved logs. It does not rerun RTL or call an LLM. `--check` detects an unexpected change relative to the committed report and permits the explicitly documented historical discrepancies. `--verify-data` checks every exported file against its publication SHA-256 manifest. Eleven exported files have English translations of comments or explanatory annotations; their original source hashes are retained separately. See [English artifact provenance](experiments/reports/english_publication.json). Use `--output runs/audit` to generate an additional report without changing the reference.

## Run experiments

```bash
# Validate task/configuration with no API keys, API calls, or output writes.
deepspec run --config configs/flash_deepspec.json --task-id notgate --dry-run

# Set GEMINI_API_KEY and, for GPT experiments, OPENAI_API_KEY in your environment.
# This command makes model API calls and writes a new run directory.
deepspec run --config configs/flash_deepspec.json --task-id notgate --output runs/example

deepspec evaluate --run-dir runs/example --view paper
deepspec evaluate --run-dir runs/example --view strict
```

Omitting `--task-id` runs all 156 benchmark tasks. Repeat it for a subset. `--resume` skips completed tasks and requires the same configuration, dataset, and task list. Errors remain eligible for retry. Runs use separate directories and subprocess working directories; they never modify bundled paper evidence.

| Method | Configuration suffix | Operation |
| --- | --- | --- |
| Baseline | `_baseline.json` | Description/header → RTL → golden test |
| LLMgen | `_llmgen.json` | One LLM specification → RTL → golden test |
| DeepSpec | `_deepspec.json` | Selection → queries/search → Finalization → reflection → RTL/test |
| VRank | `_vrank.json` | Original task → 10 RTL candidates → testbench clustering → selected RTL/golden test |
| DeepSpec + VRank | `_dv.json` | Saved DeepSpec specification payload → VRank; `--fresh-spec` first runs DeepSpec |

Prefixes are `flash`, `flash_lite`, `gpt4o`, and `gpt4omini`. Three Flash ablations use `flash_wo_reflection.json`, `flash_wo_selection.json`, and `flash_wo_research.json`. The research ablation is a documented reconstruction, because its code snapshot was not preserved. No w/o Finalization implementation or substitute result is presented as historical evidence.

DV defaults to the exact specification payload found in that historical DV run's prompt, including four documented exceptions to the saved same-model DeepSpec artifacts. This avoids silently regenerating or substituting evidence. `--fresh-spec` is a new experiment and records that choice in its manifest.

Each model stage has its own explicit configuration. New calls record the requested model, parameters, prompts, responses, and available API metadata in `calls.jsonl`; generated specifications, reflection data, candidate choices, compiler results and simulation results are saved separately. Historical model names in the configs follow the paper and remain unverified. API availability and stochastic outputs are not certified by the offline tests.

## Compatibility choices

The default policy retains the observed direct concatenation of CMB/timing specifications, Stage B's Jaccard-or-LLM acceptance, lost retry context, and acceptance after the retry limit. Stage A's undefined-variable crash and missing SEQ retry route are fixed. Successful CMB, SEQ, and Stage B retry traces are checked against frozen original code with fake LLMs.

VRank's general default is `largest`. The six non-Flash historical VRank/DV configs explicitly select `first`, matching their archived choices. Set `policy.cluster_selection` to `largest` for a corrected new experiment. Named policies are defined in [config.py](src/deepspec/config.py), and their evidence limits are recorded in the [claim registry](experiments/paper_claims.yaml). VRank reports the selected candidate's golden-test pass rate.

## Repository map

- `src/deepspec/`: shared graph, lazy providers, run entry point, prompt rendering, VRank and evaluator.
- `configs/`: 23 explicit historical experiment configurations.
- `data/`: benchmark, classifications, ranking testbenches and original specifications.
- `paper_results/`: 20 main runs and 3 ablations, retaining specifications, RTL, text logs and test results; no waveforms or executables.
- `experiments/`: run index, paper claims, prompt templates, SHA-256 export manifest and generated reports.
- `tests/`: offline differential and integration tests. `fixtures/legacy/` is legacy audit input with reviewed English comments/docstrings and verified equivalent executable ASTs, not a second runtime framework.
- `tools/`: reproducible evidence export/template generation tools; never needed for ordinary runs.

## License and attribution

The original repository's Apache-2.0 license is preserved at [LICENSE](LICENSE). Its backend MIT notice is preserved at [licenses/backend-LICENSE](licenses/backend-LICENSE); extracted backend code retains that notice through [NOTICE](NOTICE). The benchmark and saved experimental artifacts retain their original attribution.
