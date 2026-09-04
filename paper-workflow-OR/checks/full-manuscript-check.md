# Full-Manuscript Check

Use this audit for a complete draft or when the user explicitly requests full-manuscript review.

## 1. Audit order

```text
structure
→ problem/model
→ method
→ experiments/results
→ literature/novelty
→ figures/tables/equations/naming
→ cross-section consistency
→ reproducibility
→ claim calibration
```

Resolve scientific blocking issues before polishing language.

## 2. Structural audit

Check the manuscript against `structures/scheduling-metaheuristic.md`.

Identify:
- missing responsibilities;
- duplicated content across Introduction/Related Work/Problem Description;
- Chapter 4 function-by-function organization;
- Chapter 5 topology drift;
- Conclusion claims not established earlier.

## 3. Problem/model audit

Check:
- problem name vs actual structure;
- scheduling entities/resources/routes;
- assumptions;
- special feature semantics;
- objective consistency across Abstract/Introduction/Model/Experiments/Conclusion;
- notation;
- formulation completeness;
- Big-M logic;
- illustrative example;
- complexity/property evidence.

## 4. Method audit

For manuscript-only audit, check internal scientific consistency:
- representation;
- decoder description;
- initialization;
- neighborhoods;
- mechanisms;
- pseudocode;
- flowchart;
- search integration;
- stopping/output.

When source code is supplied for internal audit, additionally use:
- `writing-specification/code-to-method-narrative.md`;
- `truthfulness/code-method-consistency.md`.

Do not assume source-code access in normal manuscript audit.

## 5. Experimental audit

Trace:

```text
raw run
→ aggregation
→ table/figure
→ statistical input
→ manuscript claim
```

Check:
- benchmark population;
- budget;
- seeds/repetitions;
- failed-run handling;
- timing scope;
- baseline source/adaptation;
- MIP status;
- statistical analysis unit/pairing/correction;
- component causality;
- neutral/negative evidence.

## 6. Literature/novelty audit

Check:
- primary-source support for key technical claims;
- literature-matrix cells;
- closest-study comparison;
- derived gap;
- contribution vs novelty distinction;
- `first/novel/no study/state-of-the-art` wording;
- official vs third-party code attribution.

## 7. Figure/table/naming audit

Check:
- figure semantics and captions;
- table semantics/titles;
- axis/unit/aggregation;
- title/caption concision;
- figure/table names do not contain result analysis;
- cross-artifact consistency.

## 8. Cross-section consistency

At minimum verify:

### Problem

```text
Abstract ↔ Introduction ↔ Chapter 3 ↔ Conclusion
```

### Contributions

```text
Introduction claim
↔ Chapter 3/4 technical content
↔ Chapter 5 validation
↔ Conclusion finding
```

### Method

```text
Chapter 4 prose ↔ pseudocode ↔ flowchart ↔ code (when available)
```

### Results

```text
table ↔ figure ↔ statistical test ↔ Abstract ↔ Conclusion
```

## 9. Reproducibility audit

Check whether the manuscript provides enough information about:
- instance source/generator;
- seeds;
- parameter settings;
- stopping budget;
- baseline source/adaptation;
- solver/version;
- aggregation;
- statistics;
- result reference definitions.

## 10. Defensive Writing and Claim Calibration

For major result/contribution statements classify:

```text
TOO STRONG
APPROPRIATELY STATED
UNNECESSARILY DEFENSIVE
```

### Too strong
Examples:
- `optimal` without certified optimality;
- `significantly` without valid test;
- `first/novel/state-of-the-art` without literature evidence;
- `proves` for empirical evidence only;
- local benchmark results generalized to all systems.

### Unnecessarily defensive
Examples:
- repeated limitations in several sections;
- frequent `It should be noted that...`;
- `based on currently available evidence` meta-language when unnecessary;
- `may possibly indicate` despite strong verified evidence;
- a caveat after every result sentence.

Truthfulness does not require weak prose. Verified evidence should be stated directly within scope.

## 11. Output format

| Severity | Location | Issue | Why it matters | Evidence/rule | Minimal repair |
|---|---|---|---|---|---|

Summary:

```text
Blocking issues: N
Major issues: N
Minor issues: N

Overall audit status:
PASS / PASS WITH MAJOR REVISIONS / FAIL DUE TO BLOCKING ISSUES
```

`PASS` means internal consistency/completeness, not guaranteed journal acceptance.
