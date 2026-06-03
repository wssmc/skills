# Chapter 3: Problem Description Outline

## 3.1 Production process and object transformation

Explain the industrial process and how business objects are transformed.

Recommended content:

- raw order / original order;
- part / component;
- nesting sheet / cutting pattern / NEST order;
- merged order / consolidated order;
- downstream lot / batch / LOT;
- final scheduling object set.

## 3.2 Scheduling objects and precedence relationship

Explain which objects are scheduled and how inter-object dependencies are formed.

Recommended content:

- object types;
- processing stages;
- missing operations;
- DAG or precedence graph;
- release rule: a downstream object can start only after all required upstream objects are completed.

## 3.3 Assumptions

List assumptions explicitly.

Examples:

- machines in the same stage are identical;
- preemption is not allowed;
- missing operations do not occupy machines;
- machine breakdowns are not considered;
- setup, transportation, worker constraints are excluded or aggregated.

## 3.4 Illustrative example

Construct a small example with:

- 2–4 upstream objects;
- 1–3 downstream objects;
- at least one many-to-one relation;
- at least one skipped stage;
- a small processing-time matrix.

## 3.5 Gantt-chart interpretation

Explain what the Gantt chart should show:

- machine capacity conflicts;
- skipped stages;
- release waiting caused by upstream objects;
- completion time of each job;
- makespan.
