# ADR 0011: shared 80% budget for Buffers and Git heights

**Status:** Accepted
**Date:** 2026-05-27

Supersedes the per-region `cap = floor(total / 3)` rule from [ADR 0002](./0002-content-driven-region-heights.md). The rest of ADR 0002 (content-driven, view-owned, recompute on `view.resize`, manual `<C-w>+/-` is anti-pattern) still stands.

## Context

ADR 0002 made heights content-driven with a per-region cap of `floor(total / 3)` for Buffers and Git, and Explorer absorbing the remainder. In practice:

- One of Buffers or Git is often nearly empty while the other is long. With ~50 open buffers and 2 dirty files, Buffers wants 15+ rows but is capped at `floor(total/3)`, while Git's 3 rows leave a third of the column structurally reserved for an empty widget.
- The cap was a fairness rule between the two short widgets, but it ignored that they almost never grow together. Their content is largely uncorrelated — and when one is short, the cap on the other costs rows for no benefit.
- Explorer is the slack absorber, but it does not need the lion's share at all times. A typical 30-row column with Explorer fully expanded does not benefit from rows 21–30 — they fall off the visible region.

The desire: let whichever of Buffers/Git has content take the rows it needs, up to a shared ceiling, so Explorer is squeezed only when both siblings genuinely have content.

## Decision

**Buffers and Git share a single 80% height budget, allocated by content size. Explorer gets the remainder, with a guaranteed floor of 2 rows.**

### The algorithm

Let `total` = sum of the current heights of the three a-side windows.

```
explorer_floor = 2
budget         = min(floor(0.8 * total), total - explorer_floor)
want_b         = line_count(buffers)
want_g         = line_count(git)

if want_b + want_g <= budget:
    buffers_h, git_h = want_b, want_g
else:
    buffers_h = floor(budget * want_b / (want_b + want_g))
    git_h     = budget - buffers_h

# Enforce per-region floor of 2, stealing from the sibling if needed.
buffers_h, git_h = enforce_floor(buffers_h, git_h, floor = 2)

explorer_h = total - buffers_h - git_h
```

- **Under budget:** each sibling gets exactly the rows its content needs; Explorer absorbs everything else (often >20%).
- **Over budget:** Buffers and Git split the 80% budget in proportion to their content; Explorer drops to 20% of `total`.
- **Floor preservation:** Explorer's floor is enforced first by tightening the budget. The per-region floor of 2 on Buffers/Git is enforced after proportional scaling, by stealing from the larger sibling.
- `0.8` is a constant in `view.lua` (`SHARED_HEIGHT_FRACTION = 0.8`). Promote to config when a real second caller appears.

### Why proportional, not per-region cap

A per-region cap (e.g. each ≤ 60%, joint ≤ 80%) was considered. Proportional split was chosen because the failure mode of caps is the same as the one this ADR is fixing: when one widget is long and the other short, the long one hits its individual cap while budget rows go unused. Proportional split has no such dead zone — every row inside the budget is allocated to a region that wants it.

### Trigger

Unchanged from ADR 0002. Heights recompute on every `view.resize(name)` call, which regions invoke after rewriting their buffer.

## Alternatives considered

### Alt 1: Per-region cap of `floor(0.6 * total)`, joint cap of `floor(0.8 * total)`

Both regions individually capped at 60%; combined capped at 80%. Predictable, symmetric. Rejected because when one sibling is short, the other still cannot grow past its individual cap even though the joint budget has room — exactly the failure mode this ADR exists to fix.

### Alt 2: Independent caps of `floor(0.8 * total)` each, no joint cap

Each region ≤ 80%; in the both-greedy case Explorer is squeezed to its floor. Rejected because it lets a single greedy widget consume 80% even when the sibling also has content; the proportional model is fairer in that case and identical in the one-greedy case.

### Alt 3: Keep ADR 0002's `floor(total / 3)` cap, raise `total` denominator

E.g. `cap = floor(total * 0.4)` to give each region up to 40%. Rejected for the same reason as Alt 1: caps create dead budget when one sibling is short.

### Alt 4: Drop the budget entirely (Buffers and Git uncapped)

Pure `line_count` each, Explorer takes whatever remains. Rejected because a session with 100 open buffers would push Explorer to its floor; the 80% ceiling exists specifically so Explorer always has a usable region.

## Consequences

### Positive

- When one of Buffers/Git is short, the other can grow into the unused budget. The common case (long buffer list, short git status, or vice versa) stops wasting rows.
- Explorer still has a hard floor (2 rows) and a guaranteed 20% in the worst case.
- The algorithm is one branch (under-budget vs over-budget); not significantly more complex than ADR 0002.

### Negative

- Reverses the symmetric per-region cap from ADR 0002. Readers expecting `floor(total/3)` will be surprised; this ADR is the trail.
- Proportional split is less predictable than fixed caps: the same Buffers count can render at different heights depending on Git's current size.
- Explorer can shrink below the 33% it was effectively guaranteed under ADR 0002 (down to 20% of `total` when budget is fully consumed).

### Out of scope

- Configurability of `SHARED_HEIGHT_FRACTION`. Hardcoded at `0.8` in `view.lua`; promote to config when a real second caller appears.
- Per-region weighting. The proportional split is unweighted (`want_b : want_g`); if a future region needs preferential treatment, this is the place to add it.
- Animation/smoothing. Heights still snap.
