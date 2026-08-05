# Deep Modules

A deep module hides substantial behavior behind a small interface. A shallow
module exposes nearly as much complexity as it contains.

**Questions.** When designing an interface, ask:

- Can callers learn fewer methods or invariants?
- Can the parameters become simpler?
- Can more complexity stay inside the implementation?
- Does deleting the module remove complexity, or merely spread it across its
  callers?

**Seam.** The public interface is also the preferred test seam. If callers or
tests must reach through it, reconsider the module's shape before exposing
internals.
