---
description: Coding standards to follow when writing or modifying code in any project
user-invocable: true
---

- Invoke `local-rules` skill.
- Let code speak for itself. Choose clear names, extract well-named functions, and use types
  to document intent instead of comments.
- Group files by domain or feature (e.g. auth/, billing/), not by technical role
  (e.g. utils/, helpers/).
- Only export symbols that are imported by another module. Default to unexported.
- Give each React component its own file. Colocate small helpers and types in the same file
  if they serve only that component.
- Scaffold new modules, components, or packages with the project's CLI generators. Check AI
  docs for available commands before writing boilerplate by hand.
- Install dependencies through the package manager's add command so lockfiles and manifests
  stay in sync.
