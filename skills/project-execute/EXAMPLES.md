# Project Execute Examples

## Example 1: Execute entire plan

### Prompt from operator

> Run the entire dark-mode plan.

### Flow

1. Read `.agents/projects/dark-mode.plan.md`.
2. No `⚠️ **REVIEW**` markers found — proceed.
3. Phase 1 has unchecked acceptance criteria. Start there.
4. Implement `useTheme` hook, verify tests pass, commit: `feat(theme): add useTheme hook with persistence and OS sync`.
5. Check off first two criteria in plan file.
6. Continue through all phases until every criterion is `[x]`.

### Plan file after Phase 1

```markdown
**Acceptance criteria**:
- [x] useTheme hook persists preference across page reloads
- [x] Hook respects OS preference when no explicit preference is set
- [ ] All token overrides compile and produce correct dark palette
```

### Plan file after all phases complete

All acceptance criteria show `[x]`. Revision log contains entries only for plan changes, not routine check-offs.

---

## Example 2: Execute a specific phase

### Prompt from operator

> Execute Phase 2 of the dark-mode plan.

### Flow

1. Read plan, confirm no review flags.
2. Implement only Phase 2 tasks.
3. After verification and commit, check off Phase 2 criteria.
4. Report completion. Do not proceed to Phase 3 unless asked.

---

## Example 3: Execution encounters a decision

During Phase 3, execution discovers that some components use inline styles unreachable by CSS custom properties. The plan assumed all component styling used CSS tokens.

### Revision log entry added

```markdown
## Revision log

- 2025-01-16: Phase 3 expanded — 4 components use inline `style=` attributes not covered by token overrides. Added task to migrate inline styles to token-based classes.
```

If this expansion impacts modules outside the current phase, surface to operator before proceeding.

---

## Example 4: Review flags block execution

Plan contains:

```markdown
- ⚠️ **REVIEW**: Should we support high-contrast themes in this release or defer?
```

Agent halts:

> The plan has an unresolved review flag: "Should we support high-contrast themes in this release or defer?" Please resolve this before execution can proceed.

---

## Example 5: No plan referenced

> Go ahead and implement it.

Agent responds:

> I need a plan to execute. Run `/project-plan` with your spec first, or tell me which plan file to use (e.g., `.agents/projects/dark-mode.plan.md`).