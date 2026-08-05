# Lens: Performance

Find measurable regressions in latency, throughput, or resource use on
realistic workloads introduced by the reviewed changes.

**Investigate.** Examine changed hot paths for query multiplication, missing
indexes implied by new access patterns, unbounded work, blocking in asynchronous
execution, and repeated computation. Establish realistic data sizes and call
frequency from surrounding code.

**Qualify.** Report findings with a reachable hot path and concrete scale or
measurement consequence. Apply the shared priority rubric and output format.

**Examples.**

```text
api/feed.py:L31: [P2 PERFORMANCE] N+1 query: author data loads once per serialized post. A 100-post response performs 101 queries.
jobs/export.js:L77: [P1 PERFORMANCE] unbounded memory: export loads the full table before writing. Large datasets exhaust worker memory.
```
