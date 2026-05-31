# Method Matrix Table Example

| Method component | Pan et al. (2017) | Li et al. (2024) | This study |
|---|---|---|---|
| Main framework | IG, ILS | Two-phase IG | Two-phase IG |
| Encoding | Job permutation | Sequence-based | Priority-window-aware job sequence |
| Decoding | Insertion decoding | Two-phase schedule generation | Due-window and MUP-aware decoding |
| Initialization | Heuristic initialization | Constructive heuristic | Priority-aware NEH-like initialization |
| Neighborhood | Insert, exchange | Two-phase neighborhoods | Insert, swap, block move, shared-window adjustment |
| Local search | ILS-based improvement | Intensification search | Constraint-aware local search |
| Repair mechanism | Not reported | Tardiness-oriented repair | MUP + shared-window + priority repair |
| Constraint handling | Due window evaluation | Weighted tardiness handling | Integrated window, priority, shared window, MUP handling |
| Acceptance rule | IG acceptance | Two-phase acceptance | Adaptive acceptance |
| Reusable idea | IG framework for TWET | Two-phase search structure | Target method |
