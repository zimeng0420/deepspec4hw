# deepspec4hw — DeepSpec for Hardware

This repository contains one Python package for the paper's DeepSpec workflow, its five comparison methods, three available ablations, and the saved experimental evidence. Gemini and OpenAI use the same graph.
## Install and audit without API keys

Use Python 3.12 or newer; Icarus Verilog (`iverilog` and `vvp`) is needed for new simulations. Keep this checkout: datasets and evidence are repository assets, not wheel package data.

```bash
python -m venv .venv
. .venv/bin/activate
python -m pip install -r requirements-lock.txt
python -m pip install --no-deps -e .
deepspec doctor
deepspec align --check --verify-data
```

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

## Repository map

- `src/deepspec/`: shared graph, lazy providers, run entry point, prompt rendering, VRank and evaluator.
- `configs/`: 23 explicit historical experiment configurations.
- `data/`: benchmark, classifications, ranking testbenches and original specifications.
- `paper_results/`: 20 main runs and 3 ablations, retaining specifications, RTL, text logs and test results; no waveforms or executables.
- `experiments/`: run index, paper claims, prompt templates, SHA-256 export manifest and generated reports.
- `tools/`: evidence export and prompt-template generation. The exporter preserves reviewed artifact revisions using the saved manifest and source hashes; keep this checkout available when exporting.

## License and attribution

The original repository's Apache-2.0 license is preserved at [LICENSE](LICENSE). Its backend MIT notice is preserved at [licenses/backend-LICENSE](licenses/backend-LICENSE); extracted backend code retains that notice through [NOTICE](NOTICE). The benchmark and saved experimental artifacts retain their original attribution.
