---
user-invocable: true
description: "Complete a git rebase, resolving conflicts along the way"
---

1. Start or detect rebase.
   - If a rebase is in progress, skip to step 2.
   - If no rebase is in progress, ask the user which branch to rebase onto and start the rebase.
2. Loop until the rebase is complete:
   - Check for conflicts:
     - If there are no conflicts, the rebase step succeeded — run `git rebase --continue` and repeat the loop.
     - For every conflicted file:
       - If the resolution is clear (eg. one side is a strict superset, a trivial formatting change, an import reorder, or the intent of both sides is obvious), resolve it directly using the Edit tool. Remove all conflict markers and produce the correct merged result.
       - If the resolution is ambiguous (e.g., both sides make substantive but different changes to the same logic, or you cannot determine which behavior the user intends), explain the conflict to the user with both sides' intent and ask how to proceed. Do NOT guess.
   - Continue the rebase.
