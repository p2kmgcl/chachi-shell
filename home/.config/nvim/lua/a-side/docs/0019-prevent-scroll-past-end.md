# 0019 — Prevent scroll past end in sidebar windows

## Status
Accepted

## Context

Neovim's default mouse-wheel scroll behaviour allows the viewport to travel past the last buffer line, leaving blank rows below the content. In regular editor windows this is harmless — the content is long enough that it rarely happens. In the sidebar regions (Buffers, Explorer, Git), whose buffers are typically short, a few wheel ticks routinely push the content off-screen entirely. This made the sidebar feel broken: content would disappear upward and only blank space would remain until the user scrolled back.

## Decision

Add `ui/prevent_scroll_past_end.lua`, a `WinScrolled`-driven module that clamps the viewport of each sidebar window so that the last buffer line is never scrolled above the bottom of the window.

After each `WinScrolled` event for a tracked window, the module computes:

```
max_topline = max(1, line_count - window_height + 1)
```

If `topline > max_topline`, it calls `vim.fn.winrestview({ topline = max_topline })` inside `nvim_win_call` to correct the position. The correction is synchronous (no `vim.schedule` deferral) so there is no visible flicker: `winrestview` inside a `WinScrolled` callback is safe because Neovim does not re-enter the same autocmd for the same window during the same event dispatch.

The module exports the same `enable(winids)` / `disable()` interface as `ui/scroll_indicators.lua`. `view.lua` calls `enable` on open and `disable` on close alongside `scroll_indicators`.

## Alternatives considered

**`<ScrollWheelDown>` buffer-local maps**: intercept wheel input and no-op when already at end. Rejected because it requires the map to be set on every buffer for every region window on each open, is sensitive to mouse-mode configuration, and cannot intercept trackpad momentum scrolling that fires after the map check.

**`scrolloff = 0` window-local**: `scrolloff` controls how many lines of context the cursor keeps around itself, not whether the viewport can travel past the last line. It has no effect on this problem.

**Correct in `scroll_indicators.lua`**: the two concerns (show arrows when content overflows) and (clamp the view so blank space never appears) are independent. Mixing them would make `scroll_indicators.lua` harder to reason about and test independently.

## Consequences

- `ui/prevent_scroll_past_end.lua` is added to the file layout.
- `view.lua` requires `ui/prevent_scroll_past_end` and calls `enable`/`disable` in `open()`/`close()` alongside `scroll_indicators`.
- No region module or tree widget is affected.
- The `WinScrolled` autocmd registered here is the second such autocmd in a-side (after `scroll_indicators`). Both fit the allowed-autocmd rule: they observe a-side's own windows, not incidental editing activity.
