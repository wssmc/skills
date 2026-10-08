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
- role-based case consistency across sets, indices, parameters, continuous/integer variables, and binaries;
- formulation completeness;
- complete formulation followed by one compact explanation paragraph for a standard MILP;
- Big-M logic;
- illustrative example;
- complexity/property evidence.

## 4. Method audit

For manuscript-only audit, check internal scientific consistency:
- algorithmic states and complete transitions recovered before subsection structure;
- visible subsection titles reflect scientific responsibilities rather than a reused algorithm template;
- representation;
- decoder description;
- initialization;
- neighborhoods;
- mechanisms;
- pseudocode;
- flowchart;
- search integration;
- stopping/output.
- complexity claims correctly classified as problem complexity, algorithmic complexity, or empirical computational cost;
- algorithmic complexity derived only from source code or a frozen executable specification.
- primary presentation carriers are assigned without full repetition of the same fact;
- state terms remain one-to-one and consistent across prose, figures, equations, and pseudocode.

When source code is supplied for internal audit, additionally use:
- `writing-specification/code-to-method-narrative.md`;
- `truthfulness/code-method-consistency.md`;
- `truthfulness/term-definition-consistency.md` when key terms are overloaded or operationally defined.

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
- parameter calibration lineage from candidate values through confirmation and retained settings;
- agreement between retained settings and the values actually used in later experiments;
- component analysis organized by contribution evidence and causal questions rather than implementation files or table count.

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
- final-scale legibility and unambiguous arrow routing;
- consistency across individual source figures, assembled figures, and rendered manuscript pages.
- titles, panel headings, and explanatory prose are in the manuscript rather than baked into the figure artwork;
- body citations identify the relevant figure or panel, and captions match the figure content;
- visual elements do not overlap, and flowchart/neighborhood conventions are applied consistently.
- algorithm flowcharts preserve the execution order and use the same terms, symbols, conditions, and update targets as the prose, pseudocode, and implementation;
- key operational terms have a consistent referent, unit or event, criterion, and reset or update rule, with discrepancies across the user definition, paper, and implementation disclosed;
- global best stagnation, member level lack of progress, operator failure, rounds, generations, and evaluation counts are not treated as synonyms without an explicit supported definition.
- abbreviation scope consistency: Abstract, Highlights when present, and main text each define a technical abbreviation at first occurrence;
- later abbreviation use remains consistent within each scope, without requiring ordinary terms to be abbreviated.

When approved review material has been transferred into the formal source, also apply `checks/formal-manuscript-deployment-check.md`.

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

Internally verify the contribution–technical–evidence mapping:

| Contribution | Technical landing | Experimental evidence |
|---|---|---|
| C1 | Section 3 | MIP / feasibility / exact validation |
| C2 | Section 4.x | decoder validation / component analysis |
| C3 | Section 4.x | ablation / comparison / statistics |

Do not retain an Introduction contribution without corresponding technical content and a feasible Chapter 5 evidence plan. This table is an internal audit artifact, not manuscript content.

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
