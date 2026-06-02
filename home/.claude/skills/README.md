# Claude Code skills

Claude-facing skill metadata lives here. The actual skill instructions live in
`~/.agents/skills/`, which the dotfiles installer links to the shared
`agents/skills/` directory.

Each `SKILL.md` points to its shared skill with a single
`@~/.agents/skills/<skill-name>/SKILL.md` line.

## Workflow skills

Planning: `/to-prd` → `/to-issues` → `/next-issue` → (work the issue) → `/issue-done` → `/commit` → `/push`

Stress-testing a plan: `/grill-me`

Communication modes: `/caveman` (ultra-compressed), `/slowdown` (one short question at a time)

Development modes: `/tdd` (red-green-refactor)

Debugging: `/diagnose` (reproduce → minimise → hypothesise → instrument → fix)

Navigating unfamiliar code: `/zoom-out` (higher-level map of modules and callers)

Session handoff: `/handoff` (compact the current conversation for a fresh agent)

## Inspiration

Several skills are adapted from Matt Pocock's collection: https://github.com/mattpocock/skills

Specifically: `tdd`, `to-prd`, `to-issues`, `grill-me`, `write-a-skill`, `diagnose`, `zoom-out`, `handoff`.
