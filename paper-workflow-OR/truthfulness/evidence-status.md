# Evidence Status

Use a fixed status for important manuscript facts and claims.

| Status | Meaning | Allowed use |
|---|---|---|
| `PROVIDED` | explicitly supplied by the user/project/manuscript | may be used as supplied fact; high-risk claims may still need verification |
| `VERIFIED` | checked against primary literature, source code, raw results, solver output, etc. | may be stated at the strength directly supported by the evidence |
| `DIRECTLY_DERIVABLE` | can be computed/derived from known inputs | allowed when derivation is reproducible; inherits the weakest evidence status of its inputs |
| `PLANNED` | designed/intended but not completed | may be described only as planned/future work |
| `MISSING` | required information is unavailable | do not fabricate; request/flag it |
| `NOT_PERMITTED_TO_INFER` | cannot be inferred from convention, naming, or plausibility | wait for direct evidence |

## Derivation inheritance

`DIRECTLY_DERIVABLE` is a derivation mode, not an independent superior evidence level.

```text
VERIFIED inputs → directly derivable output → verified derivation
PROVIDED inputs → directly derivable output → still bounded by PROVIDED evidence
```

## Examples

### Parameter

`alpha = 0.96` supplied by the user → `PROVIDED`.

If runtime configuration/logs confirm it → `VERIFIED`.

Allowed:

> `The cooling rate was set to 0.96.`

Not allowed without calibration evidence:

> `The optimal cooling rate is 0.96.`

### Planned ablation

Status: `PLANNED`.

Allowed:

> `A component analysis is planned to evaluate ...`

Not allowed:

> `The component analysis demonstrates ...`

### Novelty

A new function exists in code → function existence may be `VERIFIED`.

`The mechanism is novel` → `NOT_PERMITTED_TO_INFER` until literature verification is completed.

## Wording principle

Evidence status controls permission, not rhetorical weakness. If a claim is verified, state it directly within its actual scope.
