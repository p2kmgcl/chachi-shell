# ADR 0022: keep a-side closed on startup

**Status:** Accepted

## Context

ADR 0017 made a-side open automatically on every `UIEnter`. That changes the editor layout before the user asks for the sidebar and makes every Neovim session pay the cost of opening its regions and starting their producers.

The existing keymaps already make a-side available on demand: `<leader>aa` toggles the whole sidebar, while `<leader>ab`, `<leader>ae`, and `<leader>ag` open it and focus a specific region.

## Decision

Remove the module-level `UIEnter` autocmd from `view.lua`. Loading a-side must not create sidebar windows; the user opens it explicitly through its keymaps.

This decision supersedes ADR 0017.

## Consequences

- Neovim starts with a-side closed and the initial editor layout unchanged.
- Region buffers, windows, watchers, and other producers are not created until a-side is opened.
- `<leader>aa` continues to toggle the whole sidebar.
- The per-region focus bindings continue to open the sidebar before focusing their region.
- `open()` remains internal; no new public API is needed.
