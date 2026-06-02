---
name: local-rules
description: Load machine-local rule overrides for a given skill from the shared ~/.agents skills directory.
---

You have been invoked by another skill to load local rules.

1. Determine the calling skill's name from the context (e.g. "write-docs", "write-code", "write-tests").
2. Locate the shared skills root at `$HOME/.agents/skills`.
3. Check if `$HOME/.agents/skills/<skill-name>/SKILL.local.md` exists.
4. If it exists, read it and return its contents as additional rules. These local rules take
   precedence over the calling skill's defaults.
5. If it does not exist, do nothing - no error, no warning.
