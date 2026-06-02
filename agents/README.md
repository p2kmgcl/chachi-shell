# Agent Instructions

Product-agnostic agent resources live here so multiple AI CLIs can reference
the same instructions without depending on a vendor-specific dotfiles path.

## Layout

- `skills/`: canonical reusable task instructions.

Claude-specific installation uses lightweight loader skills in
`home/.claude/skills/`. Those loaders preserve Claude-facing metadata and point
Claude at `$CHACHI_PATH/agents/skills/<skill-name>/SKILL.md`.

Other tools can point at `agents/skills/` directly.
