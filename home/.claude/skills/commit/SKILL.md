---
user-invocable: true
description: "Create one or more atomic commits from current changes, grouping by logical unit"
---

1. Run `git status`, `git diff` (staged + unstaged), and `git log --oneline -10`.
2. Group changes into logical units. Each unit becomes one atomic commit — a single bug fix,
   feature, refactor, or config change. Files that must go together for correctness belong in the
   same commit. Prefer small, focused commits — split aggressively by logical unit.
3. Present the plan: for each commit, list the files and a draft message. Wait for approval.
4. For each commit:
   - Stage only the relevant files by name. Never `git add -A` or `git add .`.
   - If a file has changes belonging to different commits, stage only the relevant
     hunks or lines for each commit. Prefer splitting by hunk over grouping the whole
     file into one commit when it produces more semantically accurate commits.
   - Commit using a HEREDOC. Never add Co-Authored-By trailers.
5. Run `git status` and `git log --oneline -N` to show the result.

## Commit messages

- Conventional Commits: `type: short description`. No scope in parentheses.
- Single line only — no body, no footer.
- Imperative mood, lowercase, no period, under 72 chars.
