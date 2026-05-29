# 0016 — Region separators and overflow indicators

## Status
Accepted

## Context

The horizontal split borders between the three stacked regions (Buffers / Explorer / Git) rendered as Neovim's default thin separator — visually weak and indistinguishable from any other split in the editor. There was also no way to tell at a glance whether a region had content above or below the visible area.

## Decision

### Separator styling

Set `fillchars` option `horiz:█` on each sidebar window so the horizontal split border between regions renders as a solid block line. Scoped to the sidebar windows only via `winhighlight = 'WinSeparator:AsideSeparator'` — this prevents the style from bleeding into non-sidebar windows.

`AsideSeparator` is a new highlight group, defined once in `view.lua`, defaulting to `Comment`'s foreground on the normal background. It is the single highlight hook for anything separation-related in the sidebar; callers that want to restyle it link or override this group.

### Overflow indicators

When a region window has content above or below what is currently visible:

- A `↑` glyph is rendered as right-aligned virtual text on the **first visible line** of the buffer when `topline > 1`.
- A `↓` glyph is rendered as right-aligned virtual text on the **last visible line** of the buffer when `botline < line_count`.

Both use `nvim_buf_set_extmark` with `virt_text_pos = 'right_align'` and the `AsideSeparator` highlight group. Extmarks are keyed to a dedicated namespace so they can be cleared and redrawn independently of tree content renders.

Indicators are refreshed by a `WinScrolled` autocmd registered (and unregistered) alongside the existing `WinClosed` autocmd in `view.lua`, scoped to the same three tracked window IDs.

### New module: `ui/scroll_indicators.lua`

Overflow indicator logic lives in `ui/scroll_indicators.lua`, which exports:

```lua
{
  enable  = function(winids) end,  -- registers WinScrolled autocmd; does initial pass
  disable = function() end,        -- clears autocmd and all extmarks
  refresh = function(winid) end,   -- recomputes indicators for one window
}
```

`view.lua` calls `enable` on open and `disable` on close, matching the lifecycle pattern of region `enable`/`disable` hooks. `refresh` is also called directly by `view.lua` after every `resize()` recomputation, since window height changes can alter the visible range without triggering `WinScrolled`.

## Alternatives considered

**Separator: inject a buffer line per region**: add a `─────` line at the top/bottom of each region buffer. Rejected because buffer lines participate in cursor navigation, affect line-count-driven height calculations, and must be stripped before the tree widget processes the buffer.

**Overflow: winbar suffix** (e.g. `Git  (+5)`): always visible, zero buffer impact. Rejected because the count is less legible than a directional arrow, and the winbar is already occupied by the region title managed by the tree handle.

**Overflow: in `view.lua` directly**: ~20 lines, no second caller. Deferred in favour of the submodule because `WinScrolled`-driven extmark management is a distinct enough concern that mixing it into `view.lua`'s window/buffer lifecycle would obscure both.

## Consequences

- `view.lua` defines `AsideSeparator` and sets `fillchars`/`winhighlight` in `apply_window_locals()`.
- `view.lua` requires `ui/scroll_indicators` and calls `enable`/`disable` in `open()`/`close()`, and `refresh(winid)` after `recompute_heights()`.
- `ui/scroll_indicators.lua` is added to the file layout.
- The `WinScrolled` autocmd is the first autocmd in a-side that reacts to viewport changes rather than content or layout changes. It fits the allowed-autocmd rule: it observes a-side's own windows, not incidental editing activity.
