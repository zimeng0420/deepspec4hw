# DeepSpec maintenance plan: checking alignment with the paper

Updated 2026-11-04. This is an English adaptation of the original main-repository plan. Main's M0-M6 migration remains separate from the completed release implementation. The standalone publication repository is now `deepspec4hw`; the original main worktree and its existing edits remain protected.

The repository should answer three questions: **Does it agree with the paper? Where does it differ? Why?** Code consolidation, evaluation and archival work support that objective. Each paper claim should point to code, configuration or per-task evidence and have an explicit verification status.

References: the author-supplied [thesis](Zimeng_Wu.pdf), [alignment explanation](PAPER_ALIGNMENT.md), [claim registry](../experiments/paper_claims.yaml), and [saved-log counts](../experiments/reports/table_counts.csv).

## 1. Alignment scope and acceptance criteria

| Layer | Checks | Paper reference |
| --- | --- | --- |
| Method | Node order, CMB/SEQ branches, reflection acceptance, stage models | Section 3.1, Figs. 1-5 |
| Experiment settings | Dataset and classification, model IDs, search/embedding models, sampling count, temperature, metrics | Section 4.1, Table 4 |
| Results | Table 1-3 counts and percentages, Fig. 6 by circuit type, Fig. 7 configurations and qualitative conclusions | Sections 4.2-4.5 |
| Paper consistency | Arithmetic, figure/table references and model spelling | Entire thesis |

Use separate statuses for consistent evidence, numerical agreement with unverified provenance, explained differences, unresolved differences, erratum candidates, and unverifiable claims. Keep paper values, saved-log values and new-run values in separate fields. Never change an experiment log to make it agree with the paper.

Acceptance criteria:

- Every main table value, Fig. 6 value, Fig. 7 configuration, method claim A1-A11 and setting claim B1-B6 has a status and evidence path.
- One offline command regenerates the alignment report without API credentials.
- The paper evaluation view reproduces currently supported values and explains discrepancies per task.
- New runs record requested and returned model IDs, thresholds, retry limits, candidate counts and temperatures.
- A single DeepSpec graph, provider layer, five method configurations and shared evaluator replace duplicated Gemini/OpenAI graph implementations.

This work does not introduce new algorithms, model experiments or UI features.

## 2. Findings and current release status

The original source review examined `backend/src/agent/graph/graphD+.py`, `gpt_graphD+.py` and saved ablation `code.txt` snapshots. Surviving source is not automatically the exact code used in the paper. The complete A1-A11 and B1-B6 evidence is retained in the [registry](../experiments/paper_claims.yaml).

| IDs | Finding | Release decision |
| --- | --- | --- |
| A1-A2 | Selection, query/search, Finalize and reflection are the effective chain; Selection has three insight fields | Preserve the effective chain and structured schemas |
| A3-A4 | SEQ calls CMB, Mindtrace and timing finalization; merge, search-summary and Compression calls are inactive strings | Concatenate the two summaries directly; remove inactive calls from runtime |
| A5/A9 | Low Stage A cosine raises NameError; the SEQ retry router also lacks a return | Repair both routes and test the legacy failure separately |
| A6-A8 | Stage B is SEQ-only; acceptance is Jaccard >= 0.3 or an LLM boolean; retry exhaustion accepts the current spec; retry messages lose context | Preserve these differences as named policies |
| A10/B2 | Historical per-stage model identity is not authenticated | Configure stages explicitly for new runs and keep historical provenance unverified |
| A11 | Atomic decomposition and unit-similarity records are useful; a separate Jaccard quality field is always zero because it reads a missing file | Use the actual records and save measured values for new runs |
| B1/B3 | Dataset has 156 tasks: 81 CMB and 75 SEQ; the surviving main driver is a one-task debug script | Default the unified entry point to the full dataset |
| B4/B5 | Direct sampling and VRank use different candidate/temperature settings; VRank measures a selected candidate, not unbiased pass@10 | Make settings explicit and label the metric accurately |
| B6 | Missing final results count as syntax failures under the paper view | Keep paper and strict evaluation separate |

### Results

Table 1-3: **18 of 20 counts agree** with saved logs. GPT-4o Baseline has 96 observed passes against 101 in the paper. GPT-4o-mini DeepSpec has 96 against 88. The candidate `20250909_101326_graphDplus` has 88/156 but no authenticated model record; it is excluded from the release rather than substituted.

Fig. 6: **10 values agree exactly at two decimals, one has a registered 0.01 display discrepancy, and one differs**. The shorthand 11/12 includes the display discrepancy.

| Configuration | CMB functional | CMB syntax | SEQ functional | SEQ syntax |
| --- | --- | --- | --- | --- |
| Baseline | 61/81 = 75.31%; paper 73.51% | 79/81 = 97.53% | 31/75 = 41.33% | 66/75 = 88.00% |
| VRank | 64/81 = 79.01%; paper 79.00% | 80/81 = 98.77% | 34/75 = 45.33% | 70/75 = 93.33% |
| DeepSpec + VRank | 66/81 = 81.48% | 78/81 = 96.30% | 40/75 = 53.33% | 70/75 = 93.33% |

73.51% cannot be expressed as an integer count out of 81. The 61 CMB plus 31 SEQ successes also reproduce Table 1's 92. The apparent digit transposition remains an erratum candidate; the PDF is unchanged.

Available Flash ablations have 92 passes without Reflection, 100 without Selection (one missing final task log), and 102 without Deep Research. Without Finalization has no located source run or code snapshot. The first two ablations include `code.txt`, but differences beyond the removed component mean a strict single-factor historical comparison is not established. Without Deep Research has 156 saved specifications but no query/search/Finalize artifacts or source snapshot; its release implementation is explicitly inferred.

The three Flash DeepSpec task directories `circuit8`, `circuit9` and `circuit10` originally had trailing spaces. Normalize task IDs and reject collisions.

### Prompt, VRank and DV provenance

- Reconstruct prompts from each run's `messages.md`. Baseline, LLMgen and DeepSpec have multiple template variants; current scripts represent only some of them.
- GPT LLMgen logs specification generation only; code generation is inferred from source. Gemini LLMgen logs the later code-generation call; its initial specification call is inferred. Log labels do not establish API roles: Gemini's single System-labeled message was a HumanMessage in source.
- The six non-Flash VRank/DV runs selected the first cluster in all 32 distinguishing tasks. The two Flash runs selected the largest cluster in all 11 distinguishing tasks. General policy defaults to largest; six historical configurations explicitly select first.
- `with_VRank.py` refers to undefined `specs1` and `code_samples1`. Extract usable shared logic from the multi-spec implementation rather than exposing the broken driver.
- DV matches the same model's saved DeepSpec specification in 155/156 Flash tasks, 153/156 Flash-lite tasks, and all GPT-4o/mini tasks. Flash `ece241_2013_q4` differs from its saved final artifact. Flash-lite `edgecapture`, `m2014_q4d` and `lemmings4` used the literal `No specification found`.
- Default DV reuses the specification payload actually recorded in its prompt. `--fresh-spec` is an explicitly new experiment.

### Paper erratum candidates

The registry preserves candidates concerning Baseline CMB 73.51%; Table 3 values 57.10% versus 89/156 = 57.05%; mini DV 61.53% versus 96/156 = 61.54% and related improvements; Table 2 model spelling; a missing minus sign in Section 4.3; incorrect figure/table references in Section 4.4; column counts in Section 4.2; and the selected-candidate meaning of VRank pass@1. Authors decide whether to publish corrections.

### Completed release work

The release consolidates one package and graph, 23 configurations, 20 main runs and three available ablations. Evidence was exported from source commit `eee5547f9a556cfbf16339f15b8037e93541485c`, excluding dirty worktree RTL, waveforms and compiled products. The prepared release contains 107,809 exported files and 14,816 reconstructible prompt logs.

The original implementation passed 59 offline tests, including both legacy graphs, CMB/SEQ paths, Stage B retries and exhaustion, the Stage A repair, and one task under all 23 configurations using fake LLMs and real Icarus simulation. English publication additionally translates comments/documentation in the identified artifacts, retains their original hashes, verifies executable Python AST equivalence and repeats relevant checks. See [release status](RELEASE_STATUS.md) for current validation.

Completing this independent release **does not mean main's M0-M6 migration, archival or entry-point replacement is complete**. Main can adopt the release package, evaluator, evidence index and tests while retaining its development history and uncommitted work.

## 3. Priorities

P0: preserve evidence, register uncertain historical model IDs, trace the two mismatched counts and missing ablation, unify evaluation, and replace misleading quality fields with measured values for new runs.

P1: make reflection policies explicit, repair Stage A, consolidate duplicated graphs and generation drivers, remove hardcoded task/model paths, isolate simulations and replace unusable test entry points.

P2: archive unused implementations only after provenance is registered. The original repository tracks 243,442 files, including 28,314 compiled products and 7,294 VCD files. Filename or date alone is not sufficient grounds for deletion.

## 4. Target structure for the original main repository

The following remains a migration target for main. The standalone release instead uses `src/deepspec/` and root-level `tests/`.

```text
backend/src/deepspec/
  cli.py
  config.py  schemas.py  workflow.py  artifacts.py
  stages/
  providers/
  generation/
  evaluation/
  alignment/
  prompts/
backend/tests/
configs/models/  configs/experiments/  configs/ablations/
data/benchmark/  data/derived/
experiments/
  paper_claims.yaml
  manifests/
  reports/
runs/
archive/
docs/
```

Each claim needs an ID, paper location, statement and paper value, checking method, evidence path, observed value, status and notes. Check numerical claims automatically; progressively replace manual method judgments with offline tests. Configure each model stage, reflection threshold, acceptance rule, retry limit, exhaustion behavior, candidate count and temperature explicitly.

## 5. Implementation stages and acceptance

Keep algorithm changes, directory moves and report regeneration in reviewable commits.

### M0: Freeze the worktree and evidence (P0)

Record the current commit, changes and untracked-file hashes. Protect existing edits to circuit7, dualedge and edgedetect2. Assign stable run IDs while retaining source paths, including root-level DV/candidate runs and ablation code snapshots. Record the thesis hash.

Acceptance: protected files remain verifiable; no bulk directory deletion based on date or name.

### M1: Claim registry and read-only alignment audit (P0)

Register all 20 main results, 12 Fig. 6 values, nine Fig. 7 configurations, qualitative conclusions, A1-A11, B1-B6 and erratum candidates. Recompute from task logs without writing historical directories. Investigate the two mismatched counts and missing Finalization ablation; preserve unresolved status if evidence is absent. Compare ablation snapshots with the surviving graph and label any reconstructed full-run configuration as a candidate. Use legitimately available records of historical model IDs; do not manufacture an identity when none is recorded.

Acceptance: every claim has a status, differences have evidence paths, and the offline report reproduces 18/20 main-count agreement and Fig. 6's 10 exact plus one compatible display discrepancy. Deliver the registry, report, unresolved-evidence list and erratum table.

### M2: Unified evaluator (P0)

Separate compilation, simulation and functional status. Missing logs, timeouts and errors never establish strict functional success. Keep paper denominators 156/81/75 and its treatment of missing final results; report missing, timeout, compilation failure and mismatch separately in the strict view. Normalize task IDs and reject duplicates. Use per-task subprocess working directories and explicit compilation/simulation timeouts. Distinguish direct single-candidate and VRank selected-candidate metrics.

Acceptance: paper results match M1; explain every difference from old counters. Test zero/nonzero mismatches, misleading PASS labels, compilation failure, timeout, absent logs, duplicate/spaced IDs and independent simulation directories.

### M3: Shared core and explicit method behavior (P1)

Consolidate the Gemini/GPT nodes into one graph. Preserve prompts, effective node order and generation parameters. Name the 0.7/0.3 thresholds, Jaccard-or-LLM rule, retry limits and exhaustion policy. Fix stage-model configuration explicitly and document differences from legacy defaults. Reproduce Stage A's old failures before testing its repaired Finalize routing. Initialize API clients lazily. Produce ablations from configuration; do not describe a new Finalization ablation as recovered historical evidence.

Acceptance: one graph supports both providers; method tests cover node order, CMB/SEQ branching, the three SEQ finalization calls and direct concatenation, thresholds, retry limits and requested stage models. Update A1-A11 accordingly.

### M4: Unified experiment entry points and run records (P1)

Consolidate Baseline, LLMgen and VRank common logic. Keep generation inputs, ranking testbenches and golden evaluation distinct; never feed reference RTL or evaluation answers into generation. Provide `run`, `evaluate`, `align` and `doctor`, with a network-free dry run. Record resolved configuration, requested/returned model IDs, prompt/input hashes, source version/worktree state, thresholds, candidates, temperatures, measured costs and per-task status. Unknown costs remain unknown. Resume only matching inputs/configurations and never overwrite historical evidence.

Repair package and entry-point metadata, remove machine-specific paths and validate Python 3.12. The release commands in README are implemented; older proposed main-repository command forms are not compatibility guarantees.

Acceptance: installation and execution outside the checkout work; help, doctor and offline evaluation/alignment require no keys; new-run records support method/model checks.

### M5: Archive old code and products (P2)

Wait until the registry and unified entry points are stable. Confirm references, hashes and recovery before moving files. Archive old graph families, UI/main drivers and duplicates only after checking that no paper run or ablation depends on them. Preserve referenced result locations through the run index. Deduplicate loose specification JSONL files by content hash with reference records. Remove regenerated executables from tracking and keep waveforms only when needed; .gitignore alone does not untrack files.

Acceptance: alignment results are unchanged, moved artifacts retain their hashes, and a sample task can be restored. Main's development history is not rewritten by this archival stage; the standalone English publication has its own fresh history.

### M6: Continuous alignment checks

Run import/config/task checks, log parsing, method tests, VRank selection, small Icarus tests and alignment by default. Unexpected claim regressions fail the checks. Express provider differences through configuration; require manifests for new experiments and separate versions/comparisons for changed algorithms or prompts. Do not add new official graphF.py or copy.py entry points. Full 156-task model runs are new experiments for validating behavior changes, never replacements for paper snapshots.

Acceptance: README works in a new environment; altered evidence or policy thresholds are detected; reports regenerate from the registry and saved results. The public repository also enforces English-only tracked content.

## 6. Rollback and commit order

Preserve source/configuration mappings for each stage. Add shared modules and compatibility readers before changing entry points; remove old entry points separately. Append differences instead of rewriting old reports. Unknown model identity and mismatched prompt/input hashes keep a run provisional without blocking structural improvements.

Recommended main migration order: (1) evidence freeze and run index; (2) registry and audit; (3) paper/strict evaluator; (4) isolated simulator; (5) shared core, stage models and method tests; (6) entry points, records and resume; (7) archival and documentation. Begin with stages 1-3 so alignment is reproducible before large structural moves.

## 7. Ongoing maintenance

Run offline checks and alignment for each code change. Version changed prompts/configurations/policies separately. Verify inputs before formal experiments and generate both evaluation views afterward. At the end of a research iteration, review unresolved evidence and errata and test archive recovery. Do not delete unverified runs on a schedule. If a historical model is unavailable, retain its configuration and logs and label experiments with available replacements as new runs.
