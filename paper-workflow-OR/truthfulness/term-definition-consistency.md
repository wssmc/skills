# Term Definition and Consistency

Use this guidance when a user supplies project terminology, a technical term has multiple plausible meanings, or analysis of a manuscript or code depends on the operational meaning of a state, event, counter, or stopping condition.

## Definition priority and discrepancy handling

- Follow the user's explicit definition as the intended project terminology. Do not silently replace it with a more familiar meaning from general literature or from another project.
- Keep terminology separate from factual claims about a paper, model, or implementation. If the user's intended meaning differs from the meaning actually used in the supplied source, state both meanings and identify the evidence for the source meaning; do not imply that the source implements the user's definition.
- If using the requested label in a manuscript would conflict with an established formal meaning and mislead readers, explain the conflict and suggest a clearer label. Do not silently rename the user's concept or present the conflict as settled without their direction when it materially affects the paper.
- If the paper, code, and current analysis use a term differently, identify each meaning and where it applies. Do not force them into one definition merely because the same word appears in each source.
- If the source context resolves the difference, explain it directly and proceed using the confirmed distinction. Ask one concise clarification only when the meaning remains unresolved and would materially change the method, implementation, experiment, or interpretation.
- Once a definition has been confirmed, carry it forward consistently. Do not repeatedly ask for it or silently change it in later prose, figures, pseudocode, or analysis.

## Operational definitions

At first use of a key operational term, and whenever its meaning changes, state enough to identify:

1. **Referent and scope:** which object, state, member, operator, population, or process the term describes;
2. **Unit or event:** what is counted or observed, when a count or status changes, and whether the unit is an iteration, round, generation, candidate evaluation, elapsed time, or another defined event;
3. **Criterion:** the precise condition that makes the term true, including any threshold or comparison;
4. **Reset or update rule:** when its counter, status, or history is reset or updated, if applicable;
5. **Implementation mapping:** the corresponding variable, control flow event, data structure, or logged field when code is available.

Do not force a reset rule onto a static concept. For terms without counters or evolving state, explain only the dimensions needed to disambiguate them. A label or variable name alone is not an operational definition; verify what the implementation actually tests and updates.

## Distinctions that must not be collapsed

Inspect the actual implementation and distinguish, when applicable:

- **Global best stagnation:** no improvement to the best known solution over a defined scope and counting unit;
- **Member level lack of progress:** absence of the progress event defined for that member. Verify whether the implementation tracks accepted moves, improvement to that member's own best, or another criterion; these are not interchangeable by default;
- **Operator failure:** a defined unsuccessful operator event, such as failure to generate a valid candidate, only if that is what the implementation records. It is not automatically equivalent to rejection, lack of global improvement, or a move that does not improve the objective;
- **Round, generation, and evaluation count:** these are different units unless the algorithm explicitly defines them as equivalent. Identify the event that advances each counter, including whether initialization or auxiliary evaluations count.

These are examples of ambiguity checks, not prescribed definitions. Never attribute a specific criterion, window, or reset policy to them without evidence from the user's definition or the actual method or code.

## Common ambiguity checklist

Use this as a prompt to inspect likely terms, not as a required vocabulary list or a source of default definitions. Load only the entries relevant to the current method or claim.

| Term group | Common terms to check | Clarify when relevant |
|---|---|---|
| Solution states | current solution, candidate solution, best so far, global best, incumbent, local or member best, elite solution, reference solution, archive | Owner and scope; comparison target; update rule; whether the state can be replaced or is historical; distinguish an incumbent from a proven optimum and from local or current best states |
| Move outcomes | improvement, acceptance, rejection, operator success, operator failure, feasibility, repair success | Whether the event means a valid candidate was generated, a candidate was accepted, an objective improved, or a constraint was satisfied |
| Search progress | stagnation, no progress, convergence, local optimum | Tracked object; exact condition; counting unit; observation window; reset rule; whether the claim concerns the current state or best known state |
| Search units and evaluations | iteration, round, generation, epoch, candidate evaluation, objective evaluation, function evaluation, decoder call | Which event increments the count; whether initialization, retries, auxiliary search, or repeated decoding are included |
| Search components | neighborhood, move, operator, decoder, evaluation, restart, perturbation, repair | Whether the term names a set of reachable solutions, one transformation, a procedure, or a separate state transition; the order in which components run |
| Budget and stopping | iteration budget, evaluation budget, CPU time, wall clock time, time limit, stopping condition | Which resource is measured; when measurement starts; what event triggers termination; how it appears in the actual invocation |
| Experimental units and summaries | run, repetition, seed, result by instance, result across runs, mean, median, best result, runtime | What one observation represents; how runs and instances are aggregated; which timing scope is reported |

Do not assume that paired terms in a row are synonyms. For example, acceptance is not the same as improvement, and a decoder call is not necessarily counted as an objective evaluation. State the definition supplied for the project and its implementation mapping where the distinction affects the method or result.

## Consistency across sources

For each operational term used in the manuscript, verify consistency across:

```text
user or project definition
→ source paper or formal model, when relevant
→ implementation and logs, when available
→ prose, pseudocode, figures, and experiment descriptions
```

If these sources use the same word for different objects or counting units, preserve the distinction explicitly and explain it to the user. Record definitions supplied for the project in `templates/terminology-glossary.md` when a glossary is in use.
