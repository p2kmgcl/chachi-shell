# Refactoring Prompts

Refactor only while the focused tests are green and only when the current slice
provides evidence for the change:

- Duplication: extract the shared behavior.
- Long method: separate cohesive private operations.
- Shallow module: combine pass-through layers or move complexity behind one
  smaller interface.
- Feature envy: move behavior beside the data it primarily uses.
- Data clump or primitive obsession: introduce a domain type when the concept
  already recurs.
- Shotgun change: gather behavior that changes together into one module.
- Speculative generality: remove flexibility the approved behavior does not
  need.

**Verification.** Run the focused tests after each refactor step.
