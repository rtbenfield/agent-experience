---
name: code-review
description: Use when the operator says "code-review" or "/code-review", asks to review code, requests a code review, or asks for feedback on changes.
metadata:
  author: Tyler Benfield
  version: "2026.5.29"
---

# Code Review

Review code changes against a target, producing concise, labeled feedback. You are a peer reviewer — not a gatekeeper, not a rubber stamp. Apply judgment; say LGTM when the code warrants it.

## Pre-conditions — halt if unmet

1. **No changes to review.** Requires either pending uncommitted changes or a branch with commits diverging from a target. If neither exists, halt and inform the operator.

## Target selection

Determine what to review using these rules, evaluated in order:

1. **Pending changes?** If there are uncommitted changes (`git diff`, `git diff --cached`), review those. Stop — no need to compare branches.
2. **Operator specified a target?** If the operator named a branch, tag, or commit, diff against it: `git diff <target>...HEAD`. Use that.
3. **Default branch.** Otherwise, diff against the default branch. Assume `main` unless the repo indicates otherwise. `git diff <default-branch>...HEAD`.

When reviewing pending changes, also check for unstaged files and untracked files that may be relevant.

## Review criteria

Evaluate each changed file against these criteria. Not every criterion applies to every change — apply judgment. A refactoring may not raise correctness concerns; a one-liner may not raise contract concerns. Skip criteria that don't apply rather than forcing commentary.

### Correctness

Is the code behavior correct? Consider:

- Edge cases, off-by-one errors, null/undefined handling
- Race conditions, ordering dependencies
- Error handling completeness and accuracy
- Does the implementation match the apparent intent?

### Clarity

Is the code straightforward and unambiguous? Is it easy to interpret the intent? Consider:

- Naming that reveals purpose, not mechanism
- Control flow a reader can follow without backtracking
- Absence of implicit side effects or surprising behavior
- Doc comments on intent and side effects; absence of misleading or outdated comments

### Complexity

Is there unnecessary cognitive complexity that could be avoided? Consider:

- Nested conditionals that could be flattened by extracting functions
- Logic that could be replaced with composition or early returns
- Abstractions that add indirection without flexibility
- Conditional branches where a single path suffices

### Contract

Is the contract of the code exposing only what is necessary? Could it be misused? Consider:

- Public surface smaller than the implementation — callers shouldn't see internals
- Types that eliminate impossible states and exhaust cases
- Defaults and parameters that guide toward correct usage
- Absence of exposed private wiring repurposed for testability

### Performance

Are there obvious performance issues? Consider:

- N+1 queries, unnecessary allocations, blocking calls in async paths
- Approach appropriate for the expected scale
- Opportunities for caching or batching where the cost is measurable

Do not flag micro-optimizations or speculative performance concerns. Only raise when the issue is concrete and measurable.

### Security

Is the code secure against common vulnerabilities? Consider:

- User input validated and sanitized
- Secrets not logged or hardcoded
- Injection vulnerabilities (SQL, command, etc.)
- Authentication and authorization properly enforced
- Cryptographic operations done correctly

### Idiomatic

Is the code idiomatic for the language and frameworks? Consider:

- Using established language constructs and standard library idioms
- Following framework conventions and established project patterns
- When conflicting patterns exist, matching the file being edited

### Verifiability

Does the code prioritize the verification hierarchy? Prefer verification as close to the point of editing as possible:

1. **Type system** — preferred. Model constraints and impossible states in types.
2. **Lint rules** — catch what types can't express.
3. **Unit tests** — for behavior that can't be expressed statically.
4. **Integration tests** — for verifying composition between modules where contracts intersect.

Consider:

- Are constraints expressed in types where possible, or deferred to runtime?
- Are there behaviors that should have tests but don't?
- Are tests exercising the public surface, not internals?

## Workflow

1. **Determine the target** per the target selection rules above.
2. **Collect the diff.** For pending changes: `git diff` and `git diff --cached`. For branch comparison: `git diff <target>...HEAD`.
3. **Review each changed file** against the criteria. Load AGENTS.md rules per-file as you review (see AGENTS.md loading). Read the full file when context is needed — don't review from the diff alone if the change is ambiguous without surrounding code.
4. **Write the review** to `.agents/reviews/<short-hash>.md` for branch comparisons or `.agents/reviews/pending-<short-hash>.md` for uncommitted changes, where `<short-hash>` is the current HEAD short hash. Create the directory if it doesn't exist. Follow the output format below.
5. **Confirm in chat** with a one-line summary: the review file path, the number of feedback items (or LGTM), and the most significant theme if applicable.

## Output format

See `assets/EXAMPLES.md` for sample outputs.

- **Example 1** (`assets/example-1.md`): Branch review with multiple findings. Context: a new `RateLimiter` class in `src/lib/rate-limiter.ts` that tracks requests per window using a fixed-size array, plus a basic test file.
- **Example 2** (`assets/example-2.md`): Pending changes — LGTM. Context: a small deduplication refactor extracting a `formatISODate` helper in `src/utils/format.ts`, no logic changes.
- **Example 3** (`assets/example-3.md`): Branch review with an existing issue. Context: a new paginated user-list API endpoint in `src/routes/users.ts` that depends on an existing `authenticate` middleware.

```markdown
## Code Review: <target description>

<One-sentence overall assessment.>

### Feedback

#### F1: [Brief title]

**Location**: `path/to/file:line`

[Description — 1-3 sentences]

**Suggestion**: [1-3 sentence suggestion]
```lang
[code snippet if applicable]
```

#### F2: [Brief title]

**Location**: `path/to/file:line`, also `path/to/other/file:line`

[Description — 1-3 sentences]

**Suggestion**: [1-3 sentence suggestion]

#### F3: [Brief title]

**Location**: `path/to/file:line`

[Description — 1-3 sentences]

**Suggestion**: [1-3 sentence suggestion]

### Summary

<If no feedback items: "LGTM — no concerns found.">
<Otherwise: concise summary of the most significant themes, not a re-listing of items.>
```

### Labeling

- Number feedback items sequentially: `F1`, `F2`, `F3`.
- Omit the **Suggestion** block and code snippet when the description alone is sufficient (e.g., a straightforward fix).
- Reference labels in discussion — don't re-describe the finding.

### Repetition

Do not repeat the same feedback across multiple locations. State it once, listing additional files in the **Location** line: `path/to/file:line`, also `path/to/other/file:line`.

## Constraints

- **Areas of improvement only.** Do not list things the code does well. Positive observations add noise without actionable value. If the code is sound, say LGTM and move on.
- **Skip formatting.** Indentation, line breaks, spacing, alignment — these belong to the formatter, not the review.
- **Don't nitpick style that doesn't affect readability.** Prefer the existing approach when it's acceptable. Don't suggest rewrites unless the current approach has a concrete drawback.
- **No obligation to find issues.** If the code is sound, say LGTM and move on. Do not manufacture feedback to appear thorough.
- **No premature stop.** If there are genuine concerns, raise all of them. No limit on feedback items.
- **No repetitive feedback.** Point something out once and note where else it applies. Do not produce one item per file for the same issue.
- **Repo-relative paths only.** `src/lib.rs`, never absolute paths.
- **Review the change, not the codebase.** Focus feedback on issues introduced or worsened by the change. Pre-existing issues may be flagged as **existing issues** only when they are genuine bugs or clearly problematic code — the bar is higher than for change-introduced concerns. Style preferences, suboptimal patterns, and minor improvements in existing code are out of scope.
