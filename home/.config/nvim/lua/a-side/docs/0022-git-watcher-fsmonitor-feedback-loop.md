# ADR 0022: git watcher — filter noisy .git/ paths to prevent fsmonitor feedback loop

**Status:** Accepted
**Date:** 2026-06-08
**Amends:** ADR 0020 (watcher implementation only)

## Context

ADR 0020 switched the git watcher to `recursive = true`, covering subdirectory operations that a non-recursive directory watch missed (`git fetch`, `git push`, ref updates). Its Consequences section noted that `objects/` writes during large fetches would now fire the watcher, and claimed the 150ms debounce would collapse them into a single `git status` call.

That claim was wrong for a different class of write: **the built-in git fsmonitor daemon**.

Git 2.33+ ships a built-in fsmonitor daemon (`core.fsmonitor = true` or `feature.manyFiles = true`). When active, the daemon synchronises with clients using cookie files written to `.git/fsmonitor--daemon/cookies/<pid>-<seq>`. Every `git status` call creates one of these cookies as part of the IPC handshake. With recursive watching enabled:

1. Watcher fires → 150ms debounce → `git status` runs.
2. `git status` writes a cookie to `.git/fsmonitor--daemon/cookies/`.
3. The recursive watcher sees the cookie write → 150ms debounce → `git status` runs again.
4. Loop.

The debounce does not help here because the write arrives *after* the status run completes, not during it — there is never a quiet period to coalesce. The result is one `git status` per ~250ms (run time + debounce), visible as a steadily climbing refresh counter in the winbar. The rate is faster in small repos because `git status` finishes faster, shortening the cycle.

The same feedback pattern would apply to any process that writes under `.git/` in response to `git status` (e.g. a git hook, a background maintenance task writing to `logs/` or `objects/`).

## Decision

**Filter watcher events by path in `watcher.lua` before arming the debounce timer. Ignore writes under path prefixes that can never affect `git status` output.**

The ignored prefixes:

| Prefix | Reason |
|---|---|
| `fsmonitor--daemon/` | Cookie files written on every `git status` IPC call — the direct loop culprit |
| `objects/` | Pack files and loose objects; written during fetch/clone; not status-relevant |
| `logs/` | Reflog entries; written on ref updates; not status-relevant |

All other paths pass through unchanged. This preserves full ADR 0020 coverage (index, HEAD, FETCH_HEAD, refs/ subdirectories, MERGE_HEAD, etc.) while eliminating the feedback sources.

The fix is implemented as `is_relevant(filename)` in `watcher.lua`. The libuv `fs_event` callback on macOS receives `filename` as a path relative to the watched directory, so prefix matching on the raw string is sufficient.

## Consequences

- The feedback loop is broken. The refresh counter is stable when no real git operation is in progress.
- Repos with `core.fsmonitor` or `feature.manyFiles` enabled behave identically to repos without it.
- `objects/` and `logs/` writes remain ignored, consistent with ADR 0004's original reasoning (they were explicitly cited as the reason *not* to use recursive watching in the first place).
- Any future write source under `.git/` that is not status-relevant must be added to `IGNORE_PREFIXES` in `watcher.lua` if it causes a new feedback loop.
