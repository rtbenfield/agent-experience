---
name: project-plan
description: Use when user says "project plan", "plan the spec", "implementation plan", or wants to turn a spec into phased build steps.
metadata:
  author: Tyler Benfield
  version: "2026.5.28"
---

# Project Plan

Create an implementation plan from a project spec. Maps spec requirements onto the existing codebase and sequences work into verifiable, mergeable phases. The plan is a living document — `/project-execute` may revise it as implementation reveals unexpected constraints or opportunities.

## Pre-conditions — halt if unmet

1. **No spec referenced.** Ask the operator which spec to plan from. A spec is any file produced by `/project-spec` (convention: `.agents/projects/{name}.spec.md`) or equivalent content in conversation. If the operator provides only an outcome, suggest running `/project-spec` first.
2. **Unresolved review flags or open questions.** If the spec contains `⚠️ **RF***` markers or open questions (`**Q***`) without recommended answers, halt and inform the operator.
3. **Plan already exists.** If `.agents/projects/{name}.plan.md` already exists, halt and ask the operator whether to revise it or start fresh.

## Output location

If the repository has an established location for specs or plans, use it. Otherwise, write the plan to `.agents/projects/{name}.plan.md` where `{name}` matches the spec identifier (e.g., `dark-mode.spec.md` → `dark-mode.plan.md`). Keep the plan self-contained — if supplementary content is needed, that's a sign the plan should be tightened rather than split.

## Workflow

1. **Read the spec.** Extract requirements (FR*, NFR*), assumptions, and out-of-scope boundaries.

2. **Explore** — for each requirement, build understanding from both internal and external sources.
   - **Codebase**: identify the files, modules, and interfaces each requirement touches. Note which extend existing functionality versus which need new code. Note established patterns and conventions in the affected areas. Reference files, not line numbers — plans must survive refactors.
   - **External**: briefly check whether external sources add value. Skip if the domain is well-understood and codebase exploration already provided sufficient context. Look up authoritative information from external sources — prefer official docs and source repositories. Choose between approaches, validate planned integrations, and catch constraints the spec may have missed.

3. **Identify phase boundaries.** A phase boundary is a point where the system is in a verifiable state: builds pass, tests pass, and the delivered functionality works end-to-end. Deep modules — modules that encapsulate significant behavior behind a simple interface — make natural boundaries. The first phase should deliver a thin working slice that proves the architecture end-to-end when possible.

4. **Draft phases.** Each phase specifies goal, requirements addressed, file changes with intent-level descriptions, and acceptance criteria. Order phases so each builds on the previous. Prefer small, independently mergeable phases.

5. **Present to operator.** Summarize the phases, highlight assumptions and review flags, point to the plan file. Do not dump the full content back into conversation.

## Review flags

Mark decisions that need operator verification with `⚠️ **RF1** (<description>)` inline in the section where the issue arises — a flag on an assumption goes in Assumptions, a flag on a phase change goes in that phase. Number sequentially across the document (**RF1**, **RF2**, etc.). Unresolved RF markers block downstream workflows.

Use when context supports a direction but verification is warranted — "I went with X, confirm this." For genuine ambiguity where multiple valid paths exist, use open questions. Use sparingly; most uncertainties should be resolved via assumptions in the Assumptions section.

## Plan structure

Every plan includes these sections in order:

### Assumptions

Planning-level assumptions beyond the spec. Operator should verify before implementation.

### Open Questions

Decisions needed during implementation. Number as **Q1**, **Q2**, etc. Each includes the question and a recommended answer with rationale as a sub-bullet.

### Phases

#### Phase 1…N

Each phase includes a **Status** (`☐ Not started`, `► In progress`, `✓ Complete`), goal, requirements, changes, and acceptance criteria (see [EXAMPLES.md](assets/EXAMPLES.md)).

### Revision log

Append-only record of material changes made during execution. `/project-execute` adds entries — not `/project-plan`. Each entry is a dated bullet: `YYYY-MM-DD: what changed and why`. Only log changes that alter the plan's intent, scope, or structure — not check-offs, phase completions, or routine progress.

## Rules

- **Intent over mechanism.** Describe what changes and why, not how. "Add dark token overrides to `tokens.css`" — not "add a `[data-theme="dark"]` selector block with 47 properties."
- **Phases survive drift.** File paths are current best guesses, not anchors. Each phase should carry enough intent and context that the plan remains actionable even if files are renamed, moved, or restructured by parallel work.
- **Every requirement accounted for.** Each FR and NFR from the spec must appear in at least one phase. Gaps are planning errors.
- **Phases are independently verifiable.** At every phase boundary the project builds, tests pass, and the system works.
- **Assume over ask.** Document assumptions rather than blocking on ambiguity. Reserve open questions for genuine decision points where multiple valid paths exist.
- **Research before committing to an approach.** Verify with a search when a phase depends on something the agent hasn't worked with recently — not planning on stale assumptions.
- **Remove resolved markers.** When a review flag or open question is resolved, remove the marker entirely and capture the answer in the relevant section (Assumptions, Phases, etc.) — not leave a resolved marker in place.
