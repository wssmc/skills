# Adapter Plan

## Goal

Adapt verified baseline algorithm to target scheduling environment without modifying the baseline source.

## Files to Reuse

| File | Reason |
|---|---|
|  |  |

## Files to Replace

| Baseline File | Target Replacement | Reason |
|---|---|---|
| decoder.py | target decoder | target environment already validated |

## Files to Add

| File | Purpose |
|---|---|
| adapted/adapter.py | bridge baseline algorithm to target API |
| adapted/adapted_algorithm.py | adapted search loop |

## Risks

| Risk | Mitigation |
|---|---|
|  |  |
