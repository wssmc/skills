# Literature and Novelty Truthfulness

## 1. Technical literature claims must match the primary source

For key papers verify, as relevant:
- production/scheduling environment;
- entities/resources;
- objective;
- special constraints;
- solution method;
- benchmark/data;
- theorem/property;
- experimental conclusion.

Bibliographic metadata alone does not verify technical content.

## 2. Literature-matrix cell verification

Every technical cell in a literature table is itself a literature claim.

High-risk fields include:
- Problem / environment;
- Objective;
- Constraint / special feature;
- Resource structure;
- Method;
- Dataset/benchmark;
- Code availability;
- official code vs third-party reproduction.

Recommended verification sheet:

| Study | Field | Matrix value | Primary-source evidence | Status |
|---|---|---|---|---|
| A | Objective | Makespan | abstract/model/section | VERIFIED |
| A | Code | Official | repository/paper statement | VERIFIED |

Do not assume an entire row is correct because the citation itself is correct.

## 3. Closest-study comparison must use explicit dimensions

Compare on dimensions that define the research boundary:
- production environment;
- job structure;
- special constraints;
- resource structure;
- objective;
- decision coupling;
- method, when relevant.

Avoid vague claims such as `our problem is more complex`.

## 4. Research gap must be derived

Use:

```text
verified literature scope
→ verified similarities
→ verified differences
→ unresolved technical structure
→ present research position
```

A limited search that did not find X does not prove that no study has considered X.

## 5. Contribution is not novelty

Work statement:

> `We formulate a model with X.`

Contribution statement:

> `The formulation explicitly captures X, which is absent from the baseline model.`

Novelty statement:

> `This is the first formulation to capture X.`

These require progressively stronger evidence.

## 6. New combinations are not automatically novel

For `Feature A + Feature B`, explain whether interaction changes:
- feasible set;
- decision coupling;
- release/precedence semantics;
- representation;
- decoder;
- formulation;
- complexity;
- search behavior.

If the features are merely additive, novelty strength should be lower.

## 7. Method novelty requires behavior-level delta

A new name, new code, or standard algorithm on new data does not establish method novelty.

Verify changes in:
- representation;
- candidate set;
- selection/acceptance;
- adaptive state;
- trigger;
- feedback;
- guidance;
- acceleration;
- search-control architecture.

## 8. Wording by verification strength

Strong coverage:

> `To the best of our knowledge, no previous study has jointly considered ...`

Moderate coverage:

> `The reviewed literature does not explicitly address ...`

Limited coverage:

> `This study considers ...`

without a literature-wide absence claim.

## 9. Attribution

Correctly attribute standard mechanisms, benchmarks, tests, and inherited components. Use `adapted from` when appropriate.
