---
name: project-execute
description: Use when user says "execute the plan", "implement the plan", "run the plan", "implement phase", "start implementation", "build phase", or wants to begin implementation from a plan file.
metadata:
  author: Tyler Benfield
  version: "2026.5.21"
---

# Project Execute

Execute an implementation plan produced by `/project-plan`. Works through phases, verifies each task, commits incrementally, and tracks progress in the plan file. The plan is a living document — this skill revises it when execution reveals unexpected constraints or opportunities.

## Pre-conditions — halt if unmet

1. **No plan referenced.** Ask the operator which plan to execute. A plan is any file produced by `/project-plan` (convention: `.agents/projects/{name}.plan.md`) or equivalent content in conversation. If the operator provides only an outcome, suggest running `/project-spec` then `/project-plan` first.
2. **Review flags unresolved.** If the plan contains `⚠️ **REVIEW**` markers, halt and inform the operator. Execution must not proceed past unresolved review flags — they represent decisions the operator must make before work begins.
3. **Plan file not found.** If the referenced plan file does not exist, halt and ask the operator to confirm the path.

## Determine scope

Acknowledge the operator's prompt — it may specify the entire plan or a particular phase. If the prompt gives no direction, default to the first incomplete phase.

## Execution loop

For each task within the scoped phase(s):

1. **Implement.** Make the changes the plan describes. Plans express intent, not patches — adapt to the codebase as it exists. Reference files by path, not line numbers.
2. **Verify.** Run the project's build, lint, type-check, and test commands. All must pass before committing. If any fail, fix before proceeding. Verification hierarchy: type system > lint > unit tests > integration tests. Fix at the highest level that catches the issue.
3. **Check off.** Mark acceptance criteria as done in the plan file (`[x]`). The plan file is the single source of truth for progress.
4. **Commit.** One self-contained commit per task, including plan file changes. All verifications green. Follow the repository's existing commit conventions — check `git log --oneline -10` for patterns. If no convention is apparent, use: `feat: {domain message}` / `fix: {domain message}` / `refactor: {domain message}`. If a failing state is necessary, explain in the commit message. **Skip committing when execution produces only one commit total** — the operator can review and commit. Commit when working through multiple tasks, as each commit checkpoints progress.

## Plan updates

- **Check off acceptance criteria** as each is verified. Keep the plan file current.
- **Add revision log entries** only when the plan changes: phase added/removed, task scope changed, files renamed, or an execution-time decision made. Format: `YYYY-MM-DD: what changed and why`. Do not add entries for routine check-offs.
- **Mark a phase complete** by checking all its acceptance criteria. Do not remove content from the plan — if something is superseded, strike through rather than delete.
- **Preserve the revision log.** It is an append-only record. Never truncate or rewrite past entries.

## Decisions and surprises

- **Decide and proceed.** If a reasonable assumption can be made from context, make it and note it in the plan's revision log. Do not block on ambiguity.
- **Surface to operator.** Pause and ask if: a decision impacts modules outside the current phase's scope, execution contradicts the plan's stated requirements, or a planned task cannot be completed without expanding scope.
- **Log tangents.** Do not expand scope. Record out-of-scope improvements in the agent logs file (`.agents/logs/{name}.md`) under **Backlog**, not the plan.

## Constraints

- Never embed absolute paths in code, commit messages, or PR descriptions.
- Never persist plan artifact IDs (FR/NFR labels, ticket numbers) into code. Comments and names reference the domain, not the planning tool.
- Test through the public surface, not internals. If a test breaks when the implementation changes, it is reaching past the public API — rewrite it.
