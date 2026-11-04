# Paper alignment (saved logs; no API calls or resimulation)

Table counts: 18/20; Fig. 6: 11/12 (includes one documented rounding exception).

| Run | Paper | Logs | Missing | Status |
| --- | ---: | ---: | ---: | --- |
| flash_baseline | 92 | 92 | 0 | count_match_provenance_unverified |
| flash_llmgen | 98 | 98 | 0 | count_match_provenance_unverified |
| flash_deepspec | 106 | 106 | 0 | count_match_provenance_unverified |
| flash_vrank | 98 | 98 | 1 | count_match_provenance_unverified |
| flash_dv | 106 | 106 | 6 | count_match_provenance_unverified |
| flash_lite_baseline | 90 | 90 | 0 | count_match_provenance_unverified |
| flash_lite_llmgen | 86 | 86 | 0 | count_match_provenance_unverified |
| flash_lite_deepspec | 97 | 97 | 3 | count_match_provenance_unverified |
| flash_lite_vrank | 89 | 89 | 5 | count_match_provenance_unverified |
| flash_lite_dv | 97 | 97 | 4 | count_match_provenance_unverified |
| gpt4o_baseline | 101 | 96 | 0 | count_mismatch |
| gpt4o_llmgen | 103 | 103 | 0 | count_match_provenance_unverified |
| gpt4o_deepspec | 105 | 105 | 0 | count_match_provenance_unverified |
| gpt4o_vrank | 104 | 104 | 0 | count_match_provenance_unverified |
| gpt4o_dv | 109 | 109 | 0 | count_match_provenance_unverified |
| gpt4omini_baseline | 83 | 83 | 0 | count_match_provenance_unverified |
| gpt4omini_llmgen | 78 | 78 | 0 | count_match_provenance_unverified |
| gpt4omini_deepspec | 88 | 96 | 0 | count_mismatch |
| gpt4omini_vrank | 89 | 89 | 0 | count_match_provenance_unverified |
| gpt4omini_dv | 96 | 96 | 2 | count_match_provenance_unverified |
| flash_wo_reflection | None | 92 | 0 | ablation_source_found |
| flash_wo_selection | None | 100 | 1 | ablation_source_found |
| flash_wo_research | None | 102 | 0 | ablation_source_found |

All denominators are 156. Count matches do not authenticate historical models.
Fig. 6 baseline CMB: 61/81 = 75.31%, paper 73.51%.
See alignment.json for candidate-choice evidence and per-task specification exceptions.

## Fig. 7 configurations (observed counts; bars have no exact labels)

| Configuration | Eval1 | Eval0 | Failed | Status |
| --- | ---: | ---: | ---: | --- |
| flash_dv | 106 | 42 | 8 | artifacts_available_exact_figure_counts_not_labeled |
| flash_deepspec | 106 | 41 | 9 | artifacts_available_exact_figure_counts_not_labeled |
| flash_wo_research | 102 | 42 | 12 | artifacts_available_exact_figure_counts_not_labeled |
| wo_finalization | unknown | unknown | unknown | unverifiable |
| flash_wo_selection | 100 | 47 | 9 | artifacts_available_exact_figure_counts_not_labeled |
| flash_vrank | 98 | 52 | 6 | artifacts_available_exact_figure_counts_not_labeled |
| flash_llmgen | 98 | 48 | 10 | artifacts_available_exact_figure_counts_not_labeled |
| flash_wo_reflection | 92 | 52 | 12 | artifacts_available_exact_figure_counts_not_labeled |
| flash_baseline | 92 | 53 | 11 | artifacts_available_exact_figure_counts_not_labeled |
