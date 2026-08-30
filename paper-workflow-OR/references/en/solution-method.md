# Solution method

Build the method section from algorithmic responsibilities and contribution evidence, not from source-code layout. The method section may be Section 3, 4, or another number; use the manuscript's actual structure.

If the problem/model chapter is also being planned and coordination would reduce repeated work, optionally use the [coordinated problem-method section workflow](problem-method-joint-writing.md). It is not a gate for drafting this section independently.

## 1. Evidence and chapter-responsibility gate

Before outlining or drafting, inspect the available sources in this order:

1. abstract, introduction, or contribution statement;
2. problem/model section and its equation labels;
3. existing solution-method text and pseudocode;
4. implementation source and tests;
5. experimental-settings or result files.

Treat the problem/model text as authority for problem definitions, the contribution statement as authority for novelty claims, and code as evidence of mechanics. Code does not by itself establish novelty, importance, or the manuscript outline.

Classify each candidate item before placing it:

- **Problem/model:** objective, feasibility relations, and standard schedule-construction or completion-time recurrences. Define and label them once in the problem/model section, then cross-reference them from the method.
- **Solution method:** encoding/decoding, construction, repair, neighborhood operators, search control, adaptation, bounds, cuts, and learning interfaces. Explain them here to the detail required for correctness and reproduction.
- **Computational study:** numerical parameter values, tuning ranges, budgets, seeds, hardware, and comparison protocols. Define mechanism symbols here, but report tested values and calibration there.
- **Code-only implementation:** copying, generic guards, logging, library behavior, and defensive error handling. Omit them unless they change the algorithm definition, feasibility, fairness, reproducibility, or meaningful complexity.

If the contribution hierarchy is absent or conflicts across sources, do not infer it from function length, naming, or sophistication. Ask one concise blocker only when a manuscript-ready novelty claim depends on the answer; otherwise mark novelty as unresolved and use neutral wording.

## 2. Select the method branch and contribution hierarchy

State the computational or analytical need, the exploited problem structure, and the method class. Do not claim that direct solution is insufficient unless complexity, scale, exact/reference experiments, or a documented requirement supports it.

Select content by method type:

- **Exact/decomposition:** formulation transformation, bounds, master/subproblem or pricing/separation logic, validity, convergence/termination, and implementation details needed for reproduction.
- **Heuristic/metaheuristic:** solution representation/construction, feasibility handling, initialization when material, candidate-generation operators, search-control logic, proposed mechanisms, stopping conditions, and stochastic protocol.
- **Approximation:** algorithm plus a proved or verified guarantee and its assumptions.
- **Learning-assisted:** learning target, data split, features, leakage controls, optimization interface, feasibility safeguards, and comparison with non-learning baselines.
- **Hybrid/matheuristic:** decision ownership, interfaces, exchanged information, budget allocation, and the order or feedback loop among components.

Classify every component as one of:

- **inherited/standard:** describe concisely but sufficiently for reproduction, and cite when a source is available;
- **problem-adapted:** explain the modification, why the problem requires it, and how behavior differs from the base component;
- **claimed core contribution:** give the most detail, including mechanism, interfaces, rationale, and the evidence needed to support its claimed role;
- **unresolved:** describe mechanics neutrally and keep novelty language pending.

Detail follows algorithmic responsibility, reproducibility risk, and supported contribution status—not code length.

## 3. Use a content-driven method architecture

Choose only the modules that exist; do not force fixed numbering or a fixed number of subsections.

1. **Opening and overall framework:** design motivation, method class, inputs/outputs, modules, information flow, and contribution map.
2. **Representation, construction, or decomposition:** encoded decisions, decoded decisions, feasibility, objective interface; or truthful exact-method functions such as master/subproblem, pricing, separation, or cut generation.
3. **Initialization:** only when it affects the method, performance, or reproducibility.
4. **Candidate generation:** neighborhoods, destroy/repair, mutation, branching candidates, or other procedures that produce alternatives.
5. **Search or solution control:** operator selection, acceptance, current/reference/best-state updates, tabu or neighborhood schedules, cooling/restarts, bounds, termination, and budget logic.
6. **Proposed mechanisms:** adaptation, guidance, learning, intensification/diversification, or problem-specific procedures whose claimed contribution status is supported or explicitly unresolved.
7. **Integrated pseudocode:** the end-to-end procedure after all required symbols and components are defined.
8. **Properties or complexity:** correctness, feasibility preservation, bounds, termination, convergence, approximation, or meaningful dominant cost when justified.

Not every module needs a top-level heading. However, when candidate generation and search control both exist, preserve their distinct responsibilities in headings or clearly bounded paragraphs; do not describe an operator as if it were the entire metaheuristic. For exact, decomposition, learning-assisted, and hybrid methods, use analogous responsibility boundaries rather than forcing neighborhood-search terminology.

Use a framework figure only when interfaces, iteration flow, or information exchange are not already clear from concise prose and pseudocode. A suitable caption is `Figure X. Overall framework of the proposed [method name].`

## 4. Place formulas by what they define

- A formula that defines the problem, feasible solution, objective, or standard schedule evaluation belongs in the problem/model section when already established there; cite its label in the method.
- A formula that defines an algorithm-specific decoder, repair rule, score, acceptance probability, weight update, bound, cut, or incremental evaluator belongs in the method.
- A formula should normally be defined once. Do not repeat it with new notation or numbering merely for local convenience.
- Define parameter roles and symbols with the mechanism. Put numerical defaults, tuning grids, and selected values in the computational study unless a value is part of the algorithm's mathematical definition.

A standard evaluator implemented as a function is not automatically a method contribution. Conversely, a new decoder or repair procedure remains method content even if it computes the same model objective.

## 5. Reconstruct method logic from code without transcribing it

Trace the main call path, state variables, data flow, and update order. Build a component ledger before drafting when the code contains multiple mechanisms. Do not map each function to a subsection or each assignment to an equation.

Include code behavior only when it affects at least one of: algorithm definition, candidate set, feasibility, objective evaluation, stochastic behavior, tie handling with scientific consequences, fairness of comparison, reproducibility, or dominant complexity. Usually omit generic copying, defensive guards outside the intended domain, logging, container operations, and library-specific behavior. Mention a small-instance fallback or tie rule only if it changes the defined method or a fair/reproducible comparison.

For every included component, state:

1. purpose and targeted failure mode;
2. inputs, outputs, and owned state;
3. procedure, formula, or decision rule;
4. feasibility and interface with adjacent components;
5. inheritance/adaptation/contribution status and supporting source;
6. detail or evidence still missing.

## 6. Keep generation, control, and adaptation distinct

- **Candidate-generation operators** answer how a neighboring or alternative solution is produced.
- **Search control** answers which operator is called, whether a candidate is accepted, how current/reference/best states change, how the search schedule evolves, and when it stops.
- **Proposed adaptive or guidance mechanisms** answer how information collected during search changes later decisions.

Describe an adaptive operator-selection mechanism only after the operator set and baseline controller are clear. Define its observable state, reward/score rule, update timing, reaction or learning coefficient, safeguards, and how weights become selection probabilities. Numerical values and calibration evidence belong in the experiment section. Do not call adaptation novel unless the contribution statement and literature evidence support that claim.

## 7. Write integrated pseudocode last

Before the integrated algorithm, define every symbol and component it invokes. Then align pseudocode with the actual execution order:

1. inputs, outputs, and initialization;
2. current, candidate, reference/incumbent, and global-best states as applicable;
3. component/operator selection and candidate construction;
4. evaluation and feasibility handling;
5. acceptance and state updates;
6. learning/adaptation, bounds, or schedule updates;
7. termination and returned output.

Cross-check improvement direction, tie handling, mutation versus copying, state aliases, temperature/budget update order, and stopping conditions against the implementation. Use component-level pseudocode only when the integrated procedure would otherwise be ambiguous or excessively dense.

## 8. Separate method definition from experimental evidence

The method section defines mechanisms, variables, interfaces, and stopping logic. The computational study reports numerical settings, tuning, budgets, instances, seeds/repetitions, baselines, ablations, timing, and statistical evidence. A default value in code is not proof that it is a principled method constant.

For exact/decomposition methods, discuss correctness, validity, bounds, or finite convergence only with support. For approximation methods, state a guarantee only if proved or verified. For heuristic/metaheuristic methods, discuss feasibility preservation, termination, and time complexity only when meaningful. Define scale parameters and include solver calls or variable iteration counts in any complexity statement; do not add decorative Big-O expressions.

## 9. Work LaTeX-first when LaTeX is the source or target

Inspect the main file, included method and problem/model files, existing labels/references, macros, citation keys, and algorithm environments. Reuse `\ref`/`\eqref` and native environments, edit or generate `.tex` directly, and never invent displayed numbers. Apply the direct-LaTeX editing reference for compilation and cross-file checks.

## 10. Final method-section audit

Confirm that:

- every claimed contribution has an identified source and evidence path;
- standard, adapted, proposed, and unresolved components are not conflated;
- prior-chapter equations are cross-referenced and algorithm-specific mechanisms are not omitted;
- candidate generation, search control, and proposed mechanisms have clear responsibility boundaries;
- integrated pseudocode uses previously defined symbols and consistent state semantics;
- experiment values and code-only details have not leaked into the method narrative;
- claims of novelty, optimality, convergence, or complexity do not exceed the available evidence.
