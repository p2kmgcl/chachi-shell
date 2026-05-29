# 0012 — Explorer auto-reveal on buffer switch

## Decision

The Explorer region tracks the active buffer and automatically expands its ancestor directories, moving the cursor to the corresponding file node. The feature is always-on while the sidebar is open.

## Implementation

`handle:reveal(path)` is added to `ui/tree/tree.lua` as a new public method. It:

1. Walks ancestors from `path` up to `root_path` and calls `handle:expand` on each.
2. Sets a `sticky_cursor_path` inside the tree closure.
3. On every subsequent `do_render`, if `sticky_cursor_path` is set and its row is known in `path_to_row`, the cursor is moved there and `sticky_cursor_path` is cleared. If the row is not yet known (async scan still in flight), the sticky path is kept and retried on the next render.

`explorer.lua` adds a `BufEnter` autocmd in `enable(bufnr)` that calls `state.handle:reveal(path)` where `path = vim.api.nvim_buf_get_name(event.buf)`. It guards with `path:sub(1, #state.root + 1) == state.root .. '/'` and skips silently for `[No Name]` and out-of-cwd buffers.

## Why `handle:reveal` lives in `ui/tree`, not in `explorer`

`path_to_row`, `expanded`, and the window cursor-setting are all private to tree's closure. Explorer has no way to place the cursor without tree cooperation. The ancestor-walking loop reuses `path_parent`, also private to tree. Putting both in tree as a single method is the only design that avoids leaking internals.

## Why no auto-collapse

Auto-collapsing previously expanded dirs on each reveal would discard expand state the user built intentionally (comparing two sibling dirs, etc.). VSCode makes this opt-in for the same reason. The watcher cost of keeping dirs expanded is also negligible: one `uv.fs_event` fd per expanded dir, cheap until hundreds of dirs are open simultaneously, which is far outside normal usage.

## Alternatives considered

- **Reveal only on explicit focus (`<leader>ae`)**: rejected — the user wants always-on behaviour matching how file explorers in other editors work.
- **Auto-collapse on reveal**: rejected — destructive to intentional expand state; not justified by cost.
- **Reveal logic in `explorer.lua`**: rejected — impossible without leaking tree internals (cursor placement requires `path_to_row`).
