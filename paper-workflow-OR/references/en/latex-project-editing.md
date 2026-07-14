# Direct LaTeX project editing

## Inspection order

1. Main `.tex` file and document class/template.
2. `\input`/`\include` chapter files.
3. `.bib` and bibliography style.
4. Figure files and caption/label locations.
5. Generated tables/result files.
6. Algorithm environments and pseudocode.
7. Code, solver logs, and experiment outputs.
8. Journal-specific front/back matter.

## Before editing

- Identify the build command and compiler.
- Check whether the template prescribes section titles, abstract length, highlights, author statements, appendices, and caption style.
- Build an inventory of labels, references, figures, tables, equations, algorithms, citations, and included files.
- Preserve a clear change scope; do not overwrite unrelated user work.

## Editing rules

- Respect the template before the generic six-section structure.
- Preserve mathematical semantics and user-supplied numerical results.
- Keep labels stable where possible; update all references when labels change.
- Use `\label` after `\caption` for figures/tables unless the template requires otherwise.
- Do not manually type result values in multiple places when they can be sourced from generated files.
- Keep planning comments and placeholders out of submission-ready text.
- Use actual algorithm/component names in headings and captions.

## Validation

After editing, check:

- compilation status and warnings;
- undefined references/citations;
- duplicate labels;
- missing files;
- overfull boxes caused by tables/equations;
- figure/table order and placement;
- stale numbers and captions;
- bibliography entries unused or cited but missing;
- consistency between abstract, contributions, results, and conclusions.

If compilation cannot be completed, report the exact unresolved dependency or error instead of claiming success.
