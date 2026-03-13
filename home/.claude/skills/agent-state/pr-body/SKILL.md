---
user-invocable: false
disable-model-invocation: true
---

# pr-body.md — PR Description Body

Temporary file holding the PR description markdown. Written by pr-creator during body generation, consumed by `gh pr create --body-file` or `gh pr edit --body-file`, then deleted.

## Location

`.agent-state/pr-body.md`

## Format

Raw markdown following the structure and rules defined in the PR template file (referenced in CLAUDE.local.md).

## Lifecycle

1. **Created** by pr-creator step 5 after reading the PR template rules
2. **Consumed** by pr-creator step 6 or 7 via `--body-file`
3. **Deleted** after the PR is created or updated
