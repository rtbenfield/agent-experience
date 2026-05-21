---
name: project-plan
description: Use when user says "project plan", "plan the spec", "implementation plan", or wants to turn a spec into phased build steps.
metadata:
  author: Tyler Benfield
  version: "2026.5.21"
---

# Project Plan

Create an implementation plan from a project spec. Maps spec requirements onto the existing codebase and sequences work into verifiable, mergeable phases. The plan is a living document — `/project-execute` may revise it as implementation reveals unexpected constraints or opportunities.

## Pre-conditions — halt if unmet

1. **No spec referenced.** Ask the operator which spec to plan from. A spec is any file produced by `/project-spec` (convention: `.agents/projects/{name}.spec.md`) or equivalent content in conversation. If the operator provides only an outcome, suggest running `/project-spec` first.
2. **Unresolved review flags or open questions.** If the spec contains `⚠️ **REVIEW**` markers or open questions without recommended answers, halt and inform the operator. Plans built on unresolved reviews or open questions rest on invalid assumptions.
3. **Plan already exists.** If `.agents/projects/{name}.plan.md` already exists, halt and ask the operator whether to revise it or start fresh.

## Output location

If the repository has an established location for specs or plans, use it. Otherwise, write the plan to `.agents/projects/{name}.plan.md` where `{name}` matches the spec identifier (e.g., `dark-mode.spec.md` → `dark-mode.plan.md`). Keep the plan self-contained — if supplementary content is needed, that's a sign the plan should be tightened rather than split.

## Workflow

1. **Read the spec.** Extract requirements (FR*, NFR*), assumptions, and out-of-scope boundaries.

2. **Explore the codebase.** For each requirement, identify the files, modules, and interfaces it touches. Note which requirements extend existing functionality versus which need new code. Note established patterns and conventions in the affected areas. Reference files, not line numbers — plans must survive refactors.

3. **Identify phase boundaries.** A phase boundary is a point where the system is in a verifiable state: builds pass, tests pass, and the delivered functionality works end-to-end. Deep modules — modules that encapsulate significant behavior behind a simple interface — make natural boundaries. The first phase should deliver a thin working slice that proves the architecture end-to-end when possible.

4. **Draft phases.** Each phase specifies goal, requirements addressed, file changes with intent-level descriptions, and acceptance criteria. Order phases so each builds on the previous. Prefer small, independently mergeable phases.

5. **Present to operator.** Summarize the phases, highlight assumptions and review flags, point to the plan file. Do not dump the full content back into conversation.

## Plan structure

Every plan includes these sections in order:

### Assumptions

Planning-level assumptions beyond the spec. Operator should verify before implementation.

### Open Questions

Decisions needed during implementation. Each includes a recommended answer with rationale.

### Phases

#### Phase 1…N

Goal, requirements, changes, acceptance criteria (see [EXAMPLES.md](assets/EXAMPLES.md)).

### Review flags

`> ⚠️ **REVIEW**: <description>` items where operator review is recommended before proceeding.

### Revision log

Tracks changes made during execution. Each entry is a dated bullet describing what changed and why. `/project-execute` adds an entry when it revises the plan — not when it only checks off acceptance criteria.

## Rules

- **Intent over mechanism.** Describe what changes and why, not how. "Add dark token overrides to `tokens.css`" — not "add a `[data-theme="dark"]` selector block with 47 properties."
- **Phases survive drift.** File paths are current best guesses, not anchors. Each phase should carry enough intent and context that the plan remains actionable even if files are renamed, moved, or restructured by parallel work.
- **Every requirement accounted for.** Each FR and NFR from the spec must appear in at least one phase. Gaps are planning errors.
- **Phases are independently verifiable.** At every phase boundary the project builds, tests pass, and the system works.
- **Assume over ask.** Document assumptions rather than blocking on ambiguity. Reserve open questions for genuine decision points where multiple valid paths exist.
