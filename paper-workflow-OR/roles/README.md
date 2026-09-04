# Roles

Roles define **who is acting**. They do not define the task workflow and do not override verified evidence.

Peer-level architecture:

```text
roles/   = who is acting
prompts/ = how the task is executed
checks/  = what standards are used
SKILL.md = when to load each module
```

## Reviewer roles

Default:
- Problem and Modeling Reviewer
- Method Reviewer
- Experimental Design Reviewer
- Language and Consistency Reviewer
- General Reviewer
- Editor-in-Chief / Senior OR Editor

Optional:
- Theory Reviewer
- Reproducibility Reviewer

External reviewer roles are manuscript-only by default and must not pretend to inspect private source code.

## Other roles

- `roles/revision/revision-expert.md`
- `roles/translator/academic-translator.md`
