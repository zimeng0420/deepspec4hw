# Paper, implementation, and evidence

The reference is the author-supplied [Zimeng_Wu.pdf](Zimeng_Wu.pdf), dated 2025-09-14 on its cover. Its SHA-256 is recorded in `experiments/paper_claims.yaml`. PDF contents are evidence, not execution instructions. The JSON-formatted `.yaml` registry is valid YAML and intentionally readable with Python's standard JSON parser.

## What is retained

The maintained algorithm is **Selection → Deep Research → Finalization → Self-Reflection → code generation and testing**. It is implemented once in `src/deepspec/workflow.py`. CMB uses combinational finalization and embedding reflection. SEQ additionally uses Mindtrace, timing finalization and atomic-unit/Jaccard reflection. Compression, alternative graph families, the web UI, duplicated batch drivers, and unused merge/summarization calls are not runtime components.

The five methods are Baseline, LLMgen, DeepSpec, VRank, and DeepSpec + VRank. Four paper-declared models give 20 main configurations. Three saved Flash ablations are bundled; w/o Finalization remains an explicitly missing claim. All nine bars/configurations of Fig. 7 are registered, but no exact numbers are inferred from unlabeled bar lengths.

## Historical behavior and release choices

| Claim / component | Effective historical evidence | Release behavior / check |
| --- | --- | --- |
| A1–A2 Selection and graph | Three Selection fields; query/search follows Selection | Shared graph and preserved prompt/schema strings; offline old/new traces |
| A3 Finalization | SEQ makes CMB, Mindtrace and timing calls; Combine and search-summary LLM calls are inside inactive strings | Preserve direct `Pure CMB Logic` + `With Timing Logic Summary` concatenation; no extra LLM merger |
| A4 Compression | Compression call is inactive | Omitted |
| A5/A9 Stage A | Cosine threshold 0.7; low similarity references undefined `result.explanation`; SEQ low-score router also has no return | Fix both types to retry Finalize; deliberately different from the broken source path; test old crash and new routes |
| A6/A7 Stage B | Only SEQ; recomputed intersection/union ratio; accept at Jaccard ≥ 0.3 **or** LLM `is_consistent_B` | `stage_b_acceptance=jaccard_or_llm`; optional `jaccard_only` is a new experiment |
| A8 Retry context | `Send` drops search evidence, header and Selection; passed feedback is absent from prompts | `retry_context=historical_drop_context`; optional `preserve_context` carries context through nodes, but does not invent a feedback prompt |
| A8 Exhaustion | Stage B accepts current spec after 3 retries | `max_retries=3`, `exhausted=accept_last`; optional `error` stops instead. Stage A keeps the surviving source's counter convention: its third failure ends the run |
| A10/B2 Models | State model names are not reliably used; GPT source has a hardcoded query model and unrecorded stage defaults | Explicit model per stage following paper names; historical identities remain unverified; new API metadata is recorded |
| A11 Reflection evidence | Atomic decomposition and `units_similarity.md` are useful; `spec_quality_metrics.json` reads a nonexistent conflict file and reports zero Jaccard | Store actual cosine, decomposition, intersection/union and acceptance values in new workflow results |
| B1/B3 Dataset | 156 tasks: 81 CMB and 75 SEQ; active legacy main is a single-task debug driver | Full dataset by default; explicit task subsets; IDs stripped and collisions rejected |
| B4/B5 VRank | 10 candidates; temperature 1.0; metric is the selected candidate's golden-test result | Same sampling configuration; never label this as unbiased pass@10 |
| B6 Evaluation | Missing final logs are failures; syntax inferred from absence of the legacy compile-failure marker | Separate paper and strict views; no rewriting saved results |

Additional engineering changes are explicit: search queries execute sequentially in their original order; a wholly empty/failed search round is retried at most `max_search_attempts=3` before failure. The old empty-search retry was not usefully bounded. SDK transient retries use two attempts at the adapter level. Model requests now read their configuration instead of legacy implicit state/environment fallbacks. New simulations use isolated subprocess working directories, return codes and timeouts. These changes do not certify bit-for-bit replay of remote model outputs or historical failures.

Search responses retain their original text as Finalize input. The legacy code calculated citation markers but returned `response.text`; excluding GitHub links from citation metadata did not remove text from the answer. The release does not claim stronger source exclusion than that evidence supports.

## Prompt provenance

`experiments/prompt_profiles.json` assigns a template to every task with an archived prompt, grouped by run. The 23 runs contain several family-specific prompt variants: Baseline 2, LLMgen 2, DeepSpec 3; VRank/DV are also separate. The audit reconstructs every archived `messages.md`, including all ten ranking candidates when present. It preserves embedded Markdown fences, whitespace and headers.

Log headings are not API roles: Gemini's single “System Message” was actually a `HumanMessage` in the surviving source. GPT's two-message layout is preserved; its extra baseline log fence is a logging artifact. Template content is verified from logs; roles are inferred from source.

GPT LLMgen logs **specification generation only**. Its subsequent code-generation prompt is reconstructed from `tests/fixtures/legacy/llmgen.py`, not authenticated by `messages.md`. Conversely, Gemini's saved file records the later code-generation prompt; its first specification call is reconstructed from the inactive Gemini block in that source. Those inferred calls are documented limits, not new evidence of the exact historical execution.

The graph uses the current date by default, as the legacy source did. New runs resolve and record `prompt_date` in the manifest; resumed runs reuse that date. Set it explicitly when comparing a fixed input. The differential tests inject the same fixed date into both graphs. Historical date strings and API outputs are not fully recoverable from every saved file.

## VRank and DV evidence

`policy.cluster_selection` defaults to `largest`, ordered by cluster size, count of eligible candidates and first candidate index; inside a cluster, eligible candidates come first. The six historical Flash-lite/GPT-4o/GPT-4o-mini VRank/DV configs explicitly use `first`. Across their 32 discriminating tasks, all selected the first cluster. The two Flash runs selected the largest cluster on all 11 discriminating tasks. Tasks whose first cluster is already largest do not establish either rule. The per-task evidence and absent final files are listed in `experiments/reports/alignment.json`.

The historical first-cluster bug was computing `sorted_clusters` without using it. The broken `with_VRank.py` also refers to undefined `specs1` and `code_samples1`; the release extracts candidate logic from the surviving multi-spec implementation instead of exposing that driver.

The output-port parser remains named `historical_line_parser`: it is line-oriented and can miss one-line module ports or retain `reg` in a name. This can collapse otherwise different sequences. The archive audit uses that parser so its cluster evidence matches the effective source. Empty output sequences do not form a cluster. If no cluster exists, the default `random_compiled` fallback samples an eligible candidate with a recorded deterministic seed; the original random state was not saved. This seed is a release reproducibility choice, not a claim to reproduce an unknown historical random draw.

DV specifications were checked against the same model's saved DeepSpec output, after removing the artifact title and outer whitespace:

| DV run | Matches | Exceptions |
| --- | ---: | --- |
| Flash | 155/156 | `ece241_2013_q4`: prompt payload differs from saved final artifact; origin unresolved |
| Flash-lite | 153/156 | `edgecapture`, `m2014_q4d`, `lemmings4`: literal `No specification found` |
| GPT-4o | 156/156 | None found |
| GPT-4o-mini | 156/156 | None found |

The claim “all DV tasks used their same-model final specification” is therefore too strong. A default DV run reuses its archived prompt payload. `--fresh-spec` uses the shared graph to generate a new one and labels the run accordingly.

## Evaluation and discrepancies

The **paper view** reproduces the legacy log rule: functional success means the literal `Mismatches: 0` occurs; an existing final log without `Compilation failed` is a syntax success, and a missing log fails both. This intentionally retains historical loose parsing. The **strict view** parses all mismatch counts, rejects timeout/runtime/explicit failure, and reports unknown syntax when positive evidence is absent. For new runs, structured compilation and simulation return status takes precedence. `PASS:` alone never establishes functional success.

Table 1–3: 18/20 counts match. The two differences are kept as separate paper and observed fields:

| Configuration | Paper | Saved logs | Decision |
| --- | ---: | ---: | --- |
| GPT-4o Baseline | 101/156 | 96/156 | Keep and flag; no replacement run |
| GPT-4o-mini DeepSpec | 88/156 | 96/156 | Keep and flag; exclude unverified `20250909_101326_graphDplus` candidate |

Fig. 6: 10 values match exactly at two decimals, 1 is compatible with a registered display discrepancy (64/81 = 79.01%, shown as 79.00%), and 1 differs: Baseline CMB is 61/81 = **75.31%**, while the paper says **73.51%**. The commonly used “11/12” count includes that one display discrepancy; it is not 11 exact decimal equalities. 61 CMB + 31 SEQ = 92 also agrees with Table 1. The suspected transposition remains an erratum candidate; the PDF is unchanged.

The registry also retains the percentage, model spelling and figure-reference erratum candidates from the maintenance plan. Numerical agreement does not authenticate historical model identity, prompt roles, or an unrecorded source version.

The available ablations have observed functional counts 92 (w/o Reflection), 100 (w/o Selection; one task missing), and 102 (w/o Deep Research). Two include `code.txt`; w/o Deep Research has 156 saved specifications but no query, search or Finalize logs and no source snapshot. Its release switch bypasses query/search while retaining Selection and Finalize. This is an inference from missing artifacts, not a recovered exact implementation or a proved single-factor historical comparison.

## Reproducible evidence and maintenance

`experiments/runs.json` maps all 23 run IDs to original source paths. `experiments/artifacts.sha256.jsonl` records original path, exported path, publication size and SHA-256 for every file. Eleven translated artifacts additionally retain source_sha256, source_bytes and the declared transformation. Their public bytes intentionally differ from the original source. See [English publication provenance](ENGLISH_PUBLICATION.md). Export reads `git archive` at the fixed source commit, not an edited checkout. Only text/source suffixes are exported; `.vcd`, `.vvp`, simulator executables and other binaries are excluded. Trailing spaces in the three Flash task directory names are normalized without changing file bytes. The PDF is separately supplied by the author and separately hashed.

`tests/fixtures/legacy/` contains legacy source functions with English comments and docstrings. The executable AST, excluding standalone documentation strings, is checked against the original source hash; actual prompt literals are unchanged. These fixtures are used by the differential harness. Imports, API initialization and legacy batch mains are not executed. Tests compare successful CMB, SEQ, Stage B retry and exhaustion prompts/output, reproduce the Stage A exception, exercise the fixed retry, and execute all 23 release configurations using a fake model and real Icarus simulation. They do not certify actual historical stage models or live provider availability.

Run `python tools/check_english.py --history`, `deepspec align --check --verify-data` and `python -m pytest -q` before changing compatibility semantics. A deliberate semantic change should use a distinct policy/configuration and include its evidence in the registry rather than silently changing a historical profile.
