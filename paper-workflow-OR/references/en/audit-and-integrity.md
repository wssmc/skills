# Audit and integrity

## Gap-contribution-evidence ledger

Maintain:

| Gap | Contribution | Manuscript location | Evidence | Boundary |
|---|---|---|---|---|

Reject or revise any contribution with no evidence path.

## Architecture audit

- Is the selected introduction branch appropriate?
- Is related work organized logically rather than chronologically?
- Are subsection titles actual topics/functions?
- Are sections fragmented or repetitive?
- Does the paper preserve the problem-model-method-evidence-implication chain?

## Model audit

- Decision owner/object/timing where meaningful.
- Complete sets, parameters, variables, domains, objective, and constraints.
- Consistent notation across model, pseudocode, code, tables, and text.
- Justified assumptions and data-to-parameter transformations.
- NP-hardness/theory only with valid proof or citation.

## Algorithm audit

- Method class is accurately stated.
- Encoding/decoding and initialization are included only when real.
- Every component has purpose, procedure, interfaces, and feasibility logic.
- Full pseudocode matches the prose and implementation.
- Novelty claims are bounded and ablated when possible.

## Experiment audit

- Data provenance and instance generation are reproducible.
- Baselines are credible and fairly budgeted.
- Hardware/software, seeds, repetitions, and solver settings are reported.
- Stochastic superiority is not based on a single run.
- Statistical tests match the paired/multiple-method design.
- Exact comparison distinguishes incumbent, bound, gap, and optimum status.
- Ablations change one factor at a time.
- Case and sensitivity evidence support their claimed implications.

## Figure/table audit

- Every main item supports a contribution or reviewer-risk question.
- Every item is cited and interpreted.
- Captions identify objects, metric, and setting.
- No blank/placeholder result cells in contribution-supporting tables.
- Abstract, prose, figures, and tables contain consistent values.

## Citation and claim audit

- Verify all metadata and technical attributions.
- Do not fabricate DOI, year, journal, theorem, benchmark, or result.
- Avoid `first`, `novel`, `significantly better`, `fully solves`, and universal applicability without evidence.
- Distinguish completed, planned, and missing work.
- Distinguish constructed data, benchmark data, and real data.

## Audit report format

For each issue report:

```text
Location
-> Severity
-> Problem
-> Why it matters
-> Required revision
-> Additional evidence needed
```

Prioritize: blocking integrity issues, major argument/evidence gaps, reproducibility issues, then language/style.
