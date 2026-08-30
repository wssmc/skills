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
- Inspect version-control status or another change baseline when available; preserve unrelated user changes.
- Compile or inspect the current build log before editing when feasible so pre-existing errors are not attributed to the revision.
- Check whether the template prescribes section titles, abstract length, highlights, author statements, appendices, and caption style.
- Build an inventory of labels, references, figures, tables, equations, algorithms, citations, and included files.
- Establish the requested file/section scope and the source of truth for formulas, algorithms, and result values.

## Editing rules

- Respect the template before the generic six-section structure.
- Preserve mathematical semantics and user-supplied numerical results.
- Keep labels stable where possible; update all references when labels change.
- Use `\label` after `\caption` for figures/tables unless the template requires otherwise.
- Do not manually type result values in multiple places when they can be sourced from generated files.
- Keep planning comments and placeholders out of submission-ready text.
- Use actual algorithm/component names in headings and captions.
- Preserve custom macros, bibliography keys, author comments, and formatting commands unless they are explicitly in scope or demonstrably broken.
- Prefer narrow edits over global search/replace when commands, math, or citation keys could be affected.
- Do not regenerate figures/tables from guessed data. Trace generated artifacts to their script/data source or report that regeneration was not verified.

## Native-format section drafting

When drafting or revising a manuscript section inside a LaTeX project:

1. Trace the main file's `\input`/`\include` chain to the actual section file.
2. Inspect adjacent section titles, equation/algorithm environments, custom macros, citation keys, and the existing label/reference scheme before writing.
3. Reuse existing `\label` targets and cite earlier definitions with `\ref`, `\eqref`, or the template's established command. Do not duplicate equations solely to make a section self-contained.
4. Edit or create the native `.tex` section. Do not deliver Markdown for later mechanical conversion, and do not invent equation, figure, table, or algorithm numbers.
5. If no project exists but LaTeX is the requested deliverable, return a self-contained, insertable LaTeX fragment and identify unresolved labels/citations outside the fragment.

For method sections reconstructed from code, inspect the problem/model file, contribution statement, existing method text, and implementation together. Preserve the boundary among prior-chapter definitions, method mechanisms, numerical experiment settings, and code-only details.

## Validation

After editing, check:

- compilation status and relevant warnings, compared with the pre-edit baseline when available;
- undefined references/citations;
- duplicate labels;
- missing files;
- overfull boxes caused by tables/equations;
- figure/table order and placement;
- stale numbers and captions;
- bibliography entries unused or cited but missing;
- consistency between abstract, contributions, results, and conclusions.
- the actual diff for accidental scope expansion, changed equations/numbers, or unrelated formatting churn.

Use the project's documented build path when present. Do not introduce a new toolchain merely to make a local build pass unless the user requests it. If compilation cannot be completed, report the exact command attempted and unresolved dependency/error instead of claiming success.
