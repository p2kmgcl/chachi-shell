# ADR 0001: a-side becomes a widget container

**Status:** Accepted
**Date:** 2026-05-26

## Context

`a-side` was originally framed as a *passive info HUD*: a permanent right-side panel rendering a placeholder string (`Hello`), with architecture designed for read-only, low-interactivity content. The README's "What this plugin deliberately is not" section explicitly disclaimed:

- Not a file tree.
- Not a buffer list.
- Not an LSP outliner.

The design was anchored on three load-bearing rules:

1. **Toggle-only — never via autocmds.** The sidebar is opened/closed only by the user pressing `<leader>a`.
2. **Focus stays in the original window on open.** "For a passive info panel, stealing focus is hostile UX."
3. **One persistent scratch buffer for the session.** Everything renders into one buffer.

A redesign proposed splitting the panel into three stacked regions named `Buffers`, `Explorer`, and `Git`. Two of those three names are *directly* among the things the original README disclaimed. This ADR records the decision to pivot a-side's identity rather than reinterpret the names.

## Decision

**a-side is now a widget container, not a passive HUD.**

Concretely:

- a-side hosts a fixed, ordered list of regions stacked vertically inside the sidebar column: `Buffers`, `Explorer`, `Git` (top to bottom). Today they render placeholder labels; tomorrow they host real editor-navigation widgets.
- Each region owns its own buffer, filetype, window, and submodule under `regions/<name>/<name>.lua`.
- The sidebar remains a single atomic surface — opening creates all three regions, closing any one closes all three.
- The umbrella binding migrates from `<leader>a` to `<leader>aa`, freeing `<leader>a` as the a-side prefix for per-region focus bindings (`<leader>ab`, `<leader>ae`, `<leader>ag`).

Two of the original load-bearing rules are revised:

### Revised Rule 1: "Never via autocmds" → narrowed

**Old:** No autocmds, ever. Open/close happens only through the user-bound toggle.

**New:** No autocmds that **react to external editor events** (`TabEnter`, `BufEnter`, `WinEnter`, etc.). Scoped autocmds that **maintain a-side's own internal invariants** are allowed.

This is necessary because the three-window model demands atomic close: if the user `:q`s one of the three regions, the sidebar's "single thing" mental model breaks unless we close the other two. A `WinClosed` autocmd scoped to the three tracked window IDs is the simplest mechanism, and it does not react to anything outside a-side's own state.

### Revised Rule 2: "Focus stays in original window on open" → narrowed

**Old:** Opening the sidebar never steals focus, because content is passive.

**New:** The umbrella toggle (`<leader>aa`) still never steals focus — opening the sidebar must not interrupt typing. But because regions are now interactive widgets, per-region focus bindings (`<leader>ab`/`<leader>ae`/`<leader>ag`) exist as explicit, opt-in jumps into a specific region.

### Unrevised

- Vertical split, not floating window — unchanged.
- Hide buffer on close, don't wipe — unchanged (now per region).
- Per-tab, not global — unchanged.
- Fixed width 30 — unchanged. (Considered bumping to 40 for file paths; deferred until real content lands and the cramping bites.)
- Filetype is the extension hook — unchanged, now one filetype per region (`aside-buffers`, `aside-explorer`, `aside-git`).
- Multiple keymaps belong in `keymaps.lua` — unchanged. Region modules stay pure renderers.

## Alternatives considered

### Alt 1: Sharpen names; keep a-side a passive HUD

Interpret "buffers/explorer/git" as narrow, read-only summaries rather than the things the README disclaimed (e.g. "current file's git status" rather than "git widget"). Keep all three rules intact.

**Rejected** because the intent expressed in the design session was widget container, not narrower-HUD. Forcing the new content into a HUD shape would have required contorting either the names or the rules.

### Alt 2: Three regions, but in one buffer with separator lines

Preserve the "one persistent scratch buffer" rule; render the three regions as text sections within a single buffer divided by `── Region ──` headers.

**Rejected** because the whole point of separating into three regions was independent evolution — different producers, different filetypes, different lock/unlock cycles. One buffer would create the visual split without the structural seam, forcing a future re-architecture as soon as one region became dynamic.

### Alt 3: Three regions; close one ≠ close all

Allow partial sidebar state: closing one region leaves the other two open. `toggle()` would handle "open if any closed, close all if all open" or similar.

**Rejected** because it complicates the user's mental model ("is the sidebar open?") and the close logic ("which combinations of valid windows count as open?"). Atomic close keeps "the sidebar" as a single concept the user can reason about.

### Alt 4: Atomic close via `toggle()`-only (no autocmd)

Honor the strict "never via autocmds" rule. The user can leave the sidebar in a partial state by `:q`-ing one region; the next `<leader>aa` self-heals by closing the rest.

**Rejected** because partial state is jarring in normal use — the sidebar looking half-broken until the next toggle is worse than the cost of one tightly-scoped autocmd. The narrowed rule (autocmds for internal invariants only) preserves the spirit of the original rule (no global event-reactive open/close) without the brittleness.

## Consequences

### Positive

- a-side has a coherent identity going forward: a container for editor-navigation widgets. The README no longer lies about what the plugin is.
- Each region can evolve independently — its own producer, filetype, syntax, internal files.
- The `<leader>a` namespace is now a discoverable prefix, room for ~25 future bindings.
- The narrowed "no autocmds" rule is more honest about what was actually being protected against (external-event-driven open/close).

### Negative

- Adding a region now requires touching three files (`regions/<name>/<name>.lua`, `view.lua`, `keymaps.lua`). The orchestration cost is intentional — `view.lua` remains the single locus of window/buffer lifecycle invariants.
- The "Not a buffer list / Not a file tree" disclaimers are gone. Future contributors lose the strong "this plugin doesn't do that" signal. The README's new "What this plugin deliberately is not" section is shorter and weaker.
- A future contributor reading only `view.lua` will see a `WinClosed` autocmd and may assume the "never via autocmds" rule is dead. The README and this ADR exist to clarify the narrowed rule.

### Out of scope

- Real content for any region. This ADR lands the structural pivot only; each region's actual widget (real buffer list, real file tree, real git view) gets its own design pass.
- Configurability. Still deferred until a real second caller appears.
- Width tuning. Still 30; revisit when content lands.
