# Audit and integrity

Audit before rewriting. Record what was actually inspected and distinguish observed defects from unverified risks. If result files, code, logs, or full text are unavailable, state the resulting limit instead of treating absence of evidence as evidence of absence.

## Severity

- **Blocking:** fabrication, invalid central model/theory, unrecoverable source inconsistency, or missing evidence that invalidates a principal conclusion/submission artifact.
- **Major:** a contribution, comparison, reproducibility claim, or central section is materially unsupported or misleading but repairable.
- **Minor:** localized clarity, consistency, reporting, or formatting defect that does not change the central conclusion.
- **Suggestion:** optional improvement with no demonstrated correctness or integrity impact.

## Gap-contribution-evidence ledger

Maintain:

| Gap | Contribution | Manuscript location | Evidence | Boundary |
|---|---|---|---|---|

Flag every contribution with no evidence path; recommend deletion, narrowing, relabelling as planned work, or the specific evidence needed.

## Source-of-truth audit

For numerical and algorithmic claims, trace manuscript text and displayed artifacts back to the most authoritative available source: raw/processed result file, code/configuration/log, generated table/figure input, then manually transcribed prose. Report conflicts rather than choosing the most favorable value.

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
- Failed runs, infeasible outputs, neutral results, and unfavorable instance groups are accounted for rather than silently excluded.
- Calibration/training and final evaluation data roles are separated or their overlap is disclosed.

## Figure/table audit

- Every main item supports a research/evidence question, contribution, reproducibility need, or reviewer-risk question.
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
- Check for selective reporting: abstract/conclusions, main tables, appendix, and source results should cover the same stated experiment population or explain exclusions.

## Audit report format

For each issue report:

```text
Location
-> Severity
-> Problem
-> Evidence observed
-> Why it matters
-> Required revision
-> Additional evidence needed
```

Prioritize blocking integrity issues, major argument/evidence gaps, reproducibility issues, then minor language/style defects. Do not bury the highest-risk findings inside a chronological walkthrough.

See the [audit finding example](../../examples/en/audit-output.md) for the expected evidence-first issue format.
