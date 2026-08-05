# Lens: Documentation Gaps

Find changed behavior that needs repository documentation for discoverability
or correct usage.

**Investigate.** Identify new concepts, commands, configuration, flows, and
integration steps in the diff. Search existing documentation to learn its
conventions and locate the natural home for each addition.

**Qualify.** Report a gap when a specific reader needs documentation to discover
or correctly use the changed behavior. Use P2 when the gap blocks correct usage
or discovery and P3 when it improves convenience. Apply the shared output
format.

**Examples.**

```text
cli/deploy.py:L20: [P2 DOCS-MISSING] discoverability: the new deploy --canary command lacks an entry in the command guide. Users cannot discover the feature.
integrations/stripe.py:L45: [P2 DOCS-MISSING] usage: webhook setup requires an undocumented multi-step sequence. Integrators cannot complete setup reliably.
```
