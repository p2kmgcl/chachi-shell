# Architecture Language

Use this vocabulary to describe deep module design consistently, making every
candidate and interface comparison precise across codebases and scales.

**Module.** Anything with an interface and an implementation, including a
function, class, package, or tier-spanning slice.

**Interface.** Everything a caller must know to use a module correctly: types,
invariants, ordering, error modes, configuration, and performance
characteristics.

**Implementation.** The behavior hidden inside a module. Describe a concrete
participant at a seam as an adapter when its role matters more than its
contents.

**Depth.** The leverage a module provides through its interface. A deep module
places substantial behavior behind a small interface; a shallow module exposes
an interface nearly as complex as its implementation.

**Seam.** A location where behavior can change through an interface. Seam
placement is a design decision distinct from the behavior placed behind it.

**Adapter.** A concrete implementation that satisfies an interface at a seam.

**Leverage.** The capability callers receive for the interface they must learn.

**Locality.** The concentration of change, bugs, knowledge, and verification in
one place so a correction benefits every caller.

**Principles.** Evaluate designs through these relationships:

- Depth belongs to the interface presented by a module.
- Deleting an earning module redistributes its hidden complexity across callers.
- Callers and tests use the same interface as their surface.
- Multiple useful adapters turn a hypothetical seam into a real seam.
- Depth creates leverage for callers and locality for maintainers.
