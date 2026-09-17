# Formal Manuscript Deployment Check

Use this check when transferring approved review material into the formal journal or submission source. This check validates deployment integrity; it does not replace scientific section checks or a full manuscript audit.

## 1. Deployment chain

```text
review artifact
→ approved source
→ formal path mapping
→ figure checksum verification
→ template compatible float placement
→ compile the unique formal main file
→ inspect the rendered pages
→ verify references, captions, and section boundaries
```

## 2. Establish the approved source

Identify the exact reviewed artifact and the approved revision. Do not deploy from an earlier draft, a temporary export, or an unapproved working copy merely because it has a similar filename.

Record the mapping from each approved section, table, figure, and bibliography source to its formal manuscript path. Preserve project specific template commands unless a deliberate, verified change is required.

## 3. Verify figures and paths

For each deployed figure:

- confirm that the formal source resolves the intended file;
- compare checksums or another reliable identity record when duplicate filenames or copied assets exist;
- confirm that the caption, label, panel order, and in text reference match the approved artifact;
- inspect the source figure, any assembled figure, and the rendered manuscript page;
- ensure that the final size preserves labels, arrows, formulas, and distinctions.

## 4. Adapt review markup to the formal template

Do not copy review only controls into the formal source without evaluating their effect. This includes forced `[H]` placement, temporary paths, diagnostic comments, draft annotations, and local spacing patches.

Use float placement compatible with the formal template. A figure or table must not intrude into the next chapter or section heading, separate a heading from its opening text, or create a misleading caption association.

## 5. Compile the authoritative main file

Identify and compile the one formal main file used for submission. A successful build of a review wrapper, chapter fragment, or alternate main file does not validate the formal manuscript.

Check the build log for unresolved references, missing citations, missing assets, duplicate labels, overfull content that affects readability, and template errors. Build success alone is not a pass condition.

## 6. Inspect actual pages

Inspect the rendered pages around every deployed change and at all affected boundaries. Verify:

- section and chapter boundaries;
- float placement and page breaks;
- figure and table scaling;
- captions and numbering;
- cross references and citations;
- equation and algorithm placement;
- headers, footers, and template specific layout.

## 7. Output

```text
Formal main file:
Approved source revision:
Mapped artifacts:
Figure identity verification:
Compilation status:
Rendered pages inspected:
Reference and caption status:
Section boundary status:
Deployment status: PASS / REVISION NEEDED
```
