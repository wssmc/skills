# Figures Guidance

Before writing about a figure, confirm:
- research question;
- x-axis;
- y-axis;
- experimental unit;
- aggregation;
- metric direction;
- series/color/marker meaning;
- plotted population;
- related experiment/table.

If these semantics are unknown, do not produce a formal scientific interpretation.

## Separate figure artwork from manuscript structure

Keep the graphic and the manuscript's title, caption, and explanation at separate levels.

- Do not place an overall figure title, caption, descriptive panel heading, or paragraph style explanation inside the artwork.
- Write the figure title and caption in the manuscript layout. Introduce and cite the figure in the main text, then explain the relevant relation, operation, or evidence there.
- Treat each distinct diagram or operation as a separate source asset by default. Combine assets as subfigures only when the panels serve a clear shared comparison. Keep panel assets independently editable and let the manuscript layout provide panel letters and subcaptions.
- Cite the relevant panel in the text when panels make different points. Do not rely on a reader to infer the panel's role from an embedded heading.
- Retain concise labels directly needed to interpret displayed objects or relations, such as axes, entity identifiers, `Before`/`After`, and necessary legend keys. Move explanatory sentences and interpretation to the caption or main text, and avoid repeating the same explanation in all three places.

## Visual collision and final scale gate

Check the complete visual, not only the arrows. Text, formulas, symbols, blocks, connectors, arrowheads, legends, and panel boundaries must not overlap or obscure one another. Leave enough clearance around labels. Connectors must avoid semantic objects, and their endpoints must identify the intended source and target without covering either one. Any crossing that could be mistaken for a relation must be rerouted or explicitly distinguished.

Inspect the figure at its actual final manuscript size. Review each source asset, the manuscript's assembled panel layout when applicable, and the rendered formal page. A figure fails this check if a label or relation becomes crowded, ambiguous, or unreadable at any applicable level.

## Python-generated figure style gate

Apply this gate whenever Python is used to draw a schematic, process diagram, flowchart, algorithm illustration, Gantt chart, or other manuscript figure.

The figure should look like a deliberate scientific or engineering figure, not a decorative AI-generated illustration. Use:

- a plain or restrained background;
- a limited and semantically meaningful color palette;
- consistent typography, line widths, markers, and arrow conventions;
- explicit labels, units, legends, and annotations;
- aligned objects, balanced spacing, and a reproducible layout;
- clean two-dimensional geometry suitable for print and grayscale inspection.

Avoid:

- decorative three-dimensional effects, neon gradients, glow, gloss, or excessive shadows;
- random icons, stock-style illustrations, ornamental backgrounds, or unrelated visual metaphors;
- excessive rounded cards, pseudo-handwritten elements, dense decorative arrows, or text that is not tied to a defined object or relation;
- visual variation that does not encode data, process, hierarchy, or a scientific distinction.

For a schematic, every node, arrow, color, and label should have a defined semantic role. For a quantitative plot, styling must not obscure the experimental unit, metric direction, scale, or comparison. Prefer reproducible vector-like output and verify legibility at the intended manuscript size.

## Final scale and deployment inspection

Do not approve an algorithm illustration from its standalone source alone. Inspect it at the final scale used in the manuscript.

In addition to the collision gate above, verify that:

- arrows do not pass through labels, formulas, job blocks, or other semantic objects;
- arrow direction and relation endpoints are explicit when different entity types appear together;
- the legend defines symbols but does not substitute for a key relation that must be visible in a panel;
- the illustrative instance is large enough to demonstrate the mechanism without creating a misleading special case;
- panels use consistent block dimensions, typography, colors, arrow conventions, spacing, and title treatment;
- labels, formulas, and distinctions remain readable after final scaling and grayscale conversion when relevant.

Inspect all three deployment levels when they exist:

```text
individual source figure
→ assembled multipanel figure
→ rendered page in the formal manuscript
```

A figure passes only when the scientific relation remains clear at every applicable level.

## Common figure types

| Figure type | Main purpose | Main narrative focus |
|---|---|---|
| Problem/process structure | explain entities, flow, constraints | objects, links, structural difficulty |
| Gantt chart | show schedule feasibility/structure | assignment, order, waiting, special constraints, objective |
| Algorithm flowchart | show control/information flow | main loop, trigger, return path, stopping |
| Representation/neighborhood illustration | show before/after transformation | selected objects, move, feasibility |
| Boxplot | compare distributions | median, IQR, overlap, outliers |
| Heatmap | compare two-dimensional result pattern | dominant regions, reversals, scale pattern |
| Convergence curve | compare search evolution | initial quality, early improvement, crossing, stagnation, final quality |
| Sensitivity/main-effects plot | show response vs factor | trend, turning point, stable/sensitive region |
| Bar chart | compare discrete categories | ranking, magnitude gap, near ties |
| Scatter plot | show relationship | association, clusters, dispersion, outliers |
| Critical-difference diagram | show rank groups | average ranks, statistically indistinguishable groups |

## Problem/process structure diagram

Narrative order:

```text
what the diagram represents
→ what nodes/links mean
→ key relation
→ how the relation changes scheduling feasibility/decisions
```

Sentence stems:

> `Figure X illustrates the operational structure of the considered problem.`

> `A directed link from A to B indicates that ...`

> `Unlike the technological precedence within a job, these links represent ...`

## Gantt chart

Confirm:
- time unit;
- row meaning;
- bar meaning;
- color/label meaning;
- whether the schedule is illustrative, optimal, best heuristic, or real-case.

Narrative order:

```text
schedule scope/objective
→ machine assignment
→ technological order
→ waiting/release constraints
→ resource competition
→ objective formation
```

Sentence stems:

> `Figure X presents a feasible schedule for the illustrative instance, with an objective value of ...`

> `The delayed start of operation ... is caused by ... rather than machine unavailability.`

> `The schedule therefore illustrates how ... and ... jointly determine ...`

## Algorithm flowchart

The core principle is: **simplify the presentation, not the algorithm. Establish logical and terminological accuracy before optimizing the layout.**

### Source fidelity and information granularity

Before drawing, reconstruct the control flow from the approved method description, pseudocode, and executable implementation when available. Node labels, objects, symbols, conditions, update targets, and execution order must be supported by these sources. If they disagree, verify and disclose the discrepancy; do not invent terminology or alter the algorithm to make the diagram easier to draw.

Show the main stages, search loops, acceptance logic, trigger branches, and stopping condition. Keep initialization concise unless it is a central mechanism. Related evaluation, update, and acceptance actions may share a node only when their actual order remains clear. Do not merge steps in a way that hides a branch, changes serial execution into parallel execution, or obscures which state is updated. Omit bookkeeping details that do not affect the communicated algorithm. Use the stopping condition and budget notation already defined; do not add unsupported resource labels.

### Node wording and notation

- Use a consistent grammatical form for nodes of the same type within one diagram. Process labels may use an action verb followed by its object or use noun phrases; choose a style and apply it consistently. Use questions for decision nodes and `Start` and `End` for the terminators.
- Keep labels concise but identify the object and action clearly. Prefer terminology already defined in the manuscript. Do not introduce an undefined abbreviation merely to shorten a label, and do not concatenate English words. Preserve spaces and wrap at semantic boundaries without splitting words, symbols, or mathematical expressions.
- When one process node contains multiple actions, separate them with semicolons and end the final action with a period.
- Match mathematical notation to the manuscript, including symbols, boldface, subscripts, and superscripts. State the operands for comparisons and distinguish coexisting solution states, such as a current solution, an elite associated with a member or search direction, and a shared or global best. Avoid isolated comparison fragments. Detailed update conditions may remain in the prose and pseudocode when the diagram would become overloaded, but the diagram must not imply a different condition.
- Use the exact stopping condition and resource terminology defined for the algorithm. Do not substitute a different limit or add an unsupported resource qualifier.

### Shapes and control flow conventions

- Use process rectangles for actions, decision diamonds for conditions, and rounded terminators for `Start` and `End`.
- For binary decisions, label outgoing branches `Y` and `N` consistently. Use concise outcome labels for genuinely multiway decisions.
- Put only the decision outcome on a branch. Put the resulting action in its destination node; do not write branch phrases such as `No: stop` or `Yes: restart`.
- Connect every branch to its next action or to `End`. Make merge points and loop returns unambiguous.

### Layout and visual style

Prefer a vertical main path, side branches for secondary paths, and return loops routed around the main nodes. Align peer nodes and use coordinated box widths, spacing, and internal margins. Keep arrows attached to node boundaries; they must not cross text or pass through node interiors. Avoid unnecessary crossings, overlaps, and long detours.

Shorten or semantically wrap long labels before reducing font size. Stage headings may span two lines when this keeps the main entry connector clear. Use a white background and black text, arrows, and connectors by default. Use color only to encode a meaningful distinction; avoid decorative gradients, shadows, and unnecessary legends. Check legibility in the final manuscript scale and in grayscale when relevant.

### Flowchart review gate

Before release, complete two complementary reviews:

- **Algorithm and evidence review:** Trace the main path and every decision outcome, merge, loop, state update, and stopping condition against the approved method description and Algorithm 1; compare the executable implementation when available. Confirm operation order, updated object, comparison target, and the meaning and reset rule of any counter or event. If a source is unavailable or a definition is ambiguous, mark the point as requiring source verification rather than silently resolving it.
- **Publication review:** Check that figure titles, panel headings, captions, and explanatory prose are outside the artwork; distinct diagrams are separate assets unless they form a purposeful comparison; and the figure follows the conventions above for `Start`/`End`, binary `Y`/`N` branches, outcome-only branch labels, node wording, notation, and punctuation. Inspect the source asset and, when applicable, the assembled figure and rendered manuscript page at final size.

When reporting findings, distinguish directly observable artwork violations, semantic questions that require checking the manuscript or implementation, and optional presentation improvements. Do not report a question requiring source verification as a confirmed algorithm error without inspecting the relevant source.

### Verification and source preservation

Compare the finished diagram against the prose, pseudocode, and implementation in execution order. Verify labels, symbols, conditions, updated states, branch destinations, and arrows; then inspect spelling, capitalization, spacing, punctuation, line breaks, clipping, and overlap. Preserve the drawing source so the figure can be reproduced or edited. Use vector PDF as the default manuscript export when compatible with the workflow and venue. Keep unapproved revisions in the project's temporary area and replace the formal figure only after review.

Labels and orderings supplied for one figure are local conventions, not universal defaults. Apply them only to that figure; do not promote them to general algorithm rules.

Do not narrate every box in the manuscript text.

Use:

> `Figure X summarizes the overall search flow of the proposed algorithm.`

> `After initialization, the method repeatedly ...`

> `When [trigger] is satisfied, [mechanism] is invoked before control returns to the main search.`

## Representation/neighborhood illustration

Narrative order:

```text
before state
→ selected element(s)
→ transformation
→ feasibility restriction
→ resulting candidate
```

For neighborhood illustrations, show the before and after states, identify the selected element or block, and make the transformation direction explicit. Use consistent highlighting and explain its meaning in a legend when needed. Keep each distinct move in its own source asset by default; combine moves only for a deliberate comparison. Do not put operator names or explanatory paragraphs in the artwork as panel titles. Ensure that movement arrows and selection marks do not cover jobs, positions, or labels.

## Boxplot

Confirm what one observation represents.

Instance-level boxplot:
- one observation = one instance-level aggregate;
- dispersion describes between-instance behavior.

Run-level boxplot:
- one observation = one independent run;
- dispersion reflects run-level variability (and possibly mixed instance effects if pooled).

Reading order:

```text
metric/unit
→ median/mean
→ IQR
→ distribution shift/overlap
→ outliers
→ connection to aggregate table
→ bounded conclusion
```

Sentence stems:

> `Figure X compares the distribution of [metric] across [experimental units] for the evaluated algorithms.`

> `[Method A] exhibits the lowest median [metric], followed by [Method B].`

> `The comparatively narrow interquartile range of [Method A] indicates more consistent performance across the tested instances.`

> `Although the two distributions overlap, the central mass of [Method A] remains shifted toward lower values.`

> `This distributional pattern is consistent with the aggregate [metric] reported in Table X.`

Example paragraph:

> `Figure X compares the distribution of instance-level mean RPD across the evaluated Small instances, with lower values indicating better solution quality. Method A exhibits the lowest median and mean RPD, while Method B forms the nearest competing distribution. In addition to its lower central tendency, Method A shows a relatively compact interquartile range, indicating more consistent performance across the tested instances. The two distributions partially overlap, so the advantage is not uniform on every instance; however, the central mass of Method A remains shifted toward lower RPD values. A few high-RPD outliers persist, showing that some instances remain difficult. Overall, the distributional evidence is consistent with the aggregate ARPD reported in Table X and suggests that the observed advantage is broadly distributed rather than driven by only a few favorable cases.`

## Heatmap

Confirm rows, columns, cell metric, color direction, and aggregation.

Sentence stems:

> `Figure X summarizes the group-level [metric], with rows representing [groups] and columns representing [methods].`

> `[Method A] maintains the best or near-best values across most groups, indicating that its aggregate advantage is not confined to a narrow subset.`

> `A reversal appears in [group], where [Method B] becomes competitive.`

## Convergence curve

Confirm:
- x-axis = CPU / wall time / evaluations / iterations / normalized time;
- whether initialization is included;
- y-axis = current / best-so-far / mean / median / RPD / objective;
- single run vs aggregated curve.

Narrative order:

```text
initial quality
→ early improvement
→ crossing
→ stagnation
→ late improvement
→ final quality
→ effort-quality implication
```

Sentence stems:

> `Figure X compares the best-so-far [metric] as a function of [search effort].`

> `[Method B] reaches an early plateau, whereas [Method A] continues to improve in the later search stage.`

Do not call an algorithm computationally faster unless the x-axis is a comparable effort measure.

## Critical-difference diagram

Do not equate better rank with statistical significance.

Use:

> `[Method A] obtains the best average rank; however, the connection between [A] and [B] indicates that their difference is not statistically distinguishable under the adopted procedure.`

## Figure discussion checklist

- semantics confirmed;
- experimental unit confirmed;
- aggregation confirmed;
- metric direction confirmed;
- dominant pattern stated;
- material exception reported;
- observation separated from explanation;
- conclusion limited to plotted data.
- publication style is restrained and free of decorative AI-like visual treatment;
- every visual element has a defined scientific or operational role.
- arrows and relation endpoints remain unambiguous at final manuscript scale;
- the source figure, assembled figure, and rendered manuscript page have been inspected when applicable.
- algorithm flowcharts preserve the actual execution order and match the method prose, pseudocode, and implementation in terminology, conditions, and update targets;
- flowchart branches, start and end nodes, stopping condition, and connectors follow the conventions above without adding bookkeeping or unsupported stages;
- node grammar, mathematical notation, punctuation for nodes with multiple actions, source preservation, and final scale readability have been checked.
