# Skill Authoring Rules

- Write for agent consumption, not human fill-in-the-blanks. Instructions and structure beat templates.
- Use "operator" to refer to the human in the loop. Never "user" (ambiguous with product end-users) or "human" (generic).
- Bias toward agency: if a reasonable assumption can be made from context, make it and note it rather than asking the operator. Ask questions only when context is genuinely insufficient and multiple valid paths exist.
- When questions are necessary, include a recommended answer with rationale.
- Keep SKILL.md under 100 lines. Split to REFERENCE.md or EXAMPLES.md when content exceeds that.
- Description must include trigger phrases with "Use when..." syntax, max 1024 chars.
- Cross-reference related skills by name so the agent can chain workflows.
- Prefer structured sections over freeform prose. The agent reasons about section semantics, not just fills them in.