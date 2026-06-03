# literature-matrix-review-skill v2.1

This skill supports literature search, literature matrix construction, research gap reasoning, and writing support for scheduling / manufacturing / combinatorial optimization papers.

Compared with v2, v2.1 adds:

- paper-ready problem feature matrix for Chapter 2;
- baseline candidate annotation during literature screening;
- explicit Chapter 3 problem-description writing rules;
- Chapter 4 model/method checklist only, without inventing unimplemented methods;
- Chapter 5 experiment framework, with only Section 5.1 draftable before data are available;
- clear boundary between analysis files, paper drafts, and experiment-result-dependent sections.

## Recommended workflow

```text
1. Input problem description
2. Extract problem_fingerprint
3. Generate search queries
4. Search recent high-quality papers first
5. Snowball from seed papers
6. Build reading cards
7. Fill full matrix and paper matrix
8. Mark baseline candidates
9. Build gap argument map
10. Draft Introduction and Related Work
11. Output Chapter 3 and Section 5.1 frameworks
12. Leave Chapter 4 and experiment results to user-provided implementation/data
```

## Important distinction

- `problem_feature_table_full` is for internal analysis or appendix.
- `problem_feature_table_paper` is the compressed table that can be inserted into Chapter 2.
- Chapter 5.2–5.5 must not contain fabricated results.
