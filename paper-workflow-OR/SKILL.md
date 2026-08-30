---
name: paper-workflow-or
description: Draft, revise, or audit method-driven operations-research manuscripts and LaTeX projects while keeping the problem-model-method-evidence chain consistent. Use for OR paper architecture, formulation and algorithm exposition, computational-study reporting, evidence-grounded literature synthesis, bilingual academic polishing, or manuscript integrity checks; do not use for generic prose without an optimization or decision-model core.
metadata:
  version: "2026.08.30.1"
---

# Paper workflow for operations research

Support the requested manuscript task without expanding its scope. Discussion follows the user's language; manuscript-ready text follows the requested language and otherwise defaults to English. The target journal, article type, and supplied template take precedence over this skill's structural defaults.

## 1. Route the request before acting

Identify the primary mode and requested deliverable:

- **Architecture:** argument map, section structure, paragraph plan, contribution/evidence plan, or figure/table plan.
- **Drafting:** manuscript-ready prose based on supplied, verified, or directly derivable material.
- **Revision:** restructure content or directly edit an existing manuscript/LaTeX project.
- **Polishing/translation:** improve language while preserving mathematics, terminology, cross-references, and claim strength.
- **Audit:** inspect scientific argument, model, method, evidence, citations, figures/tables, or LaTeX integrity. An audit is read-only unless the user also asks for edits.
- **Literature/evidence work:** search, screen, synthesize, build a matrix, verify novelty/theory/baselines, or map claims to sources.

Do not turn a sentence-level edit into a paper redesign or a diagnosis into an unsolicited rewrite.

## 2. Establish readiness with the minimum necessary intake

Inspect supplied files and context before asking questions. Determine only what the requested deliverable requires. Typical decision variables are the target outlet/template, problem and objective, formulation status, method status, evidence status, output language, and edit scope.

- Proceed when a bounded assumption or an explicitly labelled planning gap is sufficient.
- Ask one concise grouped question only when missing information would materially change the requested manuscript-ready text, mathematical meaning, claims, or required format.
- For planning work, mark unknown work as `planned`, `missing`, or `decision required`; do not present it as completed.
- For polishing, use the source text as the semantic authority and ask only about genuine technical ambiguity.
- For direct edits, identify the exact project scope, main file, template, included files, bibliography, result sources, and feasible validation command.

Track factual readiness with these evidence states:

`provided` · `verified externally` · `directly derivable` · `planned but not executed` · `missing` · `not permitted to infer`

Only the first three states may be written as completed facts. Use the [intake and routing reference](references/en/intake-and-routing.md) when the request spans multiple sections or its route is unclear. Use the [intake worksheet](templates/intake-questionnaire.md) internally; never force the user to fill every field.

## 3. Load only the references needed for the task

Use the English reference by default. For Chinese manuscript output or Chinese-first planning, use the matching file under `references/zh/`. Do not load both language versions unless translating, comparing, or synchronizing them.

| Need | Reference |
|---|---|
| Whole-paper argument and section architecture | [Manuscript architecture](references/en/manuscript-architecture.md) |
| Introduction, related work, or literature matrix | [Introduction and related work](references/en/introduction-and-related-work.md) |
| Problem definition, formulation, notation, or complexity claim | [Problem, model, and complexity](references/en/problem-model-and-complexity.md) |
| Exact/decomposition/heuristic/learning-assisted method exposition | [Solution method](references/en/solution-method.md) |
| Experimental design, comparison, statistics, ablation, case, or sensitivity | [Computational study](references/en/computational-study.md) |
| Evidence-driven figure/table selection, captions, and discussion | [Figures and tables](references/en/figures-and-tables.md) |
| Abstract drafting or audit | [Abstract](references/en/abstract.md) |
| Academic English, Chinese-English translation, or local polishing | [Polishing and translation](references/en/polishing-and-translation.md) |
| Full-paper, claim, and reproducibility audit | [Audit and integrity](references/en/audit-and-integrity.md) |
| Direct `.tex` project edits and build checks | [LaTeX project editing](references/en/latex-project-editing.md) |

Available reusable artifacts:

- [Gap-contribution-evidence ledger](templates/contribution-ledger.md)
- [Literature matrix](templates/literature-matrix.md)
- [Figure/table plan](templates/figure-table-plan.md)
- [Audit report](templates/audit-report.md)

Use a template only when it improves the requested deliverable; do not emit blank templates as the answer.

## 4. Preserve the OR argument and its evidence trace

For section- or paper-level work, maintain this chain:

```text
decision or optimization problem
-> unresolved limitation or question
-> formulation / theory / solution method
-> computational or analytical evidence
-> supported implication and boundary
```

Build a gap-contribution-evidence ledger when contributions or claims are in scope. The mapping need not be one-to-one, but every advertised contribution must have a visible evidence path, and every major experiment should answer a stated research question or reviewer-risk question.

Choose sections and evidence modules by paper type, claim, outlet, and available material. The familiar six-section model-algorithm-experiment structure is a fallback, not a mandate. Do not require a literature matrix, illustrative instance, notation table, framework figure, DOE, convergence plot, ablation, case study, or sensitivity analysis unless it materially supports the argument or reproducibility.

## 5. Apply non-negotiable integrity rules

- Never invent an application setting, decision maker, equation, assumption, algorithm component, parameter, dataset, result, statistic, hardware detail, citation, theorem, benchmark, or real-case claim.
- Preserve mathematical meaning, variable definitions, objective direction, units, numerical values, labels, citations, and algorithm semantics unless the user asks to change them and the change is justified.
- Calibrate wording to evidence. Claims such as `first`, `novel`, `optimal`, `convergent`, `significantly better`, `real-world`, and `generalizable` require the corresponding search, proof, test, provenance, or scope evidence.
- Report material favorable, neutral, adverse, and inconsistent evidence where readers need it to interpret the method. Do not hide negative results or move all limitations to the conclusion.
- Keep planned studies and placeholder values out of manuscript-ready prose. If evidence is missing, draft only the supported portion and list the unresolved evidence separately.
- Synthesize literature by concepts, assumptions, formulations, methods, and evidence; do not produce an author-year inventory. Verify each technical attribution against the source.
- State the solution-method class accurately. Describe encoding, decoding, initialization, learning, bounds, convergence, or approximation guarantees only when they actually exist.
- Claim NP-hardness only through a valid special-case argument, polynomial reduction, or a verified result for a genuinely matching case. NP-completeness additionally requires a decision version and membership in NP.
- For computational comparisons, disclose applicable data provenance, implementation environment, budgets, solver status, seeds/repetitions, metrics, and statistical design. Distinguish optimum, best known, incumbent, bound, gap, and time-limit status.
- Use publication-ready section titles and captions. Planning placeholders such as `Component A`, `Method 1`, and `TBD` must not survive into submission-ready output.
- Respect the journal template and preserve unrelated user work when editing `.tex` files.

## 6. Research and citation boundary

Search external literature when the user requests it or when the requested output depends on verifying novelty, prior theory, benchmark provenance, baseline credibility, or journal requirements. Prefer primary papers and official journal or dataset documentation. Verify bibliographic metadata and the exact technical claim; a search snippet or an inaccessible abstract is not enough for a detailed attribution. State the search and access boundary when coverage is incomplete.

If verification is unavailable, weaken the claim, retain a clearly marked citation need in planning output, or report the blocker. Never manufacture a plausible reference.

## 7. Deliver by mode

- **Architecture:** state the selected paper route and why, then provide the argument/section/paragraph map, contribution-evidence mapping, and unresolved decisions.
- **Drafting:** provide coherent manuscript-ready prose from supported facts; keep assumptions or missing evidence outside the prose.
- **Revision/direct edit:** make only the requested changes, then summarize affected files or sections, validation performed, and unresolved risks.
- **Polishing/translation:** return the revised text in the requested format; explain changes only when useful or requested. Flag ambiguities instead of silently guessing.
- **Audit:** lead with prioritized findings, each with location, severity, evidence, consequence, and concrete correction. Separate observed defects from optional improvements.
- **Literature/evidence:** report search scope and access limits, synthesize rather than list, and connect each source-backed gap to a manuscript decision.

## 8. Validate in proportion to the task

- Local prose: terminology, notation, cross-references, factual support, and claim strength.
- One section: local logic plus consistency with the problem, method, evidence, and contribution it serves.
- Full manuscript: argument trace, model-method consistency, evidence coverage, citation integrity, numerical consistency, and publication boundaries.
- LaTeX project: compile when feasible; inspect undefined references/citations, duplicate labels, missing files, stale generated results, and layout warnings relevant to the edit.

Run a full audit only for a full-paper deliverable, a direct project revision whose scope warrants it, or an explicit audit request. Never claim compilation, literature verification, statistical support, or cross-file consistency that was not actually checked.
