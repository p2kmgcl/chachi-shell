---
user-invocable: false
disable-model-invocation: true
---

# domain-context.json — Ticket-Specific Tips

Stores domain knowledge, gotchas, and patterns specific to the current ticket.

## Format

```json
{
    "ticket_context": "High-level summary of what this plan accomplishes",
    "relevant_patterns": ["Follow OrderProcessor in processors/orders.py:45-89 for handler structure"],
    "gotchas": ["CacheManager keeps stale entries for 5min - flush in tests via cache.clear()"],
    "domain_rules": ["All DB queries must use connection pooling per DATABASE.md"],
    "key_utilities": {
        "auth": "middleware/auth.py (verify_token, check_permissions)",
        "database": "db/repository.py (get_order, update_order_status)"
    }
}
```
