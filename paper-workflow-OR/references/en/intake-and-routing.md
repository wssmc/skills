# Intake and routing

## Route by requested outcome

Classify the primary task as Architecture, Drafting, Revision, Polishing/Translation, Audit, or Literature/Evidence. Also record the requested artifact and scope. Do not produce a full-paper template for a sentence-level edit, edit files during a read-only audit, or initiate a broad literature review for a local prose request.

## Readiness gate

Inspect supplied files and prior context first. Ask only for unresolved information that blocks the requested outcome:

| Deliverable | Minimum information normally needed |
|---|---|
| Architecture/paragraph plan | paper type, core problem/question, intended contribution, evidence state, outlet constraints if known |
| Manuscript-ready prose | facts to state, supported claims, relevant notation/results/citations, target language and section function |
| Model/method exposition | actual equations or algorithm design, symbol/interface definitions, claimed properties, evidence or proof status |
| Computational-study text | data provenance, experiment design, baselines/budgets, metrics, run-level or aggregate results, environment details that matter |
| Polishing/translation | source text and target language; outlet style only if it materially changes the revision |
| Audit | artifact to inspect, requested audit scope, and source files/results needed to test the claims |
| Direct LaTeX edit | project root/main file, requested edit scope, template, source-of-truth result files, feasible build command |

Proceed with a bounded assumption when it cannot alter technical meaning or factual claims, and disclose it outside manuscript-ready prose. For planning output, use explicit gaps rather than blocking on every unknown.

## Grouped intake questions

When questions are necessary, group the relevant subset in one message; do not send this as a mandatory questionnaire:

1. **Outlet and format:** target journal/article type, template, and material limits.
2. **Problem:** base OR problem, decisions, objective, resources, constraints, uncertainty, and application role when central.
3. **Model/theory:** formulation family, equation completeness, notation, parameter construction, and proof status.
4. **Method:** method class, representation/encoding when applicable, actual components, interfaces, pseudocode, and claimed properties.
5. **Evidence:** data, baselines, budgets, repetitions, statistical design, ablations, case/sensitivity evidence, and implementation environment.
6. **Delivery:** language, artifact, edit scope, and whether the user wants planning, prose, direct edits, or findings only.

## Manuscript-type routing

### Application/decision driven

Use when a real decision setting, decision owner, decision object, and scarce resources are central.

### Problem/method driven

Use when the contribution is a new variant, constraint, objective, or algorithm and the practical decision abstraction is secondary.

### Model/theory driven

Use when the principal contribution is formulation, decomposition, polyhedral/theoretical analysis, or an exact method.

## Related-work routing

Choose one:

- Problem/application -> model/decision formulation -> algorithm/solution method -> gap.
- Base problem -> concrete research themes -> synthesis/gap.
- Hybrid: problem/application -> specific themes -> model -> algorithm -> synthesis/gap.

## Evidence-state labels

Internally classify every item as:

- `provided evidence`;
- `verified external evidence`;
- `derivable`;
- `planned but not executed`;
- `missing`;
- `not allowed to infer`.

Use completed-study tense only for provided, verified, or directly derivable content.

When sources conflict, stop factual propagation: identify the conflict, prefer the actual data/code/result artifact for numerical claims, and ask only if the intended source of truth cannot be established safely.
