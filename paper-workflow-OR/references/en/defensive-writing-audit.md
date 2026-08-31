# Defensive Academic Writing Audit

## When to read this reference

Use this reference when the user asks to detect or rewrite defensive, reviewer-facing, disclaimer-heavy, self-protective, or over-explanatory academic prose in an operations-research manuscript.

This reference audits rhetorical posture and evidence boundaries. It does not replace an audit of the optimization model, mathematical validity, algorithm mechanics, experimental design, or statistical conclusions. It is not a hedge-word remover: necessary scientific caveats must remain, and claims must not be strengthened for stylistic reasons.

## Core principle

Prefer:

```text
technical claim -> supporting evidence -> concise necessary boundary
```

over a sequence of anticipated objection, disclaimer, justification, weakened claim, and repeated disclaimer. State the technical fact first. Retain a caveat when removing it would materially change the interpretation of model validity, feasibility, evidence, scope, reproducibility, or conclusion strength.

## Defensive-writing taxonomy

| ID | Pattern | Typical OR-paper signal | Action |
|---|---|---|---|
| D1 | Reviewer-facing prebuttal | “to avoid misunderstanding”, “one might argue” | State the technical fact directly |
| D2 | Repeated non-claim disclaimer | repeated “we do not claim...” | State the supported scope once |
| D3 | Caveat stacking | multiple although/only/may qualifiers around one claim | Keep the strongest supported statement |
| D4 | Excusing imperfect results | explaining a weak result before reporting it | Report the result first; explain only with evidence |
| D5 | Defending omitted experiments | justifying missing baselines, ablations, or sensitivity tests | State once as a material limitation, if needed |
| D6 | Fairness self-defense | “for a fair comparison...” | Describe the controlled protocol directly |
| D7 | Repeated limited-scope labels | preliminary, limited, indicative repeated throughout | Keep only technically necessary labels |
| D8 | Legalistic disclaimer prose | long lists of “should not be interpreted as...” | Convert to a short positive scope statement |
| D9 | Irrelevant defensive disclosure | process failures that do not affect interpretation | Delete or move to supplementary records |
| D10 | Promotional compensation | robust, promising, effective replacing measurements | Use metrics, protocol facts, or named properties |
| D11 | Automatic summary sentences | generic “these results demonstrate...” | Delete or state the specific supported inference |
| D12 | Evidence-boundary over-signaling | repeating “within the evaluated scope” after every claim | State the material scope once |
| D13 | Absolute defensive claims | “no method can...”, “it is impossible...” | State the exact supported condition |
| D14 | Contribution by relabeling | renaming a standard operation or defending novelty repeatedly | State the actual technical delta |

## Necessity test

For each suspicious sentence, ask:

1. Would deletion make the model, evidence, or conclusion materially misleading?
2. Does the sentence state a supported condition, uncertainty, error, or scope boundary?
3. Is its main purpose to answer an imagined reviewer objection?
4. Can it be rewritten as a positive statement of what was evaluated or observed?
5. Has the same caveat already appeared elsewhere?

Classify the sentence as `NECESSARY_CAVEAT`, `DEFENSIVE`, `MIXED`, or `CLEAN`.

## OR-specific rules

- Preserve limitations that change the feasible set, scheduling assumptions, objective interpretation, experimental scope, statistical interpretation, or reproducibility.
- In a method section, state encoding, decoding, search, acceptance, and update rules directly. Do not replace contribution positioning with repeated non-claim disclaimers.
- Describe standard NEH, simulated annealing, and ordinary neighborhoods by their function. State the actual technical contribution as a concrete information-feedback, weighting, or decision rule.
- Report results before explaining them. Do not excuse weak results without a supported diagnosis.
- Describe instances, budgets, seeds, repetitions, and metrics directly instead of calling a comparison fair, reasonable, or sufficient without defining the condition.
- Require proof, experiment, statistical evidence, or explicit conditions for terms such as `optimal`, `convergent`, `robust`, `generalizable`, and `significant`.
- Place a material limitation next to the claim it qualifies and avoid repeating it across the abstract, contribution list, method, results, and conclusion.

## Audit procedure

### Pass 1 — Detection

Mark D1–D14 and record the location of each candidate sentence.

### Pass 2 — Necessity classification

Assign `NECESSARY_CAVEAT`, `DEFENSIVE`, `MIXED`, or `CLEAN`.

### Pass 3 — Reviewer-perception analysis

For `DEFENSIVE` and `MIXED` items, explain in one sentence whether the wording delays the claim, anticipates criticism, over-explains a result, or weakens the contribution beyond the evidence.

### Pass 4 — Evidence-preserving rewrite

1. Put the technical fact first.
2. Calibrate the claim to the available evidence.
3. Delete language used only for pre-emptive defense.
4. Retain at most one necessary scientific boundary.
5. Do not replace deleted defense with hype.
6. Preserve mathematical meaning, values, units, conditions, symbols, and citations.

### Pass 5 — Paper-level check

When the available scope supports it, check contribution disclaimers, standard-component self-positioning, result excuses, defended omissions, repeated limitations, unsupported adjectives, absolute claims, and generic summary sentences.

## Output format

For an explicit audit, use:

| Location | Original | Type | Severity | Necessary caveat? | Why it feels defensive | Likely reviewer reaction | Recommended action | Rewrite |
|---|---|---|---|---|---|---|---|---|

Severity levels:

- `Critical`: rebuttal-like, legalistic, or strongly self-protective;
- `Major`: repeated caveating, result excuses, defended omissions, or promotional compensation;
- `Minor`: local defensive phrasing.

A 0–10 paper-level score may be reported for a full-paper audit when meaningful, but it must not replace item-level evidence and recommendations.

## Mode boundaries

- In ordinary drafting, perform a lightweight pass and remove only high-confidence defensive wording.
- In polishing/translation, make the prose direct and evidence-bound without strengthening claims.
- In an explicit defensive-writing audit, run all five passes and provide the structured output.
- This audit does not substitute for a scientific, mathematical, algorithmic, or experimental validity audit.
