# Feasibility Test Spec

| Constraint | Test Case | Expected Result | Applies? | Evidence |
|---|---|---|---|---|
| Machine capacity | no overlap on same machine | pass | yes / no |  |
| Operation precedence | stage/order respected | pass | yes / no |  |
| Missing operations | skipped operations do not occupy machine | pass | yes / no |  |
| Machine eligibility | operation uses eligible machine | pass | yes / no |  |
| Batch / lot constraints | batch/lot rules satisfied | pass | yes / no |  |
| Objective recomputation | reported objective equals independent recomputation | pass | yes |  |
