---
description: Load machine-local rule overrides for a given skill from ~/.claude/skills/<skill-name>/SKILL.local.md
user-invocable: false
---

You have been invoked by another skill to load local rules.

1. Determine the calling skill's name from the context (e.g. "write-docs", "write-code", "write-tests").
2. Check if `~/.claude/skills/<skill-name>/SKILL.local.md` exists.
3. If it exists, read it and return its contents as additional rules. These local rules take
   precedence over the calling skill's defaults.
4. If it does not exist, do nothing — no error, no warning.
