---
name: paper-workflow-OR
description: Plan, draft, restructure, polish, translate, audit, and directly edit LaTeX projects for method-driven operations research papers that connect an optimization problem, a mathematical formulation, a solution method, and computational evidence. Use for OR manuscript architecture, introduction and related-work routing, MIP/model writing, NP-hardness placement, algorithm exposition and pseudocode, computational-study design, figure/table caption naming, literature search, journal-template adaptation, Chinese-English translation, and full manuscript integrity audits.
version: 2026.07.13.1
---

# paper-workflow-OR

Use this skill only for operations research and optimization manuscripts. The default manuscript language is English; discussion may follow the user's language. A Chinese reference set is available and may be selected explicitly.

## First decision

Classify the request before writing:

- `Architecture`: outline, branch selection, section titles, paragraph plan, evidence plan, figure/table plan.
- `Drafting`: write manuscript-ready content from supplied facts and evidence.
- `Revision`: restructure or directly revise an existing manuscript or LaTeX project.
- `Polishing/Translation`: improve academic English, translate Chinese/English, remove formulaic AI prose, preserve technical meaning.
- `Audit`: inspect argument, model, algorithm, experiments, citations, figures/tables, LaTeX integrity, and claim boundaries.

Then determine the requested output mode: outline only, outline plus Guide, paragraph plan, full prose, LaTeX-ready prose, caption plan, literature matrix, audit report, revision plan, or direct `.tex` edits.

## Mandatory intake

When material information is missing, ask one concise grouped set of questions before drafting. At minimum resolve:

1. Target journal or journal family, and whether an official LaTeX template is available.
2. Base OR problem, decision setting, objective, resources, constraints, and uncertainty.
3. Model family and whether a complete formulation exists.
4. Algorithm family, encoding/decoding, initialization, actual components, and available pseudocode.
5. Data/benchmarks, baselines, completed experiments, hardware/software, and available result files.
6. Requested language and output mode.

Do not invent missing application settings, decision makers, formulations, algorithm components, parameter values, experiment results, statistical significance, real cases, or references.

## Core workflow

1. Inspect user files first. For LaTeX projects, identify the main file, included files, bibliography, template/class, figures, tables, code, solver logs, and generated results.
2. Ask or resolve the target journal/template before imposing structure.
3. Build an internal ledger: `Gap -> Contribution -> Manuscript location -> Evidence -> Boundary`.
4. Choose the introduction and related-work branches from the architecture references.
5. Build or revise the six-section OR spine: problem, model, method, computational evidence, conclusions. Use the three-paragraph conclusions structure: overview, findings, boundaries and future research.
6. Plan required and conditional figures/tables, emphasizing precise English caption naming.
7. Draft or edit only claims supported by supplied or verified evidence.
8. Run the full audit before final delivery.

## Reference routing

Read the English reference by default. Read the matching Chinese reference when the user selects Chinese output or when Chinese planning is more useful.

- Intake, task routing, and branching: `references/en/intake-and-routing.md`
- Six-section manuscript architecture: `references/en/manuscript-architecture.md`
- Introduction and related work: `references/en/introduction-and-related-work.md`
- Problem, formulation, demo, notation, and NP-hardness: `references/en/problem-model-and-complexity.md`
- Encoding, initialization, method components, pseudocode, and analysis: `references/en/solution-method.md`
- DOE, benchmark, statistics, convergence, ablation, case, and sensitivity: `references/en/computational-study.md`
- Fixed/default figure and table set plus caption library: `references/en/figures-and-tables.md`
- Full-paper and evidence audit: `references/en/audit-and-integrity.md`
- Direct LaTeX project editing: `references/en/latex-project-editing.md`
- Academic English polishing and Chinese-English translation: `references/en/polishing-and-translation.md`
- Abstract writing: `references/en/abstract.md`

Chinese mirrors are under `references/zh/` with the same filenames.

## Hard rules

- Preserve the OR spine: `decision problem -> formulation -> solution method -> evidence -> implications`.
- Match gaps and contributions one-to-one and in the same order.
- Redeem each contribution with a model result, theorem/proposition, algorithm/pseudocode, benchmark, statistical test, ablation, case, sensitivity result, figure, table, or appendix proof.
- Use real subsection titles. Placeholders such as `Feature A`, `Mechanism B`, `Method 1`, and `TBD` may appear only in planning notes, never in manuscript-ready output.
- A literature review must classify, compare, synthesize, and close each stream with a specific unresolved issue; do not produce an author-year list.
- Include a literature matrix by default for full method-driven papers unless the journal format or evidence makes it unnecessary.
- Use an illustrative instance with data tables and an explanatory schedule/network/route figure when the problem is not immediately transparent.
- Use `Notation for the MIP model.` by default for MIP formulations; rename accurately for other paradigms.
- Claim NP-hardness only with a valid special-case argument, polynomial reduction, or reliable cited result. Do not infer NP-hardness from computational difficulty.
- State whether the method is exact, approximate, decomposition-based, heuristic, metaheuristic, hybrid, or learning-assisted.
- Explain encoding/decoding and initialization only when they exist; otherwise use the documented branch titles.
- Name algorithm-component subsections by their actual function and provide purpose, procedure, interfaces, feasibility conditions, and pseudocode where needed.
- Report computing environment before interpreting results: language, CPU, clock speed, RAM, operating system, solver/version, threads, time limit, gap, seeds, repetitions, and preprocessing policy when applicable.
- Use fair computational budgets and distinguish optimum, incumbent, bound, gap, and time-limit status.
- Do not fabricate citations, results, p-values, confidence intervals, captions, hardware, code outputs, or real-world claims.
- When editing `.tex`, respect the journal template and preserve mathematical meaning, labels, references, and user results.
- Present only favorable evidence in the main manuscript body. Confine limitations, weaknesses, and negative results to a brief statement in the Conclusions section. Do not qualify or hedge results in the Introduction, method, or experimental sections.

## Literature search

External literature search is allowed and expected when the user requests it, when novelty or `first` claims must be verified, when a literature matrix is built, when a base NP-hard result is needed, or when credible baselines must be selected. Verify bibliographic metadata and technical claims from primary sources. State evidence boundaries when full text is unavailable.

## Figure and table scope

This version prioritizes necessity, manuscript location, evidence role, and caption naming. It may plan or revise figures/tables and their LaTeX captions. Automatic plotting is optional and secondary. Do not claim a figure or table exists unless supplied or generated.

## Figure title, caption, and in-text reference

Distinguish among the following elements.

### 1. In-figure title

An in-figure title is text placed inside the graphical canvas, usually above the plotting area.

For journal manuscripts, an in-figure title should normally be omitted because the figure caption already identifies and explains the figure.

Avoid placing titles such as:

```text
Algorithm comparison
ARPD distribution
Convergence analysis
Sensitivity results
```

inside the figure.

An in-figure title may be retained only when:

* the target journal or template explicitly requires it;
* the figure is intended for a presentation rather than a manuscript;
* multiple self-contained panels require short internal panel headings;
* the title conveys information that cannot be represented clearly in the caption or panel labels.

### 2. Figure caption

The figure caption appears outside the graphical canvas and is normally placed below the figure.

A caption should identify:

```text
what is shown
→ what is compared
→ the data, instance, or scenario scope
→ the meaning of nonstandard symbols
→ the direction of better performance when necessary
```

Example:

```text
Figure X. Distribution of ARPD values obtained by the compared
algorithms across the test instances. Diamonds indicate the mean
values, and lower ARPD values indicate better solution quality.
```

The caption should not repeat information that is already unambiguous from the axis labels and legend unless that information is necessary for correct interpretation.

### 3. In-text reference

The manuscript text should introduce the purpose of the figure before interpreting its evidence.

Example:

```text
Figure X compares the distributions of ARPD values obtained by the
six algorithms.
```

The following sentences should report the principal observations, relevant numerical comparisons, exceptions, interpretation, and evidence-bounded conclusion.

### 4. Elements retained inside a figure

A journal figure should normally retain only:

* x-axis and y-axis labels;
* measurement units;
* legend entries;
* panel labels such as `(a)`, `(b)`, and `(c)`;
* reference lines;
* confidence bands or error bars;
* necessary value annotations;
* necessary statistical markers;
* short annotations identifying important thresholds or events.

### 5. Redundancy rule

Do not repeat the same information in all three locations.

Avoid:

```text
In-figure title: ARPD distribution
Caption: ARPD distribution of the algorithms
Text: Figure X shows the ARPD distribution of the algorithms
```

Prefer:

```text
In-figure title: omitted

Caption:
Figure X. Distribution of ARPD values obtained by the compared
algorithms across the test instances.

Text:
Figure X compares both the central tendency and dispersion of the
ARPD values produced by the six algorithms.
```

### 6. Table equivalent

The same distinction applies to tables.

A manuscript table normally has:

* no title embedded inside the tabular cells;
* a table caption placed above the table;
* notes placed below the table;
* an in-text sentence introducing and interpreting the table.

Example:

```text
Table X. Algorithm comparison on large-scale instances under equal
CPU-time budgets.
```

Information such as abbreviations, significance symbols, denominator definitions, and best-value formatting should be explained in table notes rather than inserted as an internal table title.

### 7. Convergence figure caption default

For convergence curves, prefer a concise noun-phrase caption that identifies the figure type and analysis object:

```text
Convergence profiles for representative instances.
```

Do not overload the caption with information already conveyed by the axes, legend, panel labels, or surrounding text. Details such as the number of instances, time scale, performance direction, and algorithm names should be added only when they are necessary for correct interpretation.

The default naming template is:

```text
Figure X. Convergence profiles for representative instances.
```

## Completion standard

Before final delivery, check:

- selected branches fit the paper;
- titles are publication-ready and not placeholders;
- model and algorithm match the stated problem;
- evidence supports every contribution and conclusion;
- figures/tables are cited, interpreted, and numerically consistent;
- citations are verifiable;
- LaTeX compiles or any unresolved compile limitations are explicitly reported.
