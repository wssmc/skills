# Solution Method Writing Specification

## 1. Start from the computational difficulty, not the algorithm name

Explain what the problem requires the solver to handle, for example:
- difficult feasibility;
- incomplete routes;
- expensive decoding;
- strong local optima;
- coupled resource decisions;
- need for intensification/diversification.

Then explain why the chosen baseline search framework is appropriate.

## 2. Separate inherited, adapted, and proposed mechanics

Classify each method element:
- **inherited**: standard baseline mechanism;
- **adapted**: published mechanism modified for this problem;
- **proposed**: genuinely new mechanism in this study.

Scientific responsibility, not code length, determines manuscript space.

## 3. Explain the overall framework as information/control flow

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

## 4. Write representation and decoding as a mapping

Representation should clarify:
- what the searched solution contains;
- which decisions are explicit;
- which decisions the decoder completes;
- whether representation restricts search;
- where feasibility is guaranteed.

Decoder should follow schedule-construction order rather than source-code call order.

## 5. Explain initialization as a search-design choice

State:
- how initial states are generated;
- why the strategy is suitable;
- how current/best/reference/population states are initialized;
- how later-stage states are obtained when inherited from earlier stages.

Do not move Chapter 5 calibration values into the method definition.

## 6. Write multiple neighborhoods as one coherent portfolio

Use the same rhythm for each move:

```text
purpose
→ selection
→ transformation
→ feasibility
→ resulting candidate
```

Then compare their search dimensions and scale. Explain complementarity only when supported by design logic or evidence.

## 7. Write method-specific mechanisms by scientific causality

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

## 8. Integrate the algorithm without forcing one presentation form

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

Pseudocode may be:
- overall;
- component-specific;
- or both.

The number of pseudocodes is determined by reproducibility needs, not by a template rule.
