# ADR 0021: refresh indicators — per-region render counter

**Status:** Accepted
**Date:** 2026-06-08

## Context

After making the git watcher recursive (ADR 0020) the question arose: does watching the full `.git/` subtree cause excessive renders? Pack-file writes during `git fetch`, loose object writes, and log entries all now generate events. The 150ms debounce collapses bursts, but there was no way to observe the actual render rate in practice without adding log noise.

## Decision

**Add an opt-in `refresh_indicators` decorator that renders a right-aligned render count on line 0 of each region buffer.**

When enabled, each region shows `↑ N` (right-aligned virtual text, `Comment` highlight) where N is the cumulative render count since the indicator was toggled on. The counter updates after every completed render, so it measures actual `git status` / tree rebuilds, not raw watcher events.

The decorator is off by default (`M.enabled = false`). `<leader>a?` toggles it and notifies the current state. Disabling resets no counters — the count accumulates for the session so relative rates between regions remain comparable after toggling.

### Implementation

- `decorators/refresh_indicators.lua`: per-bufnr count table + `tick(bufnr)` / `reset(bufnr)`.
- `keymaps.lua`: `<leader>a?` toggles `refresh_indicators.enabled`.

`tick(bufnr)` appends `  ↑N` to the current `winbar` of the region's window, stripping any existing counter suffix first so the count stays current without accumulating text. It reads and writes `vim.wo[winid].winbar` directly after the tree has set it.

Hook points — all inside `on_render` callbacks, which fire after `apply_winbar` inside the tree's deferred render:
- **git**: `on_render` in the `tree.new(...)` call in `ensure_handle()`; also directly after `write_flat()` for the no-handle error path.
- **buffers**: `on_render` in the `tree.new(...)` call in `M.enable()`.
- **explorer**: `on_render` in the `tree.new(...)` call in `M.enable()`.

Hooks must be in `on_render`, not after `handle:render()`. `handle:render()` only schedules a deferred `vim.schedule(do_render)`; calling `tick()` immediately after it would run before `apply_winbar` resets the winbar, and the suffix would be overwritten.

## Alternatives considered

### `vim.notify` per render

Zero infrastructure, but noisy and unsuitable for rate monitoring (notifications are ephemeral; you cannot see a running count).

### Virtual text on line 0

Would avoid touching the winbar, but `nvim_buf_set_extmark` on row 0 can be overwritten by tree content renders which clear and redraw the buffer namespace on every render. The winbar is a cleaner surface: it is set once per render via `apply_winbar` and not touched again until the next render, so appending inside `on_render` is stable.

### Statusline counter

Not region-scoped — all three regions share the same statusline configuration and cannot show independent counts.

## Consequences

- Each region requires and calls `refresh_indicators.tick()` after render. This is a no-op when disabled, so there is no runtime cost in normal use.
- The decorator is diagnostic tooling; it has no effect on layout, height computation, or any other a-side subsystem.
