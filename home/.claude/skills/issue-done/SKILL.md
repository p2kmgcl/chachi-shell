---
name: issue-done
description: Mark the issue currently being worked on as done. Use ONLY when the user explicitly says "/issue-done", "mark done", or "this issue is done". Do not auto-invoke when the user merely finishes a task or says "done" in passing.
---

# Done

Mark the in-progress issue as `done`.

## Process

### 1. Identify the issue

The active issue should be obvious from the conversation context — it's the one whose body was loaded by `/next-issue` (or whatever the user has been working on this session).

If you can't tell:

1. Identify the active PRD. PRDs live in `.agent-state/prds/<slug>/`. Infer the slug from conversation context; if only one PRD exists, use it; ask the user only if genuinely ambiguous.
2. Read all `issue-N.md` files in that PRD's directory (`.agent-state/prds/<slug>/`).
3. List those with `status: in-progress`.
4. If exactly one, use it.
5. If multiple, ask the user which one to mark done.
6. If none, report: "No in-progress issue found." and stop.

### 2. Flip the status

Update the issue file's YAML frontmatter:

```yaml
---
status: done
---
```

Do NOT tick the `- [ ]` acceptance-criteria checkboxes — they're aspirational and may not match exactly what was built.

Do NOT invoke `/commit` or any other skill — the user batches commits and pushes manually.

### 3. Report

Print: `Marked issue-N as done.`
