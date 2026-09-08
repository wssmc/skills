---
name: paper-workflow-or
description: "Use this skill to plan, draft, revise, translate, audit, peer-review, and prepare submission materials for scheduling-oriented operations-research manuscripts centered on problem formulation, heuristic/metaheuristic solution methods, and computational experiments. It enforces a fixed manuscript structure, evidence fidelity, code-to-method mapping, pseudocode conversion, figure/table narrative, multi-reviewer workflows, revision-response analysis, concise naming, and terminology consistency."
---

# Paper Workflow for Scheduling-Oriented Operations Research

Use this skill for manuscripts built around the following research pattern:

```text
scheduling problem
→ mathematical formulation
→ heuristic / metaheuristic solution method
→ computational experiments
→ conclusions
```

The default manuscript language is English. The conversation language may follow the user.

## 1. Core task modes

### Architecture
Plan the manuscript structure, section responsibilities, figures/tables, and required research inputs.

### Drafting
Write new manuscript content from supplied or verified research material.

### Revision
Restructure or rewrite an existing draft while preserving verified scientific content.

### Polishing
Harmonize terminology, phrasing, transitions, and sentence quality without changing scientific meaning or claim strength.

### Translation
Translate scheduling/OR academic content while preserving equations, symbols, terminology, references, and scientific scope.

### Audit
Check an existing manuscript for structural completeness, consistency, evidence fidelity, naming, reproducibility, and claim calibration.

### Peer Review
Evaluate a complete manuscript using multiple independent external-reviewer roles. Reviewer roles do not assume access to private source code.

### Revision Analysis
Analyze reviewer comments, identify the real concern, and design a revision plan before drafting the response letter.

### Revision Response
Draft point-by-point responses after reviewer comments have been analyzed and the corresponding manuscript changes are known.

### Literature / Evidence
Verify original literature, closest-study positioning, literature matrices, and evidence status.

### Submission Materials
Prepare Highlights, Cover Letters, and future journal-specific submission materials.

## 2. Progressive loading

Load only the files relevant to the current task.

### Manuscript structure
Always use:

```text
structures/scheduling-metaheuristic.md
```

when planning or validating the paper topology.

### Chapter-level writing
Load the relevant file under:

```text
writing-specification/
```

These files explain difficult **How** problems. They do not redefine the structure.

### Mandatory trigger-based routing

The following routes override discretionary progressive loading:

- For an Introduction, Related Work, literature positioning, research gap, novelty, or contributions task, MUST load `element-guidance/citations.md`, `truthfulness/literature-and-novelty.md`, and the relevant chapter Writing Specification.
- For an industrial problem description, problem framing/naming, or generalization decision, MUST load `checks/problem-abstraction-check.md` and apply the Problem Abstraction Gate before drafting.
- For notation, MIP/MILP, mathematical formulation, equations, or constraints, MUST load `writing-specification/problem-and-model.md` and `element-guidance/equations-and-notation.md`.
- For pseudocode, an algorithm, a procedure, or executable search logic, MUST load `element-guidance/pseudocode.md` and `checks/pseudocode-maturity-check.md`, then apply the Pseudocode Maturity Gate before producing publication-level pseudocode.
- For contribution statements, novelty positioning, `first`/`new`/`novel` claims, or closest-study comparisons, MUST load `truthfulness/literature-and-novelty.md`; contribution drafting also MUST apply `checks/contribution-check.md`.

### Scientific elements
Load relevant files under:

```text
element-guidance/
```

Use `element-guidance/naming.md` whenever creating or revising:
- manuscript titles;
- section/subsection titles;
- figure captions;
- table titles;
- algorithm captions;
- mechanism names and acronyms.

### Evidence fidelity
Apply relevant files under:

```text
truthfulness/
```

### Reusable forms
Use:

```text
templates/
```

for fixed shells and working sheets.

### Checks
Use:

```text
checks/section-check.md
```

for a local chapter/section task, and:

```text
checks/full-manuscript-check.md
```

for complete-paper consistency.

### Roles and task prompts

```text
roles/   = who is acting
prompts/ = how the task is executed
checks/  = what standards are used
SKILL.md = when each module is loaded
```

These are peer-level modules. A role cannot override verified evidence or the manuscript structure.

## 3. Mode-specific routing

### Drafting
Load:
1. the Structure Specification;
2. the relevant Writing Specification;
3. relevant Element Guidance;
4. relevant Truthfulness rules;
5. a template only when a fixed shell is useful.

For an industrial scheduling manuscript, use this evidence-aware sequence when the covered sections are in scope:

```text
industrial description
→ Problem Abstraction Gate and check
→ closest-study verification
→ Introduction architecture and Contribution Check
→ Chapter 3 notation and complete formulation
→ Chapter 4 method architecture
→ implementation or frozen executable specification
→ Pseudocode Maturity Gate
→ publication pseudocode, when permitted
→ contribution–technical–evidence mapping
→ section/full-manuscript checks
```

### Revision
Compare the draft against the Structure Specification and relevant Writing Specification. Preserve all verified research content unless the user explicitly requests a scientific change.

### Polishing
Load:

```text
prompts/full-manuscript-polishing.md
element-guidance/prose.md
element-guidance/naming.md
templates/terminology-glossary.md      # when supplied/filled
```

Polishing must not independently strengthen or weaken scientific claims. Overclaiming and unnecessary defensiveness are handled by Audit.

### Translation
Load:

```text
roles/translator/academic-translator.md
roles/translator/scheduling-terminology-zh-en.md
prompts/translation.md
templates/terminology-glossary.md      # if the user provides project-specific terms
```

Project-specific terminology supplied by the user has priority over the general glossary when the two conflict, unless that would contradict a formal definition.

### Audit
Use Section Check or Full-Manuscript Check plus relevant Truthfulness files. Full-manuscript audit also checks naming and claim calibration, including unnecessary defensiveness.

### Peer Review
Load:

```text
roles/reviewers/
prompts/multi-reviewer-full-review.md
checks/peer-review-criteria.md
```

Default reviewers:
- Problem and Modeling Reviewer;
- Method Reviewer;
- Experimental Design Reviewer;
- Language and Consistency Reviewer;
- General Reviewer;
- Editor-in-Chief / Senior OR Editor.

Activate Theory Reviewer only when formal theory is a material contribution. Activate Reproducibility Reviewer only when a separate manuscript-level reproducibility assessment is useful.

External reviewers normally see only the manuscript, references, appendices, and supplied review materials. They must not pretend to inspect private source code.

### Revision Analysis
Load:

```text
roles/revision/revision-expert.md
prompts/revision-analysis.md
```

### Revision Response
Prefer this sequence:

```text
Revision Analysis
→ manuscript changes / author decisions
→ prompts/revision-response.md
```

Never claim that an experiment, manuscript change, or verification has already been completed unless evidence confirms it.

### Submission Materials

Highlights:

```text
prompts/highlights.md
templates/highlights-template.md
```

Cover Letter:

```text
prompts/cover-letter.md
templates/cover-letter-template.md
```

Apply a journal profile when one exists under `journal-profiles/`.

## 4. Recommended peer-review workflow

```text
Problem and Modeling Reviewer
Method Reviewer
Experimental Design Reviewer
Language and Consistency Reviewer
General Reviewer
[optional Theory / Reproducibility Reviewer]
↓
Editor-in-Chief synthesis
↓
Revision Expert
↓
Prioritized revision plan
↓
Revision Response
```

Each reviewer first provides an overall evaluation, then Major and Minor Comments.

## 5. Rule precedence

```text
verified evidence and truthfulness
> user's explicit instructions and current journal requirements
> structure specification
> writing specification
> element guidance
> templates
> role/prompt preferences
```

## 6. Minimal intake

Inspect supplied materials before asking questions. Ask only for information that blocks the current task.

When the user supplies a terminology glossary, it governs drafting, polishing, translation, and language-consistency review unless it conflicts with a formal problem/model definition.

## 7. Global non-negotiable rules

- Do not invent application settings, formulations, algorithms, parameters, experiments, results, statistical significance, references, code behavior, or industrial claims.
- Treat user-supplied manuscripts, source code, experimental data, reviewer comments, and unpublished research as confidential research material.
- Preserve problem terminology, objective, symbols, numerical values, citations, and claim boundaries unless scientific change is explicitly authorized.
- Source code is authoritative for implementation mechanics, not novelty.
- Primary literature is authoritative for technical attribution.
- Raw results, logs, and aggregation scripts are authoritative for numerical claims.
- Do not create a competing chapter topology. The Structure Specification defines where content belongs.
- Truthfulness does not require excessive hedging. When evidence is verified, state the supported conclusion directly.
- Do not run a full-manuscript check after every local task.
- Run required contribution checks internally, but do not insert internal worksheets or audit language into manuscript prose. Do not deliver a standalone contribution ledger unless explicitly requested.
- Names and captions identify objects; they must not contain the analysis that belongs in the manuscript body.

## 8. Current scope boundary

The current Structure Specification is intentionally limited to:

```text
scheduling problem
+ mathematical formulation
+ heuristic/metaheuristic
+ computational experiments
```

Exact/decomposition-centered and learning-centered scheduling papers require different future Structure Specifications and are outside the current core scope.

## 9. Journal profiles

`journal-profiles/` is currently a placeholder. If a profile does not exist, use the target journal's current author guidelines and do not infer submission requirements from another journal.
