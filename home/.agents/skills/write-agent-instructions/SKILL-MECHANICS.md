# Skill mechanics

Apply the general agent-writing standard to Codex skills while keeping their
packaging, discovery, and validation consistent.

**Frontmatter.** Give the directory and `name` the same lowercase hyphenated
action name. Write the `description` as a model-facing context pointer that
states the skill's outcome and each distinct activation branch.

**Opening.** Address the executing agent in the body's opening paragraph and
describe the outcome it should achieve.

**Invocation.** Expose every skill to agent selection and explicit user
invocation through Codex's default implicit-invocation policy.

**Metadata.** Generate `agents/openai.yaml` with a human-facing display name, a
25–64 character short description, and a one-sentence default prompt that names
the skill as `$<skill-name>`. Use the installed skill-creator generator so the
file remains deterministic.

**Validation.** Run the installed skill-creator package validator, confirm the
installed skill path resolves to the canonical directory, and finish when the
package is valid and Codex discovers its final name and description.
