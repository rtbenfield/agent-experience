# Project Plan Examples

## Example 1: Dark mode

### Input

`.agents/projects/dark-mode.spec.md` (produced by `/project-spec`)

### Output (`.agents/projects/dark-mode.plan.md`)

```markdown
# Plan: Dark Mode

**Spec**: `.agents/projects/dark-mode.spec.md`
**Date**: 2025-01-15

## Assumptions

- Theme tokens are managed via CSS custom properties (matches existing token system in `src/tokens.css`).
- localStorage is the persistence layer (per spec — no backend changes).
- `prefers-color-scheme` media query is the OS-integration mechanism.
- Three-way toggle (light / dark / system) rather than simple on/off, since the spec requires OS-sync as default with explicit override.

## Open Questions

- Should the flash-of-wrong-theme prevention use an inline `<script>` in `<head>` or a CSS-only `:root` default? **Recommended**: inline script. It's the pattern used by next-themes and avoids the brief flash that a CSS default would cause while JS loads.
- > ⚠️ **REVIEW**: Should we support high-contrast themes in this release or defer to a later cycle? No clear convention exists in the codebase, and scope depends on accessibility requirements the operator needs to define.

## Phases

### Phase 1: Theme data model and persistence hook

**Goal**: Establish the data model and persistence layer. Everything else depends on this.
**Requirements**: FR3 (persistence), FR4 (OS sync)

**Changes**:
- `src/hooks/useTheme.ts` — new module exposing current theme, setTheme, resolved theme. Persists to localStorage, reads `prefers-color-scheme` as default.
- `src/tokens.css` — add dark token overrides under `[data-theme="dark"]` selector.

**Acceptance criteria**:
- [ ] useTheme hook persists preference across page reloads
- [ ] Hook respects OS preference when no explicit preference is set
- [ ] All token overrides compile and produce correct dark palette

### Phase 2: Global application and settings toggle

**Goal**: Wire theme to the DOM and give users a control.
**Requirements**: FR1 (toggle in settings), FR2 (global application)

**Changes**:
- `src/App.tsx` — wrap with ThemeProvider that reads resolved theme and sets `data-theme` on document root.
- `src/pages/Settings.tsx` — add three-way toggle (light / dark / system) following existing form control patterns in `src/components/Switch.tsx`.

**Acceptance criteria**:
- [ ] Toggling in settings immediately changes the entire app's theme
- [ ] Toggle reflects the current theme on load
- [ ] Theme persists across navigation within the app

### Phase 3: Flash prevention and accessibility audit

**Goal**: Eliminate flash of wrong theme and ensure complete dark-mode coverage.
**Requirements**: NFR1 (no flash), NFR2 (WCAG AA), NFR3 (all components covered)

**Changes**:
- `src/hooks/useTheme.ts` — add inline script injection to set `data-theme` before first paint.
- Across component files — audit and replace hardcoded colors with theme tokens.
- `src/tokens.css` — fill token gaps discovered during audit.

**Acceptance criteria**:
- [ ] No visible flash of wrong theme on load (NFR1)
- [ ] All components render correctly in dark mode (NFR3)
- [ ] WCAG AA contrast ratios met across all components (NFR2)

---

## Review flags

- ⚠️ **Hardcoded color audit**: Requires manual pass over all components. Consider adding a stylelint rule (`no-dark-undefined` or similar) as a follow-up to catch regressions.

## Revision log
```