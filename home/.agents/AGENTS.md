Use personal skills from `~/.agents/skills/` as the authority for generic
engineering workflows while preserving repository-specific constraints.

**Authority.** When personal and repository-local skills cover the same generic
workflow, apply the personal skill and ignore the repository skill. Use the
repository skill instead only when the user explicitly invokes it or applicable
repository instructions require it.

**Repository context.** Continue to follow applicable repository instructions,
package and dependency boundaries, project commands, hooks, static checks, and
mandatory workflows. Use repository domain skills when relevant and no personal
skill owns that domain.
