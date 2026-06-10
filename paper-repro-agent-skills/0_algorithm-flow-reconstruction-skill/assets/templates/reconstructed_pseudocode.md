# Reconstructed Human-Readable Pseudocode

## Algorithm: <name>

Input:
- instance
- parameters
- stopping condition

Output:
- best_solution

```text
1. current_solution ← InitializeSolution(instance)
2. current_schedule ← Decode(current_solution)
3. current_value ← Evaluate(current_schedule)
4. best_solution ← current_solution
5. best_value ← current_value

6. while stopping condition is not met do

       # Candidate generation
7.     candidate_solution ← GenerateCandidate(current_solution)

       # Optional intensification
8.     candidate_solution ← LocalSearch(candidate_solution)

       # Acceptance
9.     if Accept(candidate_solution, current_solution) then
10.        current_solution ← candidate_solution

       # Best update
11.    if Evaluate(candidate_solution) improves best_value then
12.        best_solution ← candidate_solution
13.        best_value ← Evaluate(candidate_solution)

14. return best_solution
```

## Paper-Specific Components

| Component | One-sentence key idea | Used at line | Evidence |
|---|---|---:|---|
|  |  |  |  |

## Standard Components

| Component | Meaning |
|---|---|
| InitializeSolution | Generate an initial feasible solution or representation. |
| Decode | Convert representation into a concrete schedule. |
| Evaluate | Compute objective value from schedule. |
| LocalSearch | Improve a solution using standard neighborhood moves. |
