# Related Work Writing Specification

The purpose of Related Work is to turn a literature collection into research streams, comparisons, synthesis, and a derived research gap.

## 1. Build literature streams before drafting paragraphs

Do not write in search order or chronological order by default.

For each study, decide its role:
- base problem;
- extension/constraint;
- solution method;
- closest study;
- background only.

For each stream, identify:
- common research question;
- representative/foundational work;
- recent/closest work;
- dimensions that matter for the present study.

## 2. Organize each paragraph around a comparison dimension

A paragraph should have a thesis, not a list of papers.

Useful comparison dimensions include:
- production environment;
- constraint semantics;
- objective;
- representation/decoder;
- exact vs heuristic method;
- treatment of a specific operational feature.

Recommended paragraph logic:

```text
topic sentence
→ group of similar studies
→ contrasting/extended studies
→ comparison
→ local synthesis
```

## 3. Group similar studies

When several studies serve the same role in the current paragraph, synthesize them rather than repeating `Author A proposed... Author B developed...`.

Do not over-merge when differences matter to the current research gap.

## 4. Subsection synthesis

Description answers what a paper did. Synthesis answers what the literature stream collectively establishes.

Every subsection should contain synthesis, but synthesis is a rhetorical function rather than a mandatory standalone paragraph. Prefer integrating it into the final one or two sentences of the last literature paragraph. Do not mechanically end every subsection with `In summary`, `Overall`, or `Taken together`. Use a separate concluding paragraph only when genuinely distinct streams require explicit integration.

Synthesis should establish:
- what is well studied;
- what modeling/method patterns are mature;
- under what settings results hold;
- what limitation matters for the present study.

## 5. Identify closest studies explicitly

Closest studies should be compared on dimensions that define the research boundary:
- environment;
- jobs/resources;
- constraints;
- decisions;
- objective;
- structural coupling;
- solution method when relevant.

Write the exact difference, not `our problem is more complex`.

## 6. Derive the final research gap

The final Research Gap subsection has the paper-level synthesis responsibility. Earlier subsections establish local contrasts; the final gap accumulates them, identifies the unresolved structural interaction, and derives the present problem position. Do not repeat the same literature inventory.

For a combined problem, explain why the combination is not merely additive. Show whether interaction changes:
- feasible set;
- decision coupling;
- release/precedence semantics;
- representation;
- decoder;
- exact formulation;
- search behavior.

## 7. Write solution-method literature around transferable mechanisms

When reviewing methods, compare mechanisms rather than algorithm names alone:
- representation;
- decoding;
- initialization;
- neighborhood/destroy-repair;
- operator control;
- acceptance;
- intensification/diversification;
- acceleration/learning.

The goal is to clarify what can be inherited and what must change for the studied problem.

## 8. Use literature tables as compressed evidence

A literature table should answer a specific positioning question. Include only discriminative columns.

In prose:
1. introduce the comparison dimensions;
2. use the table as compressed evidence;
3. discuss dominant patterns and closest exceptions;
4. derive the gap.

Do not read the table row by row.
