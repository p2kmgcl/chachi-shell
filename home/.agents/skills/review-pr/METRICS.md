# Recording Metrics

After posting the pending review, record how each lens performed so lens usefulness can be tracked
over time in `metrics.csv`.

Emit **one row per candidate finding** from Phase 2 (step 4), in this format:

```
LENS,PRIORITY,KEPT
```

- `LENS` — the lens that produced the candidate (e.g. `BUG-SECURITY`).
- `PRIORITY` — `P0`, `P1`, `P2`, or `P3`.
- `KEPT` — `1` if the finding landed in the posted review, `0` otherwise.

Rules:

- Include **suppressed P3s** — they count as found, never as kept.
- For a finding merged across lenses, emit **one row per contributing lens** so each is credited.

Pipe every row to the helper, which handles grouping, the P3 rule, and accumulation:

```
printf 'BUG-SECURITY,P0,1\nBUG-SECURITY,P2,0\nSMELL,P3,0\n' | ~/.agents/skills/review-pr/update-metrics.sh
```

Surface warnings but don't treat failures as blocking.
