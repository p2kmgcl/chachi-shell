# ADR 0018: git watcher — directory-level watch replaces per-file watch

**Status:** Superseded by ADR 0020
**Date:** 2026-05-29
**Supersedes:** ADR 0004 (watcher section only)

## Context

ADR 0004 introduced a libuv `fs_event` watcher on three specific files: `.git/index`, `.git/HEAD`, and `.git/FETCH_HEAD`. Two bugs emerged in practice:

1. **Missed updates on staging, unstaging, and commits.** Git writes `.git/index` by creating `.git/index.lock`, writing to it, and doing an atomic `rename()` to replace the original. On macOS, `uv.new_fs_event` watching a specific file path attaches to the file's inode. After a rename, the watch is on the old (now unlinked) inode; the new inode at the same path may not fire. This is the dominant failure mode: `S` to stage/unstage, `git commit` from the console — all missed intermittently.

2. **Spurious events on read.** `uv.new_fs_event` on macOS fired when `.git/index` was read (atime update), not just written. The original code worked around this with an `mtime.sec` comparison guard, which introduced a second bug: two operations within the same second were invisible.

Additionally, `.git/FETCH_HEAD` does not exist in repos that have never fetched. The `stat and last_stat` guard in the trigger silently disabled that watcher entirely in those repos.

## Decision

**Watch the `.git/` directory itself (non-recursive) with a single `fs_event` handle, replacing the three per-file handles.**

Directory-level watching is reliable on macOS because:
- FSEvents fires on any entry change inside the directory (create, rename, delete), regardless of which inode is involved. The inode-swap problem does not apply.
- Reading a file inside the directory does not update the directory's mtime, so read-triggered events do not occur. The mtime guard is unnecessary and removed.

Coverage of the directory watch vs. the previous per-file set:

| Operation | Previous coverage | New coverage |
|---|---|---|
| `git add / restore --staged` | Unreliable (inode swap) | ✓ (`index` rename in `.git/`) |
| `git commit` | `index` unreliable; `refs/` not watched | ✓ (`index` + `COMMIT_EDITMSG` in `.git/`) |
| `git checkout / switch` | `HEAD` unreliable | ✓ (`HEAD` entry change in `.git/`) |
| `git merge / cherry-pick` | Not watched | ✓ (`MERGE_HEAD` / `CHERRY_PICK_HEAD` in `.git/`) |
| `git stash` | `index` unreliable | ✓ (`index` rename in `.git/`) |
| `git fetch` | `FETCH_HEAD` (absent in new repos) | ✓ (`FETCH_HEAD` in `.git/`) |
| `git rebase` | `HEAD` unreliable | ✓ (`HEAD` + `index` in `.git/`) |

The debounce is corrected to **150ms** (matching ADR 0004's stated value; the implementation had drifted to 500ms).

The external contract of `watcher.lua` is unchanged: `start(gitdir, on_trigger) → { stop }`. `git.lua` is not modified.

## Alternatives considered

### Keep per-file watch, fix mtime to include nsec

Would fix the same-second granularity bug but not the inode-swap problem. Spurious events on read would still require the mtime guard. More code, less coverage.

### Keep per-file watch, re-start watcher after each event

Re-stat and re-attach after every rename. Fragile: there is a window between the rename and the re-attach where events are lost. Adds complexity for no benefit over directory watching.

### Add a fallback periodic timer

A timer ticking every few seconds as a safety net. Provides a ceiling on staleness but does not fix the underlying reliability issue; adds idle CPU cost. Rejected as a crutch — directory watching is reliable enough to not need it.

## Consequences

- The watcher is now simpler: one handle, one timer, no per-file stat state, no mtime guard.
- All operations that mutate `.git/` top-level entries trigger a refresh. In practice this means all real git operations.
- Operations that write only to `.git/` subdirectories (e.g. `git fetch` updating `refs/remotes/`, `git commit` updating `refs/heads/`) do **not** fire the non-recursive directory watch. This turned out to be a coverage gap — see ADR 0020.
- The debounce collapses the 2-3 events that a single git operation typically generates into one `git status` run, same as before.
