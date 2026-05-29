# 0017 — Auto-open on UIEnter

## Status
Accepted

## Context

a-side was always toggled manually via `<leader>aa`. This meant the sidebar started hidden and had to be explicitly opened on every session, including after session restore. With a-side now hosting all three navigation widgets (Buffers, Explorer, Git) and replacing neo-tree entirely, the sidebar is expected to be open for the full editing session — manual toggle-on is just friction.

## Decision

a-side opens automatically on every Neovim start by registering a one-shot `UIEnter` autocmd at module load time in `view.lua`.

**Trigger**: `UIEnter`, not `VimEnter`. `UIEnter` fires after the UI is attached and the initial screen is rendered, making it safe for window manipulation. `VimEnter` fires before the UI is ready and can produce layout glitches when creating splits.

**Unconditional**: opens on every invocation — with arguments, without arguments, in any directory, with or without session restore. The three regions (Buffers, Explorer, Git) all provide value outside a git repo; conditional logic (e.g. "only in a git repo") would add complexity for marginal benefit.

**Focus**: `open()` already saves and restores `prev_win` before returning, so the cursor stays in the editor window after auto-open. The "focus on open: stays in editor" principle (ADR 0001 / README §Design decisions) is not violated.

**Location**: the `UIEnter` autocmd lives in `view.lua` as a module-level side effect, alongside `VimResized` and `DirChanged`. This fits the allowed-autocmd rule: it is a startup lifecycle event that drives a-side's own window lifecycle, not a reaction to incidental user editing activity.

## Alternatives considered

**`VimEnter`**: fires too early — window creation before the UI is ready causes layout glitches with splits.

**Conditional on git repo**: Git region degrades gracefully when there is no repo (empty tree, no watcher activity). Restricting auto-open to git dirs would suppress the Buffers and Explorer regions unnecessarily.

**Conditional on no session restore**: session restore fires `DirChanged`, which already re-anchors a-side's regions. Suppressing auto-open on restore would require detecting session state, adding fragile logic with no clear benefit.

**`init.lua` call-site**: calling `require('a-side.view').toggle()` from `init.lua` would expose the auto-open behaviour at the top-level config rather than inside the module that owns the window lifecycle. `view.lua` already self-registers its other autocmds; UIEnter fits the same pattern.

## Consequences

- `view.lua` registers a `{ once = true }` `UIEnter` autocmd at module load time that calls the internal `open()`.
- `<leader>aa` continues to toggle the sidebar; the auto-open does not remove the ability to close it.
- No `open` / `close` / `setup` surface is added to the public API — `open()` remains internal. Only `toggle()`, `focus()`, `resize()`, and `ensure_editor_win()` are public.
