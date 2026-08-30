# Example: audit finding

**Location:** Section 5.2, algorithm comparison

**Severity:** Major

**Problem:** The manuscript claims that the proposed algorithm significantly outperforms all baselines, but it reports only one run per instance and no statistical comparison.

**Evidence observed:** Table 6 contains one objective value per method-instance pair; Section 5.1 reports no seeds or repetitions; no run-level result file was supplied.

**Why it matters:** A stochastic-method superiority claim is unsupported and may be rejected as unfair or irreproducible.

**Required revision:** Run repeated paired experiments under the same wall-clock budget; report mean and variability; add an appropriate paired test and effect information. Until then, revise the claim to descriptive competitiveness.

**Additional evidence needed:** Seeds, run-level results, test design, adjusted p-values or confidence intervals.
