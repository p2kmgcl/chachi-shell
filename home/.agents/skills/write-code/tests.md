# Behavioral Tests

A durable test exercises observable behavior through a public seam, uses an
independent source of truth for its expected result, and survives an internal
refactor.

```typescript
test("a valid cart can be checked out", async () => {
  const cart = createCartWith(product);

  const result = await checkout(cart, paymentMethod);

  expect(result.status).toBe("confirmed");
});
```

**Coupling.** Avoid tests that mock internal collaborators, call private methods,
assert call order, or verify through a side channel such as a database query
instead of the public interface.

**Tautology.** Avoid assertions whose expected value repeats the implementation's
calculation:

```typescript
expect(add(a, b)).toBe(a + b);
```

**Source.** Use a known-good literal, worked example, specification, or other
independent source instead. A test should be capable of disagreeing with the
implementation for the exact behavior it claims to protect.
