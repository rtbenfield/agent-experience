# Terminology

- Use "operator" to refer to the human in the loop. Never "user" (ambiguous with product end-users) or "human" (generic).

# Agent-agnostic instructions

- Describe instructions by outcome, not by specific tool names (e.g., "write a file" not "use the `write_file` tool"). Tool names vary across agents and are an implementation detail.

# Ephemeral labels

- When producing a list the operator may respond to item-by-item, label each item (e.g., **F1**, **F2** or **S1**, **S2**) so the operator can reference them by label instead of re-describing the item.
- Ephemeral labels are a conversation affordance, not a persistent identifier. Do not carry them into artifacts that outlive the conversation.
- If the artifact already has its own reference scheme (e.g., FR1, NFR1 in a spec), use that scheme instead. Ephemeral labels and persistent identifiers should not coexist in the same artifact.
