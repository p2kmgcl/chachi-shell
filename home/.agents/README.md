# Agent Instructions

Product-agnostic agent resources live here so multiple AI CLIs can reference
the same instructions without depending on a vendor-specific dotfiles path.

## Layout

- `skills/`: canonical reusable task instructions.

The dotfiles installer exposes the canonical skills through
`home/.agents/skills`, which is a symlink to `agents/skills/`, then links that
path to `~/.agents/skills`.

Claude-specific installation uses lightweight loader skills in
`home/.claude/skills/`. Those loaders preserve Claude-facing metadata and point
Claude at `~/.agents/skills/<skill-name>/SKILL.md`.

Codex discovers the same `~/.agents/skills` user skill location automatically.

Other tools can point at `agents/skills/` directly.
