# ADR 0002: content-driven region heights

**Status:** Accepted; per-region cap superseded by [ADR 0011](./0011-shared-budget-for-buffers-and-git-heights.md)
**Date:** 2026-05-26

## Context

ADR 0001 fixed the sidebar's structure (three stacked regions in a single 30-column vertical split) but left heights as **equal at open time, untouched thereafter**. That choice was load-bearing in the original design: it kept `view.lua` free of any code that reacted to content changes, and matched the placeholder-only world where regions never re-rendered.

As regions move from placeholders to real widgets, that model gets awkward. `Buffers` is a short, bounded list (typically 1–15 lines). `Git` is a short, bounded list (status of dirty files). `Explorer` is the file tree — open-ended, the only region that benefits from absorbing slack. Equal thirds means Buffers and Git waste two-thirds of the column on empty rows while Explorer gets a third of what it could use.

The proposal: regions size to content, capped, and Explorer takes the remainder.

## Decision

**Region heights are content-driven, recomputed on every render, owned absolutely by `view.lua`.**

### The algorithm

Let `total` = sum of the current heights of the three a-side windows. Then:

```
cap        = floor(total / 3)
buffers_h  = clamp(line_count(buffers), 2, cap)
git_h      = clamp(line_count(git),     2, cap)
explorer_h = total - buffers_h - git_h
```

- `total` is measured from the three a-side windows only, not the editor height. The sidebar never steals rows from horizontal neighbors. (In a full-vertical-split layout these are the same; using the windows' own combined height is the safer definition and matches what `view.lua` already computes at open time.)
- `line_count(region)` is `vim.api.nvim_buf_line_count(bufnr)`. `nowrap` + `winfixwidth=30` makes line count == row count exactly.
- The floor of `2` is a placeholder minimum: enough for a region to show a header line plus one content row when it has either. We have not yet found a region that needs more; promote to per-region config when one does.
- Explorer has no cap and no explicit floor — it absorbs slack. In pathological cases (`total < 6`) Explorer can be squeezed below 2; Neovim's own minimums take over and we accept whatever it gives us.

### The trigger

Resizing fires when a region rewrites its buffer, not when the editor emits an event. The region contract grows by one call:

```lua
-- after writing lines
require('a-side.view').resize(region.name)
```

`render(bufnr)` keeps its signature. Regions remain pure renderers; they do not measure themselves and do not know about sibling heights.

`open()` invokes `resize` for each region once after `ensure_buffer`, so the initial layout is content-driven from the first frame.

### View owns heights absolutely

Manual `<C-w>+`/`<C-w>-` will be undone on the next `resize` call. The sidebar's heights are a function of content, not user preference. If the user wants more Buffers room, the answer is more buffers, not a manual resize.

This is consistent with `winfixwidth` already pinning column width — width and height are both view-owned.

## Alternatives considered

### Alt 1: Keep equal-at-open-time heights

Cheapest. No new code paths, no new contract. Rejected because it leaves two-thirds of the column on permanently-empty rows once Buffers and Git become real, and the equal split is not a design intent — it was the absence of one.

### Alt 2: Recompute via `TextChanged`/`BufLinesChanged` autocmd

View subscribes to buffer-change events on the three region buffers; regions just write lines and don't notify anyone. Producer code stays simpler.

Rejected because it reintroduces autocmds that react to buffer events — a borderline reading of the ADR 0001 rule (*"no autocmds that react to external editor events; scoped autocmds maintaining a-side's own internal invariants are allowed"*). A producer-driven `view.resize(name)` call achieves the same thing while keeping the rule's spirit intact: the only thing that triggers resize is a-side's own code rewriting its own buffer.

### Alt 3: Regions declare desired height

`render(bufnr) -> desired_rows`. Regions are explicit; view does no measurement.

Rejected because the buffer is already the source of truth for content, and asking the region to report a number it could miscount adds a way to drift. `nvim_buf_line_count` is one call and impossible to disagree with.

### Alt 4: Respect manual resizes until next open

A `WinResized` autocmd detects user-initiated height changes and disables auto-resize for the session.

Rejected because it requires an external-event autocmd (forbidden by ADR 0001's narrowed rule) and creates a second mode ("why isn't it resizing anymore?") that is harder to explain than "heights follow content, always."

### Alt 5: Plumbing plus wire up Buffers as the first real region

Land the resize model and convert Buffers to re-render on `BufAdd`/`BufDelete` in the same change.

Rejected as scope creep. The Buffers widget design (what does it list, how, with what bindings) is a separate question. This ADR ships the sizing model; regions will exercise it as they get real content.

## Consequences

### Positive

- Initial layout reflects content from the first frame; no wasted rows on short regions.
- As regions become dynamic, sizing follows for free — they just call `view.resize(name)` after writing.
- The contract for regions stays nearly minimal: `render(bufnr)` + one line at the end. No measurement, no sibling awareness.

### Negative

- Reverses the ADR 0001 phrasing *"heights are equal at open time"*. Future readers expecting equal thirds will be surprised; this ADR is the trail.
- `view.lua` grows a public function (`resize`) and an algorithm. The atomic-close invariant is no longer the only non-trivial thing it owns.
- Manual `<C-w>+`/`<C-w>-` inside the sidebar is now an anti-pattern. We accept this; the sidebar is not a place for manual window arithmetic.

### Out of scope

- Re-rendering regions on editor events. Each region's "when do I re-render?" is its own design pass.
- Per-region floor/cap configurability. Single floor (`2`), single cap (`floor(total/3)`), hardcoded in `view.lua`. Promote to config when a real second caller appears.
- Animation/smoothing of resize. Heights snap.
