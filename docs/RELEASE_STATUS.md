# Maintenance status — 2026-11-04

The completed `paper-release` workstream is now maintained as the standalone repository `deepspec4hw`, with `main` as its primary branch. It was created from release commit `5fdf14fea0d29c186ad27d3e5c456688e7fd14ef`, retained as the local preparation source. The public English edition starts with a fresh root commit so earlier non-English files are absent from its reachable history. Its Git metadata and objects are independent of `directlt_renew_correction`; the original development history is excluded. It contains one Python package, 23 run configurations, 20 main runs, 3 available ablations, a paper claim registry, per-file provenance, offline comparison tests and a unified evaluator. Public GitHub creation and a main-branch push are authorized by the author, subject to the English-only checks. Remote publication status is reported separately from local preparation.

The original `main` worktree is retained with its existing edits. Only its authorized `docs/MAINTENANCE_PLAN.md` was updated during release preparation. The source evidence was exported from commit `eee5547f9a556cfbf16339f15b8037e93541485c`; no dirty RTL or simulation result was substituted.

## Completed release steps

1. Corrected A3 and documented dead calls, Stage A failures, lost retry context, prompt variants, VRank rules and DV exceptions.
2. Created an independent orphan `paper-release` worktree.
3. Consolidated the graph and per-stage provider configuration; fixed Stage A routing.
4. Added fake-LLM differential tests against the frozen graph.
5. Reconstructed run-specific templates and explicit VRank choice policies.
6. Added paper and strict evaluation views, ID normalization and offline alignment checks.
7. Exported committed text/source artifacts, excluding waveforms and compiled products; generated result reports and provenance hashes.
8. Documented method mappings, inferred/unknown provenance, excluded runs and erratum candidates.
9. Prepared a local root commit; no push or external publication.

## Standalone repository

The local checkout is `/home/ida/deepspec4hw`. The previous `/home/ida/directlt-paper-release` worktree remains available as the original prepared release. Runtime code and experiment configurations are retained unchanged. Eleven exported files have reviewed English translations of comments, docstrings or explanatory annotations, with original and publication hashes recorded separately; executable legacy Python ASTs are preserved. The maintenance document and claim descriptions are also in English. No remote is inherited from the source checkout.

## Validation

The original prepared release passed 59 offline tests, including both frozen Gemini/GPT graphs and all 23 configured modes with fake models and real Icarus. All 107,809 exported file hashes and 14,816 archived prompt reconstructions passed. The 11 warnings are library deprecations in the legacy harness/serializer. No live model API was called. The English edition adds publication-content and source-equivalence checks. See [validation.json](../experiments/reports/validation.json) for the latest test results and checked runtime hashes, and [English provenance](ENGLISH_PUBLICATION.md) for transformations.

## Main-branch work remains separate

The original [M0–M6 plan](MAIN_MAINTENANCE_PLAN.md) is a snapshot of the main-repository roadmap, not a statement that the main branch was refactored. Its evidence inventory, evaluator, package and tests can now be adopted from this release. Main's own migration, legacy directory archival, entry-point replacement and continuous-check integration remain to be carried out separately without erasing its development history or the author's uncommitted work.

No further local refactor can recover the absent historical model metadata, the source of the two mismatched table counts, w/o Finalization, or the exact w/o Deep Research implementation. Those remain explicitly open evidence questions.
