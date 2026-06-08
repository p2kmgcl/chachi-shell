# ADR 0020: git watcher — recursive watch to cover subdirectory operations

**Status:** Accepted
**Date:** 2026-06-08
**Supersedes:** ADR 0018 (watcher flags only)

## Context

ADR 0018 switched from per-file watching to a non-recursive directory watch on `.git/`. This fixed inode-swap misses for top-level `.git/` entries but left a coverage gap: operations that write exclusively to `.git/` subdirectories do not fire a non-recursive directory watch.

Affected operations include:

- `git fetch` / `git pull` — writes `refs/remotes/<remote>/...`
- `git commit` — writes `refs/heads/<branch>` (the branch pointer update)
- `git push` — writes `refs/remotes/...` on successful push
- `git tag` — writes `refs/tags/...`
- Any operation that only touches `objects/`, `logs/`, or other subdirectories

In practice, `git commit` does also write `.git/COMMIT_EDITMSG` and rename `.git/index` (top-level), so it fires. But `git fetch` and external tools that advance refs without touching top-level files are silently missed. Users running git commands from an external terminal see stale status until the next top-level `.git/` event.

## Decision

**Pass `{ recursive = true }` to the `fs_event` handle in `watcher.lua`.**

This is a one-character change to the flags argument. libuv on macOS maps this to the FSEvents `kFSEventStreamCreateFlagFileEvents` + subtree watching, which fires on any entry change anywhere under `.git/`, not just direct children.

Updated coverage:

| Operation | ADR 0018 coverage | New coverage |
|---|---|---|
| `git fetch` / `git pull` | Missed (`refs/remotes/` is a subdir) | ✓ |
| `git commit` (ref update) | Partial (top-level writes saved it) | ✓ |
| `git push` | Missed | ✓ |
| `git tag` | Missed | ✓ |
| All ADR 0018 operations | ✓ | ✓ |

The debounce (150ms) absorbs any burst of subdirectory events from a single operation, so the number of `git status` calls is unchanged in practice.

## Alternatives considered

### Fallback polling timer (5s)

Would cap staleness at 5 seconds regardless of cause. Adds 0–5s latency on every operation and runs unconditionally even when the watcher fires correctly. Rejected: the root cause is a missing event, not a timing issue; polling treats the symptom without fixing it.

### Watch specific subdirectories (`refs/heads`, `refs/remotes`)

More surgical, but requires enumerating and re-watching as remotes are added. `recursive = true` is simpler with equivalent coverage.

## Consequences

- `watcher.lua` now fires on any write anywhere under `.git/`. This includes `objects/` writes (pack files, loose objects) during `git fetch` / `git clone` — potentially many events during large fetches. The 150ms debounce collapses these into a single `git status` call, so overhead is one extra status run per fetch, not one per object.
- The external contract of `watcher.lua` is unchanged.
