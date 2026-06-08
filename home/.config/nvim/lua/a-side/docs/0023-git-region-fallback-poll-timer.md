# ADR 0023: git region — 10-second fallback poll timer for untracked file visibility

**Status:** Accepted
**Date:** 2026-06-08

## Context

ADR 0022 fixed a fsmonitor feedback loop by filtering `.git/fsmonitor--daemon/cookies/` from the recursive watcher. That fix exposed a latent gap: creating a new untracked file in the working tree writes nothing to `.git/`, so the watcher never fires and the file never appears in the git region.

Before ADR 0022, the feedback loop was accidentally polling every ~250ms, making new files appear almost instantly. After the fix, a new file is invisible until something else touches `.git/` — in practice, until `git add` is run.

Saving a modification to an already-tracked file is not affected: nvim plugins (e.g. gitsigns) run git commands on save that write to `.git/`, which triggers the watcher.

## Decision

**Add a 10-second repeating timer to the git region that calls `run()` unconditionally, as a low-frequency fallback.**

The timer starts after the repo is resolved (inside `enable()`, after the watcher is started) and stops in `disable()`. It is a supplement to the watcher, not a replacement — real git operations still trigger an immediate update via the watcher and debounce. The timer only catches changes the watcher cannot see.

10 seconds is chosen as the interval:
- Short enough that a newly created file appears before the user has time to wonder why it is missing.
- Long enough to have negligible idle cost (one `git status` per 10s vs. one per ~250ms in the old feedback loop — a 40× reduction).
- ADR 0004 rejected a periodic timer as the *primary* update mechanism because it adds idle CPU cost and staleness. As a secondary fallback with a long interval, neither concern applies at meaningful scale.

The existing concurrency guard (`running` / `dirty` flag) absorbs any overlap between a timer-triggered run and a watcher-triggered run — no additional coordination is needed.

## Alternatives considered

### Accept the limitation

New files appear only after `git add`. Reasonable for pure git-status workflows but surprising: a user creates a file, glances at the region, sees nothing, and assumes the region is broken.

### Watch the working-tree toplevel directory

Add a second `fs_event` on the repo root (non-recursive) to catch new top-level entries. Does not cover files created in subdirectories. Recursive working-tree watching is prohibitively expensive for large repos. Rejected.

### Shorter interval (1–2s)

Catches new files faster but runs `git status` 5–10× more often at idle. Not justified by the use case — 10s staleness on new untracked files is acceptable.

## Consequences

- New untracked files appear within 10 seconds of creation, even with no other git activity.
- Idle cost is one additional `git status` per 10 seconds while the sidebar is open.
- `state` grows one field (`poll_timer`); `enable` and `disable` each grow two lines.
