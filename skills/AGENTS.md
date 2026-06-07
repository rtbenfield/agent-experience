# Skill Authoring Rules

> **Published skills.** All skills here are published/portable — consumers install them independently. Treat each as standalone. Reference by outcome or behavior, not skill name (exception: pre-conditions or next-action recommendations).

## Frontmatter

Every skill directory requires a `SKILL.md` with YAML frontmatter.

**Required fields:**

- `name` — max 64 chars. Lowercase alphanumeric and hyphens. No leading, trailing, or consecutive hyphens. Matches parent directory name exactly.
- `description` — max 1024 chars. **Trigger phrases only**, "Use when…" syntax. Do not describe capability — the body covers that. Description is for activation routing only.

**Optional fields:**

- `license` — short license name or reference to a bundled license file.
- `compatibility` — max 500 chars. Environment requirements (product, packages, network). Omit unless the skill has specific needs.
- `metadata` — string key–value map.
  - `author` — Skill author name. Omit if non-attributed.
  - `version` — Current date in `YYYY.M.D` format.
- `allowed-tools` — too agent-specific; skip.

## Versioning

Set `metadata.version` to the current date when the skill directory changes.

## Description format

Frontmatter `description` contains only "Use when…" trigger phrases — **when** to activate, not what the skill does. This restriction applies only to frontmatter. The body describes capability freely.

**Correct:**

```yaml
description: Use when the operator says "project-spec" or "/project-spec", asks for a specification from an outcome-focused prompt, or requests a spec.
```

**Incorrect:**

```yaml
description: Generates a project specification from outcome-focused prompts. Use when the operator says "project-spec".
```

## Body

The body after frontmatter is the skill's instructions. Use structure and semantics over prose. Optimize for AI agent consumption.

- Use headings, lists, and tables. Agents reason about section semantics.
- Bias toward agency. Assume reasonable defaults from context. Ask only when multiple valid paths exist and context is genuinely insufficient. Include a recommended answer with rationale.
- Minimize cross-references to other skills — do not assume they are installed. Use a skill name only in pre-conditions (routing to a prerequisite) or as a next-action recommendation. Otherwise, reference by outcome or behavior.
- Never reference tool names. Describe the objective or intent. Skills must be agent-agnostic — any harness produces the same outcome from the same instructions.
- Ephemeral content (markers, open questions, pending items) surfaces unresolved state. When resolved, remove it entirely and capture resolution in the relevant section. Do not leave resolved artifacts in place.
- Write as imperatives — "Capture the answer" not "the answer is captured."
- When a skill produces artifacts requiring operator review, define inline marker types with non-overlapping semantics. Number markers sequentially (e.g., RF1, Q2). Each type specifies: what it signals, when to use it, and whether it blocks downstream workflows.

## Progressive disclosure

Structure for layered loading:

1. **Metadata** (~100 tokens) — loaded at startup for routing.
2. **Body** (< 5000 tokens soft limit) — loaded on activation.
3. **Resources** — loaded on demand.

Keep `SKILL.md` under 500 lines. Split detailed reference into separate files.

## Directory structure

```
skill-name/
├── SKILL.md          # Required: frontmatter + instructions
├── scripts/          # Optional: executable code
├── references/       # Optional: on-demand documentation
└── assets/           # Optional: templates, static resources
```

- `name` matches the directory name.
- Reference files with relative paths from the skill root. One level deep. No nested reference chains.
- Scripts must be self-contained or document dependencies. Include helpful error messages. Handle edge cases.

## Paths

Reference files relative to the skill root (`skills/{name}/`). Never reference outside that directory — only that directory is available at install time. No absolute paths.

## Pre-conditions

If a skill requires prior state, define a `Pre-conditions` section that halts activation when unmet. Route the operator to the prerequisite skill by name.

## Validation

Before finishing, validate:

- `name` matches the directory name.
- `description` contains only "Use when…" trigger phrases — no capability summaries.
- `metadata.version` set to current date for new or modified skills.
- Relative paths reference existing files within the skill directory.
- No absolute paths.
- No hardcoded tool names.
- No hardcoded skill names except in pre-conditions or next-action recommendations.

Check manually against the validation list above.

## Exceptions

- **`skill-author`** — repo-local path and cross-reference rules intentionally contradict the published-skill rules; it teaches both conventions for consumers installing elsewhere.
