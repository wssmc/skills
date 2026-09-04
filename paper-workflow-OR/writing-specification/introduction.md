# Introduction Writing Specification

This file does not restate the six structural paragraphs. It addresses the difficult parts of writing them well.

## 1. Background narrowing

Begin at the narrowest level that still explains the research problem:
- the actual production/scheduling environment;
- the classical scheduling problem;
- or a real operational restriction that directly changes scheduling decisions.

Avoid generic openings about globalization, smart manufacturing, Industry 4.0, or competitive pressure unless they are causally necessary for the studied problem.

The goal is not to introduce an industry. The goal is to let the reader quickly understand **what system, what scheduling problem, and why optimization matters**.

## 2. Practical-to-OR abstraction

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

## 3. Introduction-level gap construction

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

## 4. Problem–gap–method transition

Do not jump from `no study has...` directly to an algorithm name.

Use:

```text
what is unresolved
→ what problem is therefore studied
→ why that problem is computationally difficult
→ what modeling/solution route is needed
```

This transition gives the method a research reason rather than making it look like an algorithm chosen first and decorated later.

## 5. Contribution writing

A contribution is not an activity list.

Weak:

```text
We formulate a model.
We develop an algorithm.
We conduct experiments.
```

Prefer:

```text
technical delta + problem/difficulty addressed
```

Contribution order usually follows:
1. problem/model contribution;
2. method contribution;
3. empirical/theoretical finding.

Do not infer novelty from a new algorithm name, new code, or a new combination of constraints.

## 6. Argument continuity

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
