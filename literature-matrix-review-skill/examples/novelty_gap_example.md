# Novelty Gap Example

## Existing Coverage

Existing HFSP studies have considered makespan, total tardiness, E/T, and TWET objectives. Some studies consider due windows or MUPs separately. Recent studies also introduce two-phase or hybrid metaheuristics.

## Underexplored Combination

The simultaneous integration of TWET, due windows, priority jobs, shared windows, and MUPs in an HFSP setting appears less explored and may form the main problem-level contribution.

## Methodological Gap

Existing IG-based methods often focus on objective improvement but do not explicitly design decoding, repair, and neighborhood structures for the combined window-priority-MUP constraints.

## Possible Contributions

1. Formulate an HFSP with TWET, due windows, priority jobs, shared windows, and MUPs.
2. Develop a two-phase IG algorithm with constraint-aware decoding.
3. Design specialized neighborhoods for shared-window and priority-job adjustment.
4. Introduce a repair mechanism for MUP conflicts.
5. Conduct comparative experiments against IG, ILS, GA, SA, and dispatching baselines.
