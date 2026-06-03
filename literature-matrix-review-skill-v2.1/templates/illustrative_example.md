# Illustrative Example Template

## Objects

- Upstream objects: NEST_1, NEST_2, NEST_3
- Downstream objects: LOT_1, LOT_2

## Relationship

- LOT_1 depends on NEST_1 and NEST_2.
- LOT_2 depends on NEST_2 and NEST_3.

## Processing-time matrix

| Order | Stage 1 | Stage 2 | Stage 3 | Stage 4 |
|---|---:|---:|---:|---:|
| NEST_1 | 8 | 0 | 0 | 0 |
| NEST_2 | 6 | 0 | 0 | 0 |
| NEST_3 | 7 | 0 | 0 | 0 |
| LOT_1 | 0 | 5 | 0 | 4 |
| LOT_2 | 0 | 0 | 6 | 3 |

## Explanation

- NEST orders only use the first stage.
- LOT orders skip the first stage and enter their downstream non-missing stages.
- LOT_1 can start only after both NEST_1 and NEST_2 are completed.
- LOT_2 can start only after both NEST_2 and NEST_3 are completed.
