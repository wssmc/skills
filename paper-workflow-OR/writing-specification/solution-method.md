# Solution Method Writing Specification

## 1. Pass the method design gate before fixing subsection titles

Recover the scientific algorithm before deciding how Chapter 4 is divided:

1. identify the algorithmic states that actually exist;
2. reconstruct the complete state transition from input to returned solution;
3. classify each mechanism as inherited, adapted, or proposed;
4. identify dependencies and feedback among mechanisms;
5. derive subsection titles from scientific responsibilities and causal relationships.

Do not reuse the subsection structure of a previous algorithm by replacing only the algorithm name. Different algorithms may share Chapter 4 responsibilities, but their visible subsection titles and grouping should follow their actual logic.

## 2. Start from the computational difficulty, not the algorithm name

Explain what the problem requires the solver to handle, for example:
- difficult feasibility;
- incomplete routes;
- expensive decoding;
- strong local optima;
- coupled resource decisions;
- need for intensification/diversification.

Then explain why the chosen baseline search framework is appropriate.

## 3. Separate inherited, adapted, and proposed mechanics

Classify each method element:
- **inherited**: standard baseline mechanism;
- **adapted**: published mechanism modified for this problem;
- **proposed**: genuinely new mechanism in this study.

Scientific responsibility, not code length, determines manuscript space.

## 4. Explain the overall framework as information and control flow

The framework should answer what one complete search cycle does:

```text
input
→ initialization
→ representation/decoder
→ candidate generation
→ evaluation
→ acceptance/control
→ special mechanism
→ update
→ termination
```

The flowchart shows execution order; prose explains why the modules exist.

## 5. Assign each scientific fact a primary presentation carrier

| Primary carrier | Main responsibility |
|---|---|
| Prose | motivation, semantics, causal relationships, and interpretation |
| Flowchart | macro level control flow and information flow |
| Pseudocode | exact execution order and state updates |
| Equations | mathematical mechanisms that ordinary prose cannot state precisely |
| Operation diagram | state transformations, restrictions, and candidate outcomes |

Each scientific fact should have one primary presentation carrier. Other carriers may support it, but they should not reproduce it in full. In particular, do not repeat the same complete process in prose, a flowchart, and pseudocode.

## 6. Write representation and decoding as a mapping

Representation should clarify:
- what the searched solution contains;
- which decisions are explicit;
- which decisions the decoder completes;
- whether representation restricts search;
- where feasibility is guaranteed.

Decoder should follow schedule-construction order rather than source-code call order.

## 7. Explain initialization as a search design choice

State:
- how initial states are generated;
- why the strategy is suitable;
- how current/best/reference/population states are initialized;
- how later-stage states are obtained when inherited from earlier stages.

Do not move Chapter 5 calibration values into the method definition.

## 8. Write multiple neighborhoods as one coherent portfolio

Use the same rhythm for each move:

```text
purpose
→ selection
→ transformation
→ feasibility
→ resulting candidate
```

Then compare their search dimensions and scale. Explain complementarity only when supported by design logic or evidence.

## 9. Write method specific mechanisms by scientific causality

Use:

```text
failure mode
→ observed state/information
→ decision/trigger
→ intervention
→ state update/feedback
→ interaction
→ intended effect
```

Do not create a subsection for every helper function. Merge actions that belong to one causal mechanism chain.

## 10. Integrate the algorithm without forcing one presentation form

By the end of Chapter 4, the reader must be able to reconstruct the complete search process.

The final integration section should use an algorithm-specific title. It must connect:
- representation;
- decoder;
- initialization;
- neighborhoods;
- special mechanisms;
- current/candidate/best/reference state transitions;
- stopping;
- returned solution.

Define a state vocabulary before drafting. Terms such as `current`, `candidate`, `best`, `elite`, `reference`, and `archive` may be used only when the implementation or formal algorithm contains the corresponding state. Assign one term to each state and use it consistently across prose, equations, figures, and pseudocode. Do not alternate near synonyms for the same state, and do not collapse distinct states into one label.

Pseudocode may be:
- overall;
- component-specific;
- or both.

The number of pseudocodes is determined by reproducibility needs, not by a template rule.

## 11. Distinguish three complexity claims

Do not use `complexity`, `computational cost`, and `runtime` interchangeably:

- **Problem complexity** concerns the intrinsic difficulty of the optimization problem. Support it with a valid reduction, special-case argument, or authoritative citation, normally in Chapter 3.
- **Algorithmic complexity** concerns how the implemented algorithm's operations scale with explicit input dimensions. Derive it from source code or a frozen executable specification, including the actual loop structure, component calls, and relevant data-structure costs.
- **Empirical computational cost** concerns observed runtime, evaluations, memory, or solver effort under a stated environment and budget. Report it as experimental evidence in Chapter 5; it is not a Big-O result or proof of problem hardness.

If the implementation or executable specification is not frozen, do not invent a time-complexity expression. State only which components are expected to dominate, clearly labeling this as design-stage analysis rather than publication-level algorithmic complexity.
