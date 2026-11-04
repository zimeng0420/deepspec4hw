# English publication provenance

The author requires the public `deepspec4hw` repository to contain no Chinese text. The original prepared release contained Han-script text in 14 tracked files: one maintenance document, the claim registry and its generated alignment report, eight legacy Python sources/snapshots, two archived RTL files with appended explanations, and one Finalize log. No Han-script filenames, escaped Han text, thesis body text or thesis metadata were found in the initial scan.

## Changes and evidence boundaries

All 14 files were translated into English. No historical test_result.txt, code-generation messages.md, dataset, specification supplied to the public runtime, or numeric evaluation result was changed. Runtime prompt constants remain unchanged.

Eleven of these files are exported source artifacts. Their records in `experiments/artifacts.sha256.jsonl` now distinguish:

- `sha256` / `bytes`: the English publication file checked by the integrity verifier;
- `source_sha256` / `source_bytes`: the original bytes at the recorded source commit and path;
- `transformation`: the declared translation category;
- `executable_ast_sha256`: for eight Python sources/snapshots, the original executable AST hash after excluding standalone documentation strings.

The original content is not disguised as Unicode escapes or encoded into a binary attachment. It remains in the original source repository and the retained local preparation worktree. The English repository preserves its provenance hashes and source paths, not the original non-English bytes.

The eight Python files changed only comments/docstrings or inactive explanatory strings. Their executable ASTs are equivalent, and differential tests still compare the effective legacy graph with the shared implementation. The two archived RTL files already contain mixed code, logs and explanatory prose; only comments and explanatory values were translated. This does not repair their historical syntax or establish that they were the exact RTL originally simulated. The Finalize log translates one repeated phrase describing the CD4017 component. These translated annotations must not be quoted as verbatim historical model output.

The maintenance plan is an English adaptation, and the claim/report descriptions are English translations. Their numerical conclusions remain separate from these editorial changes.

## Reproducing the export

`tools/english_export_translations.json` contains English replacement lines indexed by the SHA-256 of the original line, plus whole-file source and publication hashes. It contains no non-English source text. `tools/normalize_english.py` checks the exact original file hash before applying reviewed replacements and verifies the resulting hash and executable AST when applicable. `tools/export_evidence.py` applies this transformation during export. A changed source file requires a new review rather than silently reusing an old translation.

All 11 transformations were reproduced from the original committed source and compared byte-for-byte with the publication files. See `experiments/reports/english_publication.json` for this check and the full file list.

## Publication gate

Run:

```bash
python tools/check_english.py --history
deepspec align --check --verify-data
python -m pytest -q
```

The language check scans tracked and non-ignored files, filenames, literal and escaped Han characters, PDF extracted text/metadata, and reachable Git blobs/commit messages when `--history` is supplied. It rejects unrecognized binary artifacts rather than silently skipping them. The public repository starts with a new English-only root commit. Earlier preparation history is retained outside this repository, so the old texts are not included by a normal push.

The check is a script/content guard, not a general language classifier or OCR engine. English text may retain scientific symbols and standard proper names. The thesis is unchanged and its extracted text and metadata pass the guard.
