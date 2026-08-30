# Method component ledger

Use before drafting a method section from code, pseudocode, or mixed manuscript sources. One row represents one algorithmic responsibility, not necessarily one function or one subsection.

Allowed contribution-status values: `inherited/standard`, `problem-adapted`, `claimed core contribution`, `unresolved`. A status is a provenance/evidence classification, not an inference from code complexity.

| ID | Component or responsibility | Purpose and owned state | Inputs -> outputs | Evidence/source locator | Contribution status and authority | Method placement and detail | Experiment handoff | Open issue |
|---|---|---|---|---|---|---|---|---|
| M1 |  |  |  |  |  | concise / normal / detailed / omit | parameters / tuning / ablation / none |  |

## Cross-component checks

- Candidate generation is not conflated with search control.
- Adaptation/guidance is located after the base operators and controller it modifies.
- Problem/model definitions are referenced rather than duplicated.
- Algorithm-specific decoding, repair, or evaluation is retained in the method.
- Current, candidate, reference/incumbent, and best states are not conflated.
- Integrated pseudocode follows the implementation's update order.
- Code-only guards, copying, logging, and library behavior are omitted unless scientifically consequential.
