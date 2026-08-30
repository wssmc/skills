# Manuscript architecture

## OR spine

A method-driven OR paper should read as one argument:

```text
research context
-> OR decision or optimization problem
-> unresolved gap and technical difficulty
-> mathematical formulation
-> solution method
-> computational evidence
-> theoretical/practical implications and boundaries
```

## Fallback main body

1. Introduction
2. Literature review / Related work
3. Problem description and mathematical formulation
4. Solution method
5. Computational study
6. Conclusions

This six-section arrangement is a fallback for a model-algorithm-computation paper, not a required shell. Merge or rename sections when the journal, paper type, or argument warrants it. For example, a theory paper may integrate the problem and formulation, while an application paper may separate case context from computational validation.

### Conclusions

Cover the functions supported by the paper, without forcing a fixed paragraph or item count:

1. Reconnect the research question to the formulation/method contribution.
2. State only the main analytical or computational findings, with the most decision-relevant magnitudes when available.
3. Explain implications at the level supported by the evidence.
4. State material scope boundaries and pair useful future work with the mechanism causing each boundary.

Do not introduce new experiments or citations in the conclusion, repeat the abstract verbatim, enumerate every result, or hide adverse evidence that should have been reported earlier.

Use the target journal's prescribed structure when it differs.

## Paragraph-planning notation

For planning output, use:

```text
Guide: element -> element -> element
Paragraph 1: purpose and content.
Paragraph 2: purpose and content.
```

Do not use numbered circled bullets for section-content planning.

Default to a section-level blueprint that explains what each section writes and which formulas, algorithms, tables, and figures support it. If the user explicitly asks for paragraph-by-paragraph guidance, expand only the requested sections and make each paragraph concrete enough to draft.

Default planning output should be directly readable in chat or Markdown. Raw LaTeX is appropriate only for an explicit LaTeX/source-editing request; Word or PDF should be created only when requested.

## Subsection economy

- Give a subsection its own heading only when it carries an independent argumentative, methodological, or evidential function.
- Merge explanatory fragments that do not carry independent functions; split dense blocks when readers must navigate distinct claims or procedures.
- Use third-level headings only for actual method components, evidence blocks, or substantive research streams, not to satisfy a preferred count.
- Move long proofs, implementation details, full parameter tables, and supplemental experiments to appendices when permitted.

## Evidence-module selection

Select each module by the question it answers. Common candidates are:

- a literature matrix when side-by-side coding exposes the gap more clearly than prose;
- an illustrative instance when the problem or feasibility logic is otherwise difficult to reconstruct;
- a notation table when symbol volume makes definitions hard to navigate;
- a framework figure when module interfaces or information flow are not clear from concise prose/pseudocode;
- calibration evidence when parameters were selected empirically;
- exact/reference comparison, repeated-run statistics, convergence, or ablation when the corresponding performance or mechanism claim is made;
- case, sensitivity, or robustness evidence when practical validity or stability is claimed.

Omit decorative or redundant items. Every major table/figure should support a stated contribution, research question, reproducibility need, or foreseeable reviewer concern.

For a compact planning example with an explicit missing-evidence decision, see [architecture output example](../../examples/en/architecture-output.md).
