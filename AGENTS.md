# Terminology

- Use "operator" to refer to the human in the loop. Never "user" (ambiguous with product end-users) or "human" (generic).

# Agent-agnostic instructions

- Describe instructions by outcome, not by specific tool names (e.g., "write a file" not "use the `write_file` tool"). Tool names vary across agents and are an implementation detail.

# Ephemeral labels

- Label list items or headings (e.g., **F1**, **F2**) when the operator may need to reference them — avoids re-describing.
- Ephemeral labels are for conversation only — don't carry them into artifacts, and defer to existing reference schemes (e.g., FR1, NFR1) when present.
