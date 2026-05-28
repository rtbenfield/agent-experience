# Skill Authoring Rules

## Frontmatter

Every skill directory must contain a `SKILL.md` with YAML frontmatter.

**Required fields:**

- `name` — max 64 chars. Lowercase alphanumeric and hyphens only. No leading, trailing, or consecutive hyphens. Must match the parent directory name exactly.
- `description` — max 1024 chars. **Trigger phrases only**, using "Use when…" syntax. Do not describe what the skill does; the body covers that. The description is purely for activation routing.

**Optional fields:**

- `license` — short license name, or reference to a bundled license file.
- `compatibility` — max 500 chars. Environment requirements the agent must know before activation (intended product, system packages, network access, etc.). Omit unless the skill has specific requirements.
- `metadata` — string key–value map.
  - `author` — The author of the skill. Use `Tyler Benfield`.
  - `version` — The version of the skill. Use the current date in `YYYY.M.D` format.
- `allowed-tools` — space-separated string of pre-approved tools. Too agent-specific; skip.

## Description format

The frontmatter `description` field must contain only "Use when…" trigger phrases describing **when** to activate the skill. No capability summaries. This rule applies to the YAML frontmatter field only — the body will naturally contain capability descriptions as instructions, which is expected and correct.

**Correct:**

```yaml
description: Use when the operator says "project-spec" or "/project-spec", asks for a specification from an outcome-focused prompt, or requests a spec.
```

**Incorrect:**

```yaml
description: Generates a project specification from outcome-focused prompts. Use when the operator says "project-spec".
```

## Body

The Markdown body after the frontmatter is the skill's instructions. Write for agent consumption: structure and semantics over prose.

- Organize with headings, lists, and tables. Agents reason about section semantics, not just fill in text.
- Bias toward agency: make reasonable assumptions from context and document them. Ask only when multiple valid paths exist and context is genuinely insufficient. When asking, include a recommended answer with rationale.
- Cross-reference related skills by `name` so agents can chain workflows.
- Ephemeral content — markers, open questions, pending items — exists to surface unresolved state. When resolved, remove it entirely and capture the resolution in the relevant section. Do not leave resolved artifacts in place.
- Write instructions as imperatives — "Capture the answer" not "the answer is captured."
- When a skill produces artifacts requiring operator review, define inline marker types with non-overlapping semantics. Number markers sequentially (e.g., RF1, Q2) for cross-reference. Each type specifies: what it signals, when to use it, and whether it blocks downstream workflows.

## Progressive disclosure

Structure skills for layered loading:

1. **Metadata** (~100 tokens) — loaded at startup for skill routing.
2. **Body** (< 5000 tokens recommended) — loaded on activation.
3. **Resources** — loaded on demand.

Keep `SKILL.md` under 500 lines. Split detailed reference material into separate files.

## Directory structure

```
skill-name/
├── SKILL.md          # Required: frontmatter + instructions
├── scripts/          # Optional: executable code
├── references/       # Optional: on-demand documentation
└── assets/           # Optional: templates, static resources
```

- `name` must match the directory name.
- Reference files with relative paths from the skill root, one level deep. No deeply nested reference chains.
- Scripts must be self-contained or document their dependencies. Include helpful error messages and handle edge cases.

## Pre-conditions

If a skill requires prior state (e.g., a spec must exist before planning), define a `Pre-conditions` section that halts activation when unmet. Route the operator to the prerequisite skill by `name`.

## Validation

Validate skills with `skills-ref validate ./my-skill` before publishing. This checks frontmatter format and naming conventions. If skills-ref is not installed, check manually instead.
