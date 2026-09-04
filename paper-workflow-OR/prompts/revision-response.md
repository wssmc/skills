# Revision Response Prompt

Prefer to run `revision-analysis.md` first.

For each reviewer comment, output:

```text
Reviewer comment
> [verbatim or faithfully preserved comment]

Response
[Direct scientific response.]

Changes in the manuscript
- Section/Page/Line: [location]
- Change: [specific revision]

Status
- Addressed / Partially addressed / Rebutted / Pending
```

Principles:
- when the reviewer is correct, acknowledge the issue and repair it;
- when disagreeing, use model/code/literature/experimental evidence rather than rhetoric;
- avoid submissive or confrontational language;
- do not write only `We have revised accordingly`;
- if no revised manuscript exists yet, do not claim that changes were made;
- when one comment affects Abstract, Method, Experiments, and Conclusion, list the cross-section changes.
