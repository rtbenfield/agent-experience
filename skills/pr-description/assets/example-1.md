> **Diff context**: `useTheme` hook added that persists theme preference to localStorage, syncs with `prefers-color-scheme`, and dark token overrides added to `src/tokens.css`. Phase 1 of the dark-mode plan.

```
Add theme persistence hook and dark token overrides
```

```markdown
Establishes the data model and persistence layer for dark mode, enabling subsequent phases to wire it to the UI.

## Changes

- **Theme hook**: New `useTheme` hook (`src/hooks/useTheme.ts`) reads `prefers-color-scheme` as the default, persists explicit choices to localStorage, and exposes resolved theme for consumers.
- **Token overrides**: Dark palette overrides under `[data-theme="dark"]` in `src/tokens.css`, covering all existing color tokens.

## Why

localStorage was chosen over a backend preference API to avoid a new endpoint and keep the scope limited to per-device persistence. The three-way state model (light / dark / system) supports OS-sync as default while allowing explicit overrides — this matches how next-themes and similar libraries model the problem.
```
