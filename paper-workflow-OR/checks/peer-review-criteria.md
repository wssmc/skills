# Peer Review Criteria

Peer Review evaluates scientific value and publication risk rather than source-code fidelity or formatting minutiae.

## A. Problem significance

Assess:
- practical/theoretical origin;
- distinction from the base problem;
- whether added features interact meaningfully;
- objective justification;
- clear problem scope.

## B. Novelty and contribution

Assess:
- problem novelty;
- formulation novelty;
- algorithmic novelty;
- theoretical novelty;
- empirical contribution.

Key question:

> If the new algorithm name is removed, what scientific behavior or knowledge is genuinely added?

## C. Technical soundness

From the manuscript, assess:
- model correctness;
- representation/decoder description;
- algorithm logic;
- feasibility;
- pseudocode;
- theoretical/complexity reasoning;
- baseline description/adaptation transparency;
- scientific reproducibility from the paper.

Reviewers do not assume source-code access.

## D. Experimental adequacy

Assess:
- benchmark scale;
- exact comparison;
- strength/relevance of baselines;
- fair implementation/budget;
- parameter tuning;
- statistics;
- component analysis;
- scalability;
- runtime/quality trade-off;
- failure cases.

## E. Evidence for claimed mechanisms

If the manuscript claims that a mechanism:
- improves diversification;
- escapes local optima;
- selects operators adaptively;
- improves representation transformation;

ask whether the experiments validate that specific mechanism or only the complete algorithm.

## F. Writing and presentation

Assess:
- Introduction focus;
- Related Work synthesis;
- method reproducibility;
- evidence-driven result discussion;
- figure/table usefulness;
- terminology consistency;
- conclusion scope.

## Reviewer output

Each reviewer begins with:
- overall evaluation;
- assessment: Strong / Moderate / Weak;
- main concern.

Then provide Major and Minor Comments.

Do not manufacture comments to reach a fixed count.
