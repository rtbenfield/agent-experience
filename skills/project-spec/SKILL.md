---
name: project-spec
description: Use when the operator provides an outcome-focused prompt, asks for a spec or specification, or says "project-spec" or "/project-spec".
metadata:
  author: Tyler Benfield
  version: "2026.5.31"
---

# Project Spec

Generate a project specification from an outcome-focused prompt. The spec captures **what** the system must do and the qualities it must exhibit — not **how** to build it.

## Output location

If the repository has an established location for specs or plans, use it. Otherwise, write the spec to `.agents/projects/{name}.spec.md` where `{name}` is a brief kebab-case identifier derived from the prompt. This aligns with the `project-plan` skill, which will write to a corresponding `.plan.md` file. Keep the spec self-contained — if supplementary content is needed, that's a sign the spec should be tightened rather than split.

## Workflow

1. **Parse the prompt** — identify the desired outcome, stakeholders, and domain context.
2. **Research** — build understanding from both internal and external sources.
   - **Codebase**: scan for existing patterns, constraints, and conventions that shape the problem space. Check `.agents/projects/` for existing specs that overlap.
   - **External**: briefly check whether external sources add value. Skip if the domain is well-understood and codebase exploration already provided sufficient context. Look up authoritative information from external sources — prefer official docs, RFCs, and established references over informal sources. Validate assumptions, discover non-obvious constraints, and challenge the operator's framing.
3. **Draft the spec** — use the section structure below. Write for a product manager audience: behavioral outcomes, not technical design.
4. **Assume over ask** — when context allows a reasonable assumption, make it and document it. Reserve open questions for genuine ambiguity where multiple valid paths exist. If you must ask, include a recommended answer.
5. **Flag for review** — mark decisions that need operator verification before planning can proceed (see Review flags).
6. **Present next steps** — after writing the spec, briefly tell the operator what to review and how to proceed. Do not dump the entire spec contents back into the conversation.

## Spec section structure

### Problem

- Why this work matters. What pain or opportunity motivates it.
- Success signal — how you know this change solved the problem.
- The case against — why might we choose not to do this?

### Stakeholders

Who is affected and what they need from this change. Distinguish primary actors from secondary beneficiaries.

### Functional requirements

What the system must do. Write each as a behavioral outcome with measurable conditions folded in. No implementation detail. Number as **FR1**, **FR2**, etc.

### Non-functional requirements

Quality attributes the system must exhibit: performance, reliability, security, accessibility, observability. State measurable targets where possible. Number as **NFR1**, **NFR2**, etc.

### Assumptions

Assumptions made during spec generation. These carry into planning — if an assumption is wrong, the operator should flag it before proceeding.

### Downstream effects

Second-order consequences. Who is negatively affected — users, teams, system qualities. Apply the maintenance test: how does this change affect the product and your life as a maintainer in 6–12 months?

### Out of scope

What we are explicitly not doing. Prevents scope creep.

### Open questions

Decisions that need operator input before planning can proceed. Number as **Q1**, **Q2**, etc. Each includes the question and a recommended answer with rationale as a sub-bullet.

## Review flags

Mark decisions that need operator verification with `⚠️ **RF1** (<description>)` inline in the section where the issue arises — a flag on an assumption goes in Assumptions, a flag on FR3 goes in Functional requirements. Number sequentially across the document (**RF1**, **RF2**, etc.). Unresolved RF markers block downstream workflows.

Use when context supports a direction but verification is warranted — "I went with X, confirm this." For genuine ambiguity where multiple valid paths exist, use open questions. Use sparingly; most uncertainties should be resolved via assumptions in the Assumptions section.

## Rules

- **Behavior, not mechanism.** "Users can toggle between light and dark themes" — not "Create a useTheme hook with useSyncExternalStore"
- **Measurable where possible.** "Pages load in under 2s on 3G" — not "Pages should be fast"
- **Technical outcomes are acceptable** for technical domains (e.g., "cache hit rate ≥ 95%"), but implementation is not (e.g., "use Redis with LRU eviction")
- **Use requirement labels for cross-references.** Refer to FR1, NFR3 rather than re-stating the requirement. This keeps discussion concise and unambiguous.
- **Assume over ask.** Document assumptions rather than querying the operator for answers that context can provide. Reserve open questions for genuine ambiguity.
- **Research before assuming.** Verify assumptions with a search before committing them — not guessing from convenience.
- **Challenge the framing.** If research reveals a flawed premise or suboptimal approach, say so and propose the alternative — not validate the prompt as-given.
- **Remove resolved markers.** When a review flag or open question is resolved, remove the marker entirely and capture the answer in the relevant section (Assumptions, Functional requirements, etc.) — not leave a resolved marker in place.
- **Check existing projects** in `.agents/projects/` before drafting to avoid duplication.
