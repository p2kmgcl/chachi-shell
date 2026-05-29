# ADR 0006: buffers region live updates via buffer-list events

**Status:** Accepted
**Date:** 2026-05-26

## Context

The buffers region was a placeholder rendering the literal string `Buffers`. We now want real content: the list of `:ls`-equivalent buffers — `buflisted == true` AND `buftype == ''` — one per line, with a leading `●`/space gutter indicating modified state, identifier as path relative to `vim.fn.getcwd()`, ordered by buffer number ascending.

Two properties drive the design:

1. **The data source has no fs side-channel.** Unlike the git region (ADR 0004), whose state lives on disk under `.git/` and can be observed by a libuv `fs_event`, the buffer list lives entirely in Neovim's process memory. The only API for observing changes to it is Neovim's autocmd system: `BufAdd`, `BufDelete`, `BufModifiedSet`, etc.
2. **Refreshing on open/focus alone is too stale.** The buffer list changes constantly during normal editing — every `:edit`, every `:bd`, every save flips the modified flag. A region that only refreshes when the sidebar opens or `<leader>ab` is pressed will visibly lie about state the user can see is current in their own editor.

This collides directly with ADR 0001's autocmd rule, which forbids "autocmds that react to user editing activity (TabEnter, BufEnter, TextChanged, …)." `BufAdd`, `BufDelete`, and `BufModifiedSet` are all in that family by surface form. But ADR 0004 already opened the door to the principled question this ADR has to answer: when is an autocmd subscription *not* "reacting to editing activity"?

## Decision

**The buffers region subscribes to `BufAdd`, `BufDelete`, and `BufModifiedSet` to drive its render. Re-renders are coalesced via `vim.schedule` so a burst of events (session restore, `:bufdo`, `:argadd *.lua`) produces one render per tick.**

### The autocmd rule, reframed

ADR 0001 introduced the rule "no autocmds reacting to user editing activity." ADR 0004 narrowed it to "no autocmds reacting to user editing activity; scoped autocmds for internal invariants (`WinClosed`) and layout/canvas changes (`VimResized`, `DirChanged`) are allowed." This ADR adds a third permitted category and states the underlying principle the three categories share.

**The principle:** an autocmd is allowed if it observes a state change *of something the region or view itself owns or treats as its data source*. It is forbidden if it reacts to *incidental* editing activity that happens to correlate with state the region cares about.

Concretely, for the buffers region:

- **`BufAdd` / `BufDelete` / `BufModifiedSet` are allowed.** They are the change-callbacks of the buffer list, which *is* the region's data source. They are the exact analogue of the git region's `fs_event` on `.git/index` — the data source's own change signal, observed at its own boundary.
- **`BufWritePost` would still be forbidden** if a future region wanted to react to "the user saved a file" as a proxy for "something else may have changed." That's reacting to incidental editing activity. The git region correctly does *not* listen to `BufWritePost`; it watches `.git/index`.
- **`TextChanged` in any region is still forbidden.** No region's data source is "the keystroke."

The general form: **autocmds that observe state changes of a region's own data source are allowed. Autocmds that react to incidental editing activity outside that source are forbidden.**

### Filter

Each render rebuilds the list from `vim.api.nvim_list_bufs()`, keeping only buffers where `vim.bo[b].buflisted` is true and `vim.bo[b].buftype` is empty. This naturally excludes a-side's own scratch buffers (`buftype = 'nofile'`, `buflisted = false`), terminals, help windows, and quickfix lists — without any a-side-specific exclusion list.

### Format

One line per buffer:

```
<gutter><path>
```

- `<gutter>` is `'● '` if `vim.bo[b].modified` is true, otherwise `'  '` (two spaces). The fixed-width gutter keeps path columns aligned and avoids line-width churn when the modified flag flips.
- `<path>` is `vim.fn.fnamemodify(name, ':.')` — the buffer's full name made relative to cwd. Buffers outside the tree fall back to absolute paths. No-name buffers render as `[No Name]`.

Ordering is buffer-number ascending — `:ls` order. Stable across renders, predictable for users coming from any standard buffer picker.

### Lifecycle

The region implements the optional `enable`/`disable` hooks established by ADR 0004:

- `enable(bufnr)` creates a private augroup, registers the three autocmds, and triggers an initial render.
- `disable()` deletes the augroup. The scheduled-render flag, if set, is allowed to fire harmlessly — the render checks buffer validity before writing.

Each autocmd callback sets a module-local `scheduled` flag and, if it was not already set, calls `vim.schedule(render)`. `render` clears the flag, recomputes the list, writes lines into the region buffer with the standard `modifiable = true` / write / `modifiable = false` dance, and calls `require('a-side.view').resize('buffers')` so width and heights re-clamp.

### Concurrency

In-process, single-threaded. The `scheduled` flag is touched only from the main loop. No locks, no in-flight tracking — the producer's "work" is a synchronous list-and-format pass that completes in microseconds.

### Internal file layout

```
regions/buffers/
└── buffers.lua    -- region table, lifecycle, list/filter/format, render
```

One file. The producer is small enough that splitting into a `sources.lua` would be cargo-culting structure from ADR 0004's three-file git layout, whose split was justified by genuinely distinct concerns (external process, libuv watcher, debounce). If the buffers region grows real producer complexity (path-collision disambiguation, multiple sort modes, MRU tracking), promote to a `sources.lua` sibling then.

## Alternatives considered

### Alt 1: Refresh on open/focus only

`<leader>aa` open and `<leader>ab` focus trigger renders; no autocmds.

Rejected because the buffer list changes far more frequently than the sidebar is opened or focused, and the resulting staleness is visible at a glance. The user opens a buffer in the main window, looks right at the sidebar, and the new buffer isn't there. The trust failure is immediate.

### Alt 2: Subscribe to `BufEnter` for a current-buffer marker

Q2/Q4 considered showing which buffer is currently focused in the main editor area, via an extmark or highlight. That would require listening to `BufEnter`, the chattiest of the buffer-event family — it fires on every cross-window focus change, including focusing into a-side's own windows.

Rejected at the v1 scope. The data-source-events reframing arguably permits `BufEnter` (the active buffer is part of buffer-list state), but the cost-benefit is bad: the marker is only read when the user looks at the sidebar, so refreshing it at that moment is sufficient. If we want the marker later, the cleanest implementation is to recompute it lazily inside the existing scheduled render, not to subscribe to `BufEnter`.

### Alt 3: libuv timer polling `nvim_list_bufs()`

`vim.uv.new_timer()` ticking every N ms, comparing the list against a snapshot.

Rejected for the same reasons ADR 0004 Alt 3 rejected timer polling for git: still stale up to N seconds, still wakes when nothing changed, still has to justify N. Subscribing to the events that *are* the change signal is the same amount of code with better latency and zero idle cost.

### Alt 4: Trailing debounce mirroring ADR 0004's 150ms

A `vim.uv.new_timer()` with a 50ms or 150ms trailing debounce, as the git region uses.

Rejected because the git region's debounce exists to coalesce fs-event bursts from a *single semantic operation* (lockfile create, write, rename for one index update) and to gate an out-of-process `vim.system` call. The buffers region's work is in-process and microseconds; `vim.schedule` coalescing (one render per tick) is the appropriate primitive. A timer would be cargo-culted structure.

### Alt 5: Interactive list (`<CR>` to jump, `dd` to `:bd`)

Buffer-local keymaps on the region buffer, or filetype-scoped keymaps in `keymaps.lua`.

Out of scope for this change. Interactivity is a real, independent decision that forces a reinterpretation of the README's "regions are pure renderers" stance and probably its own ADR. Bundling it here would muddy which decisions are doing which work. v1 is display-only.

### Alt 6: Producer split into `buffers.lua` + `sources.lua`

Mirror ADR 0004's file layout for consistency.

Rejected because the README's producer-files guidance is permissive, not prescriptive, and the concerns aren't distinct enough here to warrant separate files. Promote to two files when the producer earns it.

## Consequences

### Positive

- The region is honest: it reflects Neovim's buffer list at the moment the user looks at it. No staleness, no "did I remember to focus first?" cognitive overhead.
- The autocmd rule now has a clearly stated underlying principle ("observe your own data source; don't react to incidental editing activity") that future regions can apply directly. The next region with an in-process data source (diagnostics, LSP symbols, location list, …) follows the same shape: identify the data-source change events, subscribe, schedule-coalesce, render.
- Zero idle cost. `BufAdd`/`BufDelete`/`BufModifiedSet` only fire when buffer-set state actually changes; the scheduled render only runs when fired.
- The change is contained to `regions/buffers/buffers.lua` and one paragraph of `README.md`. `view.lua` is untouched — the `enable`/`disable` dispatch from ADR 0004 already handles it.

### Negative

- The autocmd rule grows a third permitted category, and the principle behind it is a real generalisation rather than an enumerated list. A reader has to internalise "is this the region's own data source?" rather than checking against a list of allowed event names. The README and this ADR carry that burden.
- `BufAdd` and `BufDelete` are surface-similar to the explicitly forbidden `BufEnter`/`TextChanged`. A future contributor seeing them in `regions/buffers/buffers.lua` has to read this ADR to understand why one family is allowed and the other isn't. Mitigated by the README paragraph naming the data-source-events category explicitly.
- `BufModifiedSet` fires once per modified-flag transition, which is fine, but a future region that wants finer-grained signals (e.g. cursor position per buffer) would push back on the principle — cursor moves aren't really "data source state changes" for any reasonable region, and the rule should still hold the line.

### Out of scope

- **Interactivity** (`<CR>` to jump, `dd` to `:bd`, etc.). Separate change, separate ADR.
- **Current-buffer marker**. Separate change, lazily computed at render time when added.
- **Path-collision disambiguation** (two `init.lua` files showing as the same line). Promote to `pathshorten`-style parent disambiguation if and when it actually bites.
- **Sort modes** (alphabetical, MRU). Buffer-number ascending only. Configurability arrives when a real second caller does.
- **Filtering toggles** (show terminals, show help). Out of v1; the filter is fixed at `buflisted && buftype == ''`.
