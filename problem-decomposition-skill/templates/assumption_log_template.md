# Assumption Log

| Assumption ID | Content | Reason | Impact | Need user confirmation |
|---|---|---|---|---|
| A1 | All jobs pass through all stages in the same order. | HFSP default assumption. | Determines stage precedence constraints. | Yes |
| A2 | Processing time is job-stage dependent, not machine-dependent. | User provides JobID × Stage table. | Simplifies assignment and processing time parameters. | Yes |
