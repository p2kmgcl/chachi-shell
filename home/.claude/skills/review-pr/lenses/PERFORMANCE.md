# Lens: Performance

Your goal: find **all significant performance regressions** introduced by this PR. You may return zero. Return only findings you are genuinely confident about — do not pad the list, but do not cap it artificially either.

A valid finding is a change that meaningfully degrades latency, throughput, or resource usage on
a realistic workload — not micro-optimizations or theoretical inefficiencies.

## Process

1. Read the diff. Look for: N+1 queries, missing indexes implied by new query patterns, unbounded
   loops over large datasets, synchronous blocking in async paths, unnecessary recomputation.
2. Explore the codebase: understand data sizes, call frequency, existing caching patterns.
3. For each candidate: confirm it affects a hot path and the impact is measurable, not theoretical.
4. Discard anything that matters only at irrelevant scale.

## Output format

Return a list of findings. Each finding must include:
- File path and line number
- What the regression is (one sentence)
- Why it matters on realistic data (one sentence)
- Priority label from `PRIORITIES.md`

If nothing meets the bar, return an empty list.

## Bias

Do not flag inefficiencies in cold paths or speculative future problems.
