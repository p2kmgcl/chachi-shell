# ADR 0004: git region live updates via fs watcher

**Status:** Accepted
**Date:** 2026-05-26

## Context

The git region was a placeholder rendering the literal string `Git`. We now want real content: the output of `git status --short --branch` (plus ahead/behind from the upstream tracking line), grouped into a compact view that fits the narrow sidebar column.

Two non-negotiable properties drive the design:

1. **It must work in large repos.** `~/dd/web-ui` is the canonical stress case — hundreds of MB of working tree, deep submodules, frequent index churn. A naive synchronous `git status` blocks the UI for hundreds of milliseconds; a naive `--untracked-files=all` scan can take seconds.
2. **It must stay fresh without coupling to editing activity.** ADR 0001 forbade autocmds reacting to user editing (`BufWritePost`, `TextChanged`, …). Refreshing on `<leader>aa` open and `<leader>ag` focus alone leaves the region visibly stale during normal interactive use (save file → status doesn't change; `git add` from a shell → status doesn't change).

The proposal: an asynchronous `git status` driven by a libuv filesystem watcher pointed at the repo's `.git/` directory, owned internally by the git region, with a small contract extension on `view.lua` to manage its lifecycle.

## Decision

**The git region owns an internal producer: a libuv `fs_event` watcher on a fixed set of `.git/` paths, debounced, feeding an async `vim.system` call to `git status`, whose parsed output is rendered into the region buffer.**

### The git command

```
git --no-optional-locks status
    --short
    --branch
    --untracked-files=normal
    --ignore-submodules=dirty
```

- `--short --branch` is the surface format. The leading `## <branch>...<upstream> [ahead N, behind M]` line is rendered verbatim as the first line of the buffer; the `XY path` lines follow in git's native order (staged, then unstaged, then untracked).
- `--untracked-files=normal` is the cheapest mode that still shows untracked paths. `=all` recurses into untracked directories and is the dominant cost in large working trees; `=no` would silently drop the `??` lines users expect from `--short`.
- `--no-optional-locks` skips the optional `index.lock` acquisition. Without it, `git status` can stall behind any other git process holding the lock — common when a long-running fetch or rebase is in flight.
- `--ignore-submodules=dirty` skips the per-submodule working-tree scan. In monorepos with many vendored submodules this is the difference between sub-100ms and multi-second runs.

The command runs via `vim.system(cmd, { text = true, cwd = repo_root }, on_exit)`. The callback is `vim.schedule`-wrapped to land on the main loop before touching the buffer.

### The watcher

A single libuv `fs_event` per repo, watching exactly:

- `<repo>/.git/index`
- `<repo>/.git/HEAD`
- `<repo>/.git/FETCH_HEAD`

`index` covers all staged/working-tree changes that `git status` can observe. `HEAD` covers branch switches. `FETCH_HEAD` covers ahead/behind drift after `git fetch` / `git pull`. `refs/heads/*` is deliberately *not* watched: ref updates to the current branch already touch `HEAD` (via reflog) or arrive through fetch (via `FETCH_HEAD`), and watching the whole `refs/` tree would multiply file descriptors for no marginal signal.

Events are coalesced by a **150ms trailing debounce**. A single git operation typically writes to `.git/index` two or three times (lockfile create, write, rename); without coalescing this would queue three redundant status runs.

### Concurrency

Exactly one `git status` may be in flight at a time. If the debounced trigger fires while a run is in flight, a `dirty` flag is set and the trigger is dropped. On run completion, if `dirty` is set, the flag is cleared and a fresh run is scheduled. This bounds the queue at one pending run regardless of how many events arrive, and never kills an in-flight `git status` (`vim.system`'s `:kill` exists but is unnecessary — `git status` is already cheap once the watcher caused it to start).

### Lifecycle: the region contract grows

The watcher must start when the sidebar opens and stop when it closes — otherwise the fs_event leaks across `close`/`open` cycles, and a closed sidebar would still re-render its hidden buffer on every commit.

The region contract from the README was:

```lua
return { name, filetype, render = function(bufnr) ... end }
```

This ADR extends it with two **optional** methods:

```lua
return {
  name, filetype, render,
  enable  = function(bufnr) ... end,  -- called by view on open
  disable = function() ... end,       -- called by view on close
}
```

`view.lua` calls `region.enable(bufnr)` after the region's window is created in `open()`, and `region.disable()` for each region in `close()`. Regions without these fields (Buffers, Explorer today) are unaffected — `view.lua` only invokes the methods that exist.

The git region's `enable` resolves the repo root via `git rev-parse --show-toplevel`, starts the fs watcher, and kicks off the first status run. Its `disable` closes the watcher, clears the debounce timer, and abandons any in-flight job (the buffer is hidden, so its callback becomes a no-op).

### `:cd` handling

A `DirChanged` autocmd, registered alongside the existing `WinClosed`/`VimResized` ones, re-anchors the git region on directory change: tear down the current watcher, re-resolve the repo root, start a new watcher, re-render. `DirChanged` is a layout/canvas-style event under ADR 0003's wording — the user has deliberately moved the editor's frame of reference — and is allowed.

### Rendering edges

- **Cold open:** the buffer renders a single line `loading…` until the first status run completes.
- **Not a git repo:** `git rev-parse --show-toplevel` exits non-zero; render one line `not a git repo`; do not start a watcher; do not poll.
- **`git status` non-zero exit:** render `git error: <first stderr line>`, truncated to fit the column.
- **Clean working tree:** only the `##` branch header line appears. No empty groups, no synthetic "clean" message — the absence of `XY path` lines *is* the cleanness signal.

### Internal file layout

Per the README's existing guidance — *"Producers may add internal files under their own folder (`regions/buffers/sources.lua`, etc.) without touching siblings"* — the producer lives inside the region:

```
regions/git/
├── git.lua        -- region table; orchestrates the producer; pure surface to view
├── status.lua     -- runs `git status` via vim.system; parses output; resolves repo root
└── watcher.lua    -- fs_event lifecycle; debounce; dirty-flag concurrency
```

`git.lua` is the only file `view.lua` requires. `status.lua` and `watcher.lua` are siblings inside the region's folder, invisible to the rest of the plugin.

### The autocmd rule, unchanged

This ADR deliberately does *not* relax the autocmd rule further. The fs_event watcher is a libuv mechanism owned by a producer, not an autocmd; the rule about *autocmds that react to user editing activity* is untouched. The only autocmds the git region introduces, transitively via `view.lua`, are `DirChanged` (layout/canvas, already permitted by ADR 0003's wording) — none on `BufWritePost`, `TextChanged`, or any editing-activity event.

## Alternatives considered

### Alt 1: Refresh on open/focus only

Run `git status` when `<leader>aa` opens the sidebar and again when `<leader>ag` focuses the region. No watcher, no debounce, no lifecycle.

Rejected because the resulting staleness is the failure mode that motivated this ADR. The user saves a file, glances at the region, sees yesterday's status, and learns not to trust the region. Refreshing on focus moves the trust problem to "did I remember to focus before reading?".

### Alt 2: Refresh on a `BufWritePost` autocmd

The most common signal for "git state may have changed" is "the user just saved a file". A scoped `BufWritePost` autocmd is one line.

Rejected because ADR 0001 names `BufWritePost` explicitly as forbidden, and the rule is doing real work: every other failure mode of a-side has come from coupling to editing activity. Saves are also a strict subset of the events that change `.git/index` — `git add` from a shell, `git commit --amend`, `git rebase`, and `git reset` all change index without ever touching `BufWritePost`. The watcher gets them all; the autocmd gets none.

### Alt 3: Periodic timer (poll every N seconds)

`vim.uv.new_timer()` ticking every 2 seconds, running `git status` if the sidebar is open.

Rejected because it is the worst of both worlds: still stale up to N seconds, still wakes the editor when nothing changed, still runs `git status` against a cold cache. The fs watcher is the same amount of code with better latency and zero idle cost.

### Alt 4: Producer lives in `view.lua` or a new top-level `producers/` directory

Keep `regions/git/git.lua` as a pure `(bufnr) -> lines` formatter; put the watcher and the job in `view.lua` or `a-side/producers/git.lua`.

Rejected because the README already anticipates region-owned producer files, and the producer has no users outside the region. Hoisting it to `view.lua` would force `view.lua` to know git exists; hoisting it to a sibling `producers/` directory would split one feature across two folders for no reuse benefit.

### Alt 5: Watch the whole `.git/` tree recursively

`fs_event` with `recursive = true` on `.git/`.

Rejected because the marginal signal is `objects/` and `logs/` churn, which is not interesting for status rendering and is the dominant volume of writes in a busy repo. Three named files give the same coverage at a fraction of the event rate.

### Alt 6: Render `git status` raw output without parsing

Pipe `git status --short --branch` straight into the buffer, line for line.

Accepted in spirit and rejected only at the margins. The current decision *is* to render git's lines verbatim; the only deviation is the cold-open / error / not-a-repo replacement lines, which are not present in any `git status` output and must be synthesized by the region.

## Consequences

### Positive

- The region feels live: save a file, `git add` from a shell, switch branches in another terminal — the region updates within ~150ms, never blocks the UI, never costs anything when idle.
- Large-repo performance is bounded by `git status` itself, not by anything a-side does. The flag bundle (`-u normal`, `--no-optional-locks`, `--ignore-submodules=dirty`) is the standard set that fast-status tools converge on; future tuning happens by changing those flags in one place.
- The region contract gains a documented lifecycle hook, which the next region with live data (a "diagnostics" or "search results" region) can reuse without re-inventing it.

### Negative

- The region is no longer a pure `(bufnr) -> lines` formatter. It owns a watcher, a timer, a job, and per-repo state. The complexity is contained inside `regions/git/` and invisible to `view.lua`, but a reader scanning the folder sees three files instead of one.
- `view.lua` gains an `enable`/`disable` dispatch and a `DirChanged` autocmd. Both are optional from the other regions' perspective — neither Buffers nor Explorer is forced to grow methods — but `view.lua` now has to know that *some* regions have lifecycles.
- An fs_event leak (e.g. `disable` not called due to a crash) survives until process exit. Mitigated by `disable` being called in `close()` which already runs unconditionally on `WinClosed`.

### Out of scope

- **Per-file diff hunks, blame, log.** This region is `git status`, not a git UI. Hunks belong in a gitsigns-style sign column; blame and log belong in their own windows.
- **Staging/unstaging interactions.** The README's "regions are pure renderers" stance still applies to user input — no keymaps in `git.lua`. If interactive staging is wanted later, it gets its own ADR and its own keymap block in `keymaps.lua`.
- **Multiple worktrees / submodule traversal.** One repo per sidebar, anchored at `vim.fn.getcwd()`'s toplevel. Submodules are scanned by git itself only enough to show their dirty/clean state on the parent's status line.
- **Configurability of flags, debounce, watched paths.** Constants in `status.lua` and `watcher.lua`; promote to a config table only when a real second caller appears.
