# ADR 0009: tree widget directory flattening

**Status:** Accepted
**Date:** 2026-05-26

## Context

ADR 0008 extracted the tree widget at `lua/a-side/ui/tree/` and made Explorer and Git consume it as instances. Both regions now render rooted, indented, expandable trees of paths.

The visible cost in real repos is single-child chains. `src/components/ui/Button/Button.tsx` walks four directories that exist purely as containers for one further directory each. Rendered naïvely, that consumes four lines and four indentation steps to deliver one file. Across a typical project the sidebar fills with single-child stair-steps.

VSCode addresses this with "compact folders": a run of dirs where each contains exactly one child, which is itself a dir, is rendered as a single line `a/b/c/`. This ADR records the decision to add the same affordance to the shared tree widget.

The decision is non-trivial because the widget contract is shared by Explorer (lazy, async filesystem scan via `get_children` that may return nil) and Git (synchronous parse of `git status` into a fully-materialised map). The flattening rule has to work for both without changing the data contract.

## Decision

**The tree widget gains directory chain flattening as a default-on, runtime-toggleable visual transformation. Chains are detected during render and chain expansion runs as a pre-render hook so it converges as async data arrives.**

### Scope: both regions, runtime-toggleable, default on

Both Explorer and Git get flattening. Default is on at widget construction. The handle exposes `handle:toggle_flatten()`; no construction-time knob. Regions may bind a keymap to the toggle in `enable(bufnr)` if a user-facing affordance is wanted later — the widget binds nothing itself.

A construction-time `flatten_dirs` option was rejected as gratuitous surface area. Both consumers want the same default; the runtime method covers any future per-region keybinding without locking the API now.

### Interaction model: chain expands and collapses as a unit

When the user tabs the root of a single-child chain, the entire chain materialises in one step — `▾ a/b/c/` with `c`'s children visible below, not `▾ a/` followed by a manual tab into `b`. Symmetrically, tab on the flattened chain row collapses the whole chain back to `▸ a/`.

A model where the chain renders flat but the tail is independently expandable (so `▸ a/b/c/` is a legitimate state) was rejected: it produces no interaction savings (the user still tabs to open the deepest dir) and presents the visual contradiction of a "collapsed" chain — flattened intermediates but a closed tail.

The chain-as-unit semantics requires the chain's segment paths to be carried on the row's entry so the tab handler can clear or set `expanded[]` for all segments at once. Entries for chain rows therefore carry a `chain = { segment_path_1, ..., segment_path_n }` field.

### Architecture: detection in render.lua, materialisation in a tree.lua pre-render hook

The widget has two pieces of new logic:

**`render.lua` (pure) detects chains visually.** During its existing depth-first walk over expanded dirs, when entering an expanded dir whose children are exactly one dir entry, and that child is itself expanded, the walker folds them into a single row. It keeps folding as long as the predicate holds, then emits one entry whose `name` is the segments joined by `/`, `path` is the deepest, `is_dir` is true, `chain` lists every segment path in order, and `annotations` come from the deepest entry. The render of the row uses one chevron, one icon (the deepest dir's), and the joined name.

**`tree.lua` runs a pre-render hook that materialises chains as data arrives.** Before every call to `render.build()`, the handle walks all currently-expanded dirs. For each expanded dir whose loaded children contain exactly one dir entry that is unannotated and not yet expanded, the hook sets `expanded[q] = true` and fires `on_expand(q)`. The walk continues from `q` until the chain ends (children unloaded, multiple children, only-child is a file, or only-child carries annotations). The hook runs every render and is idempotent: when `q`'s async data arrives, the next render extends the chain further.

`handle:expand(p)` is therefore trivial — set `expanded[p]=true`, fire `on_expand(p)`, schedule render — and the pre-render hook does all chain materialisation.

A model where `handle:expand(p)` walks the chain itself at expand time was rejected. It works for Git (whose `get_children` is synchronous and complete) but fails for Explorer: when `get_children(a)` returns nil (scan not yet complete), the chain walk stalls and never resumes, because nothing re-triggers it. The pre-render-hook locus runs whenever the region calls `handle:render()` — which Explorer already does on each `scan_dir` completion — so the chain converges incrementally without any new contract between widget and region.

### Annotations break the chain

A dir with annotations cannot be an intermediate in a flattened chain. The chain predicate is "exactly one child, which is a dir, and that dir has no annotations." If `b` (intermediate) carries annotations, the chain rooted at `a` ends with `a` rendered normally, and a fresh chain may start at `b` below it (so `b` itself is rendered with its annotations, possibly as the head of its own chain).

The alternative — flatten regardless and drop intermediate annotations on the floor — was rejected on contract grounds. Annotations are the widget's mechanism for surfacing region-specific semantic information; silently dropping them would mean the visual rule is "you see all annotations the data carries *except* when flattening hides them," which is a footgun for any future region that annotates intermediate dirs. Today neither Explorer nor Git annotates intermediates (`regions/git/paths.lua` sets `annotations = {}` for every dir built via `ensure_dir_chain`), so the chain-breaking rule produces identical output to drop-on-floor for v1 — but ships a forward-compatible contract.

### `path_to_row` maps every segment to the chain row

`render.lua` populates `path_to_row[seg] = chain_row` for every segment of a chain, not only the deepest. This keeps cursor restoration stable across both directions of chain mutation: when a chain materialises and `path_to_row['a']` would otherwise vanish, the cursor stays on the chain line; when a chain collapses and the cursor was on the chain row keyed by the deepest path, the existing ancestor-walk fallback in `row_for_path_or_ancestor` finds the new collapsed-root row.

### `expanded[]` persists across `toggle_flatten()`

Toggling flattening off does not migrate state. `expanded[]` retains entries for every chain segment that was materialised; with flatten off, the same state simply renders as nested rows. Toggling back on lets the pre-render hook re-detect chains over the existing expand state with no additional work. The toggle is a pure visual flip.

### Per-segment `on_expand` / `on_collapse` fanout

Chain materialisation fires `on_expand(q)` for each segment as the pre-render hook walks into it (shallowest-first). Chain collapse fires `on_collapse(q)` for each segment deepest-first (symmetric mirror).

Per-segment fanout is necessary for Explorer: `on_expand` is what triggers `scan_dir(q)`, and without it the chain cannot extend (the next `get_children(q)` call would always return nil). For Git the fanout is a no-op — its data is pre-built and it does not subscribe to `on_expand` for per-dir work.

### Out of scope for v1

- **Root flattening.** `root_label` is a region-supplied fixed string (ADR 0008); the widget does not synthesise it from the root path. Folding the root's single dir-child into the root label would require a new contract for the root and is not motivated by current consumers.
- **Separator styling.** The `/` separators between segments render as plain text in the same highlight as the segment names. Adding a dimmed-separator highlight introduces a new annotation-vocabulary item without a strong reason; revisitable if it reads poorly in practice.
- **Preserving intermediate-dir annotations on chain lines.** The chain predicate already prevents loss by refusing to swallow annotated dirs; no merge-annotations-onto-chain-line behaviour is needed.

## Consequences

**Positive:**

- Real repos read dramatically tighter in the sidebar. `src/components/ui/Button/Button.tsx` becomes two rows instead of five.
- Flattening lives entirely inside the widget — neither `regions/explorer/scan.lua` nor `regions/git/paths.lua` knows about chains. The visual authority boundary from ADR 0008 holds.
- The pre-render-hook locus unifies sync (Git) and async (Explorer) data flows. No region-specific code paths in the widget.
- The chain-breaks-on-annotation rule keeps annotations as a first-class, never-dropped concept in the widget contract.

**Negative:**

- Entries acquire a new `chain` field that callers (regions and any tests) must handle when introspecting `entries[row]`. Today no caller introspects entries except the widget itself, so the cost is latent.
- The pre-render hook runs every render and walks all expanded dirs to extend chains. For deeply expanded trees this is `O(expanded dirs)` extra work per render; the chain walks themselves are bounded by chain depth. Acceptable for the dataset sizes both regions actually produce.
- `on_expand` fanout means Explorer's `scan_dir` is called for every dir in a single-child chain, not just the one the user tabbed. This is the intended behaviour (otherwise the chain cannot materialise) but means the scan footprint of a single tab is "until the chain branches" rather than "one dir."

## Alternatives considered

- **One-shot chain walk inside `handle:expand(p)`.** Rejected because async data (Explorer's `scan_dir`) is unloaded at the moment of the user's tab; the chain walk would stall after one segment with nothing to resume it.
- **Chain detection delegated to regions.** Have `get_children` return pre-flattened chain entries. Rejected: it forces every region to re-implement the same predicate, violates ADR 0008's "widget owns visuals, regions own data," and makes the toggle (a visual-only concern) impossible to honour without round-tripping through the region.
- **Drop intermediate annotations on the floor.** Simpler predicate, but ships a contract where annotations are silently hidden under flattening — a footgun for any future region that annotates dirs.
- **Construction-time `flatten_dirs` flag instead of runtime method.** Simpler API but rules out a user-facing toggle keybinding without rebuilding the handle. The runtime method is ~10 extra lines and opens that door.
- **Render the chain with the tail independently expandable (`▸ a/b/c/` as a valid state).** Rejected: produces no interaction savings and visually contradicts itself.
