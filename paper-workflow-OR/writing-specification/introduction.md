# Introduction Writing Specification

This file does not restate the six structural paragraphs. It addresses the difficult parts of writing them well.

## 1. Problem Abstraction Gate

Before drafting, classify supplied industrial features as:

1. primary scientific structure;
2. secondary structural feature;
3. application or product-family boundary;
4. parameter or data characteristic;
5. implementation detail.

Use this reasoning chain:

```text
industrial facts
→ operational phenomena
→ scheduling consequences
→ primary scientific structure
→ secondary constraints
→ application-specific parameters
```

Do not construct the problem identity by concatenating every industrial characteristic. A feature should enter the problem name, title, or novelty position only when it materially changes the feasible set, scheduling decisions, representation, decoding, formulation, or search behavior. A fixed application fact is not automatically an independent scheduling dimension.

Use this worksheet internally; do not place it in the manuscript:

| Industrial feature | Scientific role | Enters problem name? | Enters model? | Enters Related Work? |
|---|---|---:|---:|---:|
| ... | Primary structure | Yes | Yes | Yes |
| ... | Secondary feature | Maybe | Yes | Yes |
| ... | Application boundary | Usually no | Yes | Usually no |
| ... | Parameter characteristic | No | Yes | No |

### Primary-feature test

Before using a feature in the problem name, title, or contribution, ask whether it:

1. changes the feasible set;
2. introduces or couples a scheduling decision;
3. requires a different representation, decoder, or formulation;
4. interacts structurally with another feature;
5. varies across the studied problem family rather than being fixed in the application;
6. would materially change the scientific identity if removed.

If most answers are negative, treat it as an application characteristic rather than a primary scientific feature.

## 2. Background narrowing

Begin at the narrowest level that still explains the research problem:
- the actual production/scheduling environment;
- the classical scheduling problem;
- or a real operational restriction that directly changes scheduling decisions.

Avoid generic openings about globalization, smart manufacturing, Industry 4.0, or competitive pressure unless they are causally necessary for the studied problem.

The goal is not to introduce an industry. The goal is to let the reader quickly understand **what system, what scheduling problem, and why optimization matters**.

## 3. Practical-to-OR abstraction

Convert a practical phenomenon into an OR problem through:

```text
production phenomenon
→ scheduling object
→ formal structural constraint/decision
→ modeling/search difficulty
```

Do not stop at business description.

For example, instead of writing only that downstream jobs wait for multiple upstream batches, continue to identify:
- what determines downstream release;
- whether this is inter-job precedence or within-job technological precedence;
- how it changes feasibility, representation, decoding, or search.

## 4. Introduction-level gap construction

Use only literature required to establish the immediate gap:
1. representative base-problem studies;
2. representative studies on the key extension;
3. the closest complete-setting studies.

Move quickly from “what exists” to “how it differs from the present problem.”

A strong gap pattern is:

```text
stream A covers X
→ stream B covers Y
→ closest study covers X + part of Y
→ structurally important Z remains unresolved
→ present research problem follows
```

Do not duplicate the complete Related Work taxonomy.

## 5. Problem–gap–method transition

Do not jump from `no study has...` directly to an algorithm name.

Use:

```text
what is unresolved
→ what problem is therefore studied
→ why that problem is computationally difficult
→ what modeling/solution route is needed
```

This transition gives the method a research reason rather than making it look like an algorithm chosen first and decorated later.

## 6. Introduction-level model disclosure

When a mathematical formulation is material, do not stop at `A mathematical model is formulated.` Briefly disclose:

- the main scheduling decisions;
- the distinctive constraint groups;
- the optimization objective.

Do not include symbols, equation numbers, or implementation details. Prefer:

```text
studied problem
→ defining structural constraints
→ decisions
→ objective
→ formulation
→ solution framework
```

## 7. Compact problem–method–contribution block

The problem/method/contribution paragraph should normally contain two compact blocks:

- Block A: studied problem → defining constraints → objective → formulation → solution framework.
- Block B: normally 2–4 numbered contributions.

Do not include detailed neighborhood logic, trigger equations, pseudocode-level control flow, or parameter settings in the Introduction.

## 8. Contribution Compression & Evidence Mapping Gate

A contribution is not an activity list.

Weak:

```text
We formulate a model.
We develop an algorithm.
We conduct experiments.
```

Each contribution should normally contain:

```text
scientific object
+ technical delta
+ structural difficulty addressed
+ optional manuscript/evidence landing
```

Each item should normally use 1–3 sentences:

```text
what is proposed
→ what structural difficulty it handles
→ optional distinguishing mechanism
```

Do not turn a contribution into a miniature Method section. Prefer `The main contributions of this paper are as follows:` over work-list lead-ins such as `The technical work of this paper is as follows:`.

Before retaining a contribution, apply `checks/contribution-check.md` and verify that the claimed technical delta has a concrete landing in Chapter 3 or 4 and a feasible evidence landing in Chapter 5. Keep this mapping internal.

Contribution order usually follows:
1. problem/model contribution;
2. method contribution;
3. empirical/theoretical finding.

Do not infer novelty from a new algorithm name, new code, or a new combination of constraints.

## 9. Argument continuity

The six paragraphs should form one forward chain:

```text
base problem
→ key feature
→ literature gap
→ studied problem/difficulty
→ method/contributions
→ organization
```

A repeated concept is acceptable only when it serves a different function:
- Paragraph 2: why the feature matters;
- Paragraph 3: whether literature covers it;
- Paragraph 4: how it enters the formal problem;
- Paragraph 5: how the paper addresses it.

Repeated definition without functional progression should be removed.
