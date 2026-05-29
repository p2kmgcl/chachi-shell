# ADR 0003: explorer-driven sidebar width

**Status:** Accepted
**Date:** 2026-05-26
**Superseded in part by:** [0005 — width driven by all regions](./0005-width-driven-by-all-regions.md) (the "Explorer alone" signal and the Alt-2 rejection are reversed; the algorithm shape, `MIN`/`MAX`, `VimResized` trigger, and "view owns width absolutely" rule all carry over)

## Context

ADR 0001 fixed the sidebar at a constant 30-column width. That was a load-bearing simplification while regions were placeholders: width was not a function of anything, so `view.lua` did not have to compute it.

As Explorer moves from a placeholder to a real file tree, 30 columns is too narrow for any non-trivial path. Deep trees, long filenames, icons, and indent guides all push the useful content past the visible column and require either truncation or horizontal scrolling. Buffers and Git remain short by nature; only Explorer wants room to breathe.

The proposal: width is driven by Explorer's content, bounded by a floor and a cap, and shared by all three regions (which already share a column).

## Decision

**The sidebar's width is content-driven from Explorer alone, recomputed on every render and on terminal resize, owned absolutely by `view.lua`.**

### The algorithm

```
MIN   = 30
MAX   = floor(0.4 * vim.o.columns)
need  = max(strdisplaywidth(line) for line in explorer_buffer)
width = clamp(need, MIN, MAX)
```

- The signal is the longest display-width line in the Explorer buffer. `strdisplaywidth`, not `#line` — byte length lies the moment Explorer gains icons or multi-byte characters.
- `MIN = 30` matches the previous fixed width; the sidebar never collapses below what it used to be.
- `MAX = floor(0.4 * columns)` keeps the sidebar from taking more than 40% of the editor's horizontal space, regardless of how long an Explorer line gets.
- Buffers and Git do not contribute to the signal. They share the column with Explorer by Neovim's split semantics; setting the width on any one of the three sets it for the whole stack. View sets it once.

### The triggers

Width recomputes on two events:

1. **Explorer re-renders** — Explorer calls `view.resize('explorer')` after rewriting its buffer, the same hook that drives heights. View recomputes width *and* heights in that call.
2. **Terminal/editor canvas resizes** — a `VimResized` autocmd, registered alongside the `WinClosed` atomic-close autocmd and torn down on close. Necessary because `MAX` is a function of `vim.o.columns`; without it, a shrunk terminal leaves the sidebar above its own cap.

Buffers and Git calling `view.resize(name)` does *not* recompute width — only their own heights. Explorer is the sole width driver.

### View owns width absolutely

Same rule as heights: manual `<C-w><` / `<C-w>>` inside the sidebar is undone on the next recompute. Width is a function of content and canvas, not user preference.

### The autocmd rule, sharpened

ADR 0001 narrowed the original "no autocmds" rule to *"no autocmds that react to external editor events; scoped autocmds maintaining a-side's own internal invariants are allowed."* `VimResized` is an external editor event under that wording, which would forbid trigger (2).

This ADR sharpens the rule one further step: **autocmds that react to user editing activity (TabEnter, BufEnter, WinEnter, TextChanged, …) are forbidden; autocmds that react to layout/canvas changes (VimResized, and similar events about the physical drawing surface) are allowed.** The spirit of the original rule was to keep a-side from coupling to what the user is editing. The terminal getting resized is not editing activity — it is a change to the constraint a-side is laid out against, and ignoring it produces visibly broken layout.

## Alternatives considered

### Alt 1: Keep fixed width

Cheapest. No new code, no new trigger, no autocmd rule change. Rejected because Explorer with real content needs more than 30 columns to be usable, and any fixed wider value is wrong for half the screen sizes a-side runs on.

### Alt 2: Width = longest line across all three buffers

Generalizes the rule: any region can pull the column wider. Rejected because Buffers and Git are bounded-short by design — only Explorer ever wants to grow. Letting any region drive width adds a coupling surface for no behavioral gain, and reopens the question "what if two regions disagree?"

### Alt 3: Regions declare `desired_width(bufnr)`

Mirror of ADR 0002's Alt 3. The region computes its own width and reports a number; view does no measurement.

Rejected for the same reason: the buffer is the source of truth. `strdisplaywidth` is impossible to disagree with for the placeholder, and when Explorer eventually adds icons/virtual text that break that assumption, both axes (height *and* width) gain a `desired_*` field together — not just one.

### Alt 4: Absolute MAX, no `VimResized`

Use a constant cap (e.g. `MAX = 60`). Removes the need for an external-event autocmd entirely.

Rejected because the cap-as-fraction-of-columns is the user-stated intent, and a constant cap is wrong on both very wide and very narrow terminals. The cost of the autocmd is one event subscription; the cost of a wrong-on-most-screens cap is permanent.

### Alt 5: Grow-only, never shrink within a session

Width tracks the worst case Explorer has ever rendered. Stable, no jitter.

Rejected because it leaks session state into layout for a problem we do not have. Explorer re-renders are not so frequent that breathing-width is jarring, and a deep one-off expansion should not permanently widen the sidebar.

## Consequences

### Positive

- Explorer is usable at real path depths without manual resize.
- The width and height rules become symmetric: both are content-driven, both owned by `view.lua`, both recomputed on region render.
- The autocmd rule gets honest: it now says what it was always trying to say (don't couple to editing activity), rather than a broader phrasing that would forbid responding to canvas changes too.

### Negative

- Reverses the ADR 0001 phrasing *"fixed width 30"*. Future readers expecting a constant will be surprised; this ADR is the trail.
- `view.lua` gains a second autocmd (`VimResized`) and a width recomputation alongside `recompute_heights`.
- Width can change mid-task as the user expands a deep folder. Bounded by `MIN`/`MAX` so it cannot become disruptive, but it is no longer invisible the way a constant width was.

### Out of scope

- Per-region width overrides. Width is one number for the whole column.
- Horizontal scrolling vs. truncation when an Explorer line exceeds `MAX`. That is an Explorer-internal rendering choice, not a view-layer one.
- Configurability of `MIN`, `MAX`, or the 40% fraction. Single set of constants in `view.lua`; promote to config when a real second caller appears.
