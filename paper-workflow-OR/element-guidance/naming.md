# Naming Guidance

Names identify objects. The manuscript body explains and evaluates them.

## Manuscript title

Prefer concise titles containing:
- the scheduling problem;
- the most distinctive problem feature;
- optionally, one method-level contribution when it materially improves identification.

Avoid packing all constraints, resources, objectives, algorithm mechanisms, and findings into the title.

## Section/subsection titles

Prefer short noun phrases:

```text
Solution Representation and Decoding
Neighborhood Structures
Component Analysis
Cross-Space Transformation
Statistical Comparison
```

Avoid result-like headings such as:

```text
Analysis of How the Proposed Neighborhood Mechanism Improves Search Efficiency
```

## Figure captions

A caption should identify:
- object;
- benchmark/condition;
- metric/unit when necessary.

Good:

> `Distribution of instance-level mean RPD on the Small benchmark`

Avoid:

> `Boxplots showing that the proposed method has the lowest median and best robustness`

The analysis belongs in the text.

## Table titles

Good:

> `Comparison results on the Large benchmark`

Avoid:

> `Comparison results showing that Method A outperforms all competing algorithms`

## Algorithm captions

Good:
- `Cross-space cooperative search`
- `Quality-gap-guided search`
- `Forward solution-space transformation`
- `Procedure of the proposed algorithm`

`Procedure` is acceptable in an algorithm caption but need not be used as a section title.

## Mechanism names and acronyms

A mechanism name should:
- reflect its real function;
- remain short enough to use repeatedly;
- avoid implying novelty not established by literature;
- be stable across Abstract, Method, figures, tables, and experiments.

Do not invent inflated names for standard swap/insertion moves.

## Concision check

For every title/caption ask:
1. Can a modifier be removed without losing identity?
2. Does it contain a result judgment that belongs in prose?
3. Does it enumerate too many algorithm components?
4. Does it match the terminology glossary?
