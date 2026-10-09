# Experimental Results Truthfulness

## 1. Maintain provenance

Every important result should be traceable through:

```text
raw run
→ instance-level aggregation
→ group-level aggregation
→ table/figure
→ statistical input
→ manuscript statement
```

## 2. Distinguish run-level and instance-level data

For `90 instances × 10 seeds`, possible populations include:
- 900 run-level observations;
- 90 instance-level means;
- one overall ARPD aggregated over instance-level values.

Do not mix them.

## 3. Distinguish best/mean/median/best-of-runs

These terms must match the actual aggregation.

## 4. Define RPD/ARPD reference

Possible references:
- certified optimum;
- best-known solution;
- best observed among methods;
- baseline;
- lower bound.

Different reference definitions cannot be compared as if identical.

## 5. MIP truthfulness

Distinguish:
- `OPTIMAL` / certified optimum;
- incumbent;
- best bound;
- gap;
- time-limit solution.

Only certified optima support `deviation from optimum`.

## 6. Runtime truthfulness

Confirm:
- CPU vs wall time;
- threads/processes;
- per-run vs total time;
- initialization/preprocessing included/excluded;
- solver time vs full workflow.

Different timing scopes do not support direct speed claims.

## 7. Failed/incomplete runs

Define handling for:
- crash;
- timeout;
- infeasible output;
- missing result;
- decoder failure.

Do not silently delete failures or replace them with favorable values.

## 8. Statistical analysis unit

Define:
- sample unit;
- pairing;
- repeated-run aggregation;
- sample size;
- multiplicity correction.

Do not treat repeated stochastic runs as independent problem instances merely to inflate statistical sample size.

## 9. Statistical wording

Descriptive result:

> `Method A obtains a lower ARPD than Method B.`

Inferential claim:

> `The paired difference is statistically significant after Holm adjustment.`

The latter requires a valid statistical test.

## 10. Figure/table truthfulness

Confirm figure/table semantics before narrative.

A narrow box of instance-level means supports lower between-instance dispersion, not necessarily lower run-to-run variability.

## 11. Component-analysis truthfulness

For causal component claims, keep constant:
- data;
- seed policy;
- budget;
- stopping;
- decoder;
- all non-target mechanisms.

Retune only when structural fairness requires it and disclose the rule.

Report neutral, negative, and scale-dependent findings.

## Internal Evaluation and Manuscript Reporting

Maintain an internal record of positive, neutral, negative, failed, and scale dependent results. Classify each result by whether it is exploratory or part of the declared formal experiment protocol.

The manuscript may select representative results with sufficiently complete evidence and does not need to list every exploratory failure. It must not silently remove or soften a formal result that materially changes the main conclusion, the validity of a comparison, or the scope of a claim. A concise report is acceptable only when it remains faithful to the evidence and cannot mislead the reader about the study's outcome.

Do not launch failure diagnosis or decide the next algorithm modification during ordinary writing or reporting. Those actions belong to Algorithm Iteration and require an explicit user request. When requested, retain the relevant internal evidence and make the proposed validation capable of supporting or refuting the working hypothesis.

## 12. Cross-artifact reconciliation

When the same experiment appears in multiple artifacts, verify consistent:
- population;
- metric definition;
- reference;
- aggregation;
- filtering.

Check:

```text
main table
↔ boxplot/heatmap/convergence
↔ statistical input
↔ manuscript statement
```

A value being mathematically computable does not mean two artifacts are scientifically comparable if their timing scope or aggregation differs.
