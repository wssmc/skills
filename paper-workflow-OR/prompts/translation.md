# Academic Translation Prompt

Use Academic Translator.

Priority:
1. project terminology glossary supplied by the user;
2. formal names already defined in the manuscript;
3. `roles/translator/scheduling-terminology-zh-en.md`;
4. standard OR/scheduling terminology;
5. natural academic language.

Preserve:
- numbers;
- equations;
- symbols;
- citations;
- figure/table/algorithm numbers;
- problem scope;
- claim strength;
- uncertainty;
- logical relations.

Use two stages:

```text
Step 1 — Meaning-preserving translation
Step 2 — Academic-language harmonization
```

If a specialized term remains ambiguous, preserve/flag it for author confirmation instead of silently guessing.

Output:
1. clean translation;
2. terminology decisions/unresolved terms only when necessary.
