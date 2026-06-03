# Ablation Study Plan

## Purpose

Ablation should verify whether claimed algorithmic components actually contribute to performance.

## Candidate ablations

| Variant | Removed component | Purpose |
|---|---|---|
| Proposed | none | full method |
| No-DAG-decoder | release-aware decoding removed | test value of precedence handling |
| No-repair | repair mechanism removed | test feasibility repair |
| No-critical-path-neighborhood | critical-path move removed | test neighborhood contribution |
| Random-init | heuristic initialization replaced by random initialization | test initialization contribution |
| No-local-search | local search removed | test intensification contribution |

## Metrics

- objective value;
- RPD;
- CPU time;
- feasible rate;
- number of infeasible moves.
