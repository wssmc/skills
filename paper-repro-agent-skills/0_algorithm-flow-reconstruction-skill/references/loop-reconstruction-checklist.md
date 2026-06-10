# Loop Reconstruction Checklist

- What initializes current and best?
- What is the outer loop stopping condition?
- Does the algorithm have temperature / generation / episode / local-search inner loops?
- What creates a candidate solution?
- Is local search before or after acceptance?
- When is best updated?
- Are parameters updated every iteration or every phase?
- Are infeasible candidates repaired, rejected, penalized, or made feasible by decoder?
- Does experiment section override pseudocode stopping condition?
