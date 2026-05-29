# 0014 — Frozen region titles via winbar

## Status
Accepted

## Context

Each region buffer previously had its title/root label as line 1 of the buffer. A `CursorMoved` autocmd in the tree widget bounced the cursor back to row 2 if it landed on row 1, making the title effectively unselectable. However, nothing prevented the title from scrolling off the top of the window — once a region had enough entries to fill its height, scrolling down hid the title entirely.

## Decision

Move region titles out of the buffer and into the Neovim `winbar`. The winbar is a one-line header rendered above the window's content area and pinned there regardless of scroll position.

**Ownership**: the tree handle owns the winbar. `do_render()` and `set_root_label()` both call `vim.wo[find_winid()].winbar = root_label` so the winbar stays current across live updates (e.g. git's dynamic branch line) and across sidebar re-opens (view.lua calls `render()` on open, which triggers `do_render()`).

**Buffer no longer contains line 1**: `render.build()` no longer inserts `root_label` as `lines[1]`. Entries start at row 1 in the buffer. `path_to_row` values shift accordingly. The `CursorMoved` guard that bounced the cursor from row 1 to row 2 is removed — with no title row, row 1 is a valid interactive entry.

**Minimum region height bumped to 4**: `FLOOR` in `view.lua` raised from 2 to 4 for all three regions. The budget formula `total - FLOOR` (which guarantees Explorer's floor) changes accordingly. With each region window also displaying one winbar row, 4 content rows is the minimum that feels usable.

## Alternatives considered

**Keep title in buffer and add winbar as duplicate**: simpler — no data-model changes. Rejected because the title renders twice when scrolled to the top, which is visually confusing.

**`scrolloff` trick**: keep title in buffer, set `scrolloff` high enough to keep line 1 visible. Rejected: `scrolloff` cannot pin a specific line; it only maintains a cursor context margin. It would not reliably keep line 1 on screen when the cursor is in the middle of a long list.

## Consequences

- The `CursorMoved` row-1 guard is gone; `tree.lua` no longer registers that autocmd.
- `render.build()` output changes: `lines[1]` is now the first entry, not the root label. Callers that indexed into `built.lines` or `entries` at row 1 expecting the title are now correctly getting the first interactive entry.
- The winbar inherits Neovim's `WinBar`/`WinBarNC` highlight groups, providing a visual distinction between focused and non-focused region headers at no extra cost.
- Height floor is now 4 for all regions. Under extreme vertical compression the sidebar may not open cleanly, but this was already true at floor 2 and 4 rows is the practical minimum for a usable tree.
