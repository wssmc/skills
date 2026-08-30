# Polishing and translation

## Default language behavior

- Manuscript-ready output defaults to English.
- Discussion follows the user's language.
- Chinese output is available on request.
- Bilingual output should preserve one-to-one technical meaning, equation references, variable names, and claim strength.

Match the requested intervention level:

- **Copyedit:** grammar, punctuation, diction, and local flow only.
- **Substantive polish:** sentence/paragraph organization while preserving argument and evidence.
- **Translation:** faithful technical transfer plus target-language academic restructuring.
- **Consistency pass:** terminology, symbols, abbreviations, capitalization, captions, and cross-references across a supplied scope.

Do not silently perform a substantive rewrite when the user requested proofreading.

## Academic English goals

Use clear, restrained OR journal prose:

- decision/problem first;
- explicit assumptions and boundaries;
- technical nouns instead of decorative adjectives;
- active voice where ownership is clear;
- precise evidence verbs: `formulate`, `derive`, `design`, `compare`, `observe`, `demonstrate under the tested settings`.

Avoid:

- repeated `Furthermore/Moreover/In summary` templates;
- inflated novelty adjectives;
- rhetorical questions;
- unsupported causal language;
- generic contribution labels when a concrete contribution title is possible;
- changing technical meaning to improve fluency.
- replacing precise technical terms with stylistic synonyms that break terminology consistency.

## Translation workflow

1. Identify technical terms, model names, variables, and abbreviations.
2. Preserve mathematical and experimental meaning.
3. Convert Chinese rhetorical order into journal-appropriate English order rather than translating word-for-word.
4. Keep evidence strength unchanged.
5. Check cross-references, captions, and terminology consistency.
6. Flag ambiguous source statements instead of guessing.

For LaTeX source, preserve commands, math delimiters, citation/reference keys, labels, protected capitalization, and nonbreaking spaces. Edit visible prose inside command arguments only when the command's semantics are understood.

## Claim calibration

Prefer:

- `This study extends ...`
- `We formulate ...`
- `We design ... to address ...`
- `Under the tested instances and settings, ...`
- `The component is particularly effective when ...`

Avoid `first`, `groundbreaking`, `fully solves`, `universally applicable`, and `significantly outperforms` unless verified and statistically supported.

## Delivery

Return clean revised text by default. Add a compact ambiguity or terminology note only when a choice affects technical meaning, evidence strength, or consistency. Provide side-by-side/source-change explanations only when requested or when the revision is otherwise difficult to verify.
