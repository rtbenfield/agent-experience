---
name: pr-description
description: Use when the operator requests a PR description, pull request summary, or commit message for a squash merge, says "pr-description" or "/pr-description", or when opening a pull request as part of task execution.
metadata:
  author: Tyler Benfield
  version: "2026.5.21"
---

# PR Description

Generate a PR description from the git diff between the current branch and the default branch. Produces a concise, review-oriented summary — context and reasoning, not a verbatim change list.

## Pre-conditions — halt if unmet

1. **No git repository.** Requires a git repo with a default branch to diff against. Halt if not in a repo.

## Workflow
1. **Identify the target branch.** Assume `main` unless the operator specifies otherwise. If `main` doesn't exist, check `git remote show origin` or `git branch -r` for the default.
2. **Get the diff**: `git diff <default-branch>...HEAD`
3. **Analyze changes.** Determine intent, scope, and key technical decisions. Ignore tangential changes (import reorganization, minor refactors) unless they're the focus of the PR.
4. **Generate description** following the structure below.
5. **Present** the title and body as separate outputs (see Output format). See `assets/EXAMPLES.md` for sample outputs.

## Structure

### Title

- One-line summary of what was added/changed/fixed — the "what", not the "why"
- Omit branch name (redundant in a PR context)
- Examples: "Add theme persistence hook and dark token overrides", "Implement dark mode with persistence and OS sync"

### Overview

1-2 sentences: purpose and motivation. Sets context for why this change exists. Do not repeat the title.

### Changes

Big-picture changes organized by component, service, or area. Each item:

- States **why and how** — not a verbatim change list
- Cites key files, functions, or modules when it aids understanding (repo-relative paths only)
- Includes concrete technical details when they matter (timeouts, limits, formats, protocols)

### Why

Key technical decisions and their reasoning:

- Why this approach over alternatives
- Security, performance, or reliability implications when relevant
- Constraints or requirements that drove decisions

## Output format

Provide two separate outputs:

1. **Title** — plain text wrapped in a markdown block
2. **Body** — GitHub-flavored Markdown in a single markdown code block

```
[One-line summary]
```

```markdown
[Overview paragraph]

## Changes

- **Component/Area**: Big-picture change with why/how context

## Why

[Key technical decisions and reasoning]
```

**Critical:** Do NOT nest markdown blocks. Provide title and body as two distinct outputs. Always use repo-relative paths.

## Rules

- **Context, not repetition.** Aid review — don't restate what's visible in the diff.
- **Big picture focus.** Explain why and how, not every individual change.
- **Repo-relative paths only.** `src/lib.rs`, never `/home/user/project/src/lib.rs`
- **No branch names in the body.** Redundant in PR context.
- **No duplicated title in the body.** Title is a separate output.
- **No incidental improvements.** Omit added logging, import cleanup, minor refactors, and similar housekeeping unless they're the PR's focus.
- **Concise.** Optimize for quick reading by reviewers.
