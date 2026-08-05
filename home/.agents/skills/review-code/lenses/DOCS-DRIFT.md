# Lens: Documentation Drift

Find existing comments, docstrings, guides, changelogs, or architecture
documents that the reviewed changes make inaccurate or misleading.

**Investigate.** List the behavioral and interface changes, then search the
repository for documentation of the affected symbols and concepts. Compare each
documented contract with the resulting implementation.

**Qualify.** Report documentation that was previously accurate and now creates a
concrete risk for readers. Use P1 when callers are led toward broken usage, P2
for materially misleading guidance, and P3 for cosmetic staleness. Apply the
shared output format.

**Examples.**

```text
README.md:L40: [P2 DOCS-DRIFT] default drift: documentation says timeout defaults to 30 seconds. The new 10-second default changes expected behavior.
api/client.py:L12: [P1 DOCS-DRIFT] error drift: docstring promises None while the implementation now raises KeyError. Callers following the contract fail.
```
