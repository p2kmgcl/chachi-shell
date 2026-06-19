# Lens: Performance

Find all significant performance regressions introduced by this PR: a change that meaningfully degrades latency, throughput, or resource usage on a realistic workload. Valid findings affect a hot path with measurable impact, not micro-optimizations or theoretical inefficiencies.

## Examples

`api/feed.py:L31: N+1: loads each author in a loop inside the post serializer. 100 posts = 101 queries. [P2]`

`jobs/export.js:L77: unbounded: reads entire table into memory before writing. OOM once the table grows past ~1M rows. [P1]`

`handlers/request.py:L19: blocking: synchronous HTTP call inside an async handler. Stalls the event loop on every request. [P1]`

## Process

1. Read the diff. Look for: N+1 queries, missing indexes implied by new query patterns, unbounded loops over large datasets, synchronous blocking in async paths, unnecessary recomputation.
2. Explore the codebase: understand data sizes, call frequency, existing caching patterns.
3. For each candidate: confirm it affects a hot path and the impact is measurable, not theoretical.
4. Apply the priority rubric from `PRIORITIES.md`.

## Boundaries

Flag only hot-path regressions with measurable impact on realistic workloads.

If you find nothing that meets the bar, return an empty list. That is the correct answer.
