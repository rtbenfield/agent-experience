# PR Description Examples

## Example 1: Dark mode (single-component change)

### Diff context

A `useTheme` hook was added that persists theme preference to localStorage, syncs with `prefers-color-scheme`, and dark token overrides were added to `src/tokens.css`. This corresponds to Phase 1 of the dark-mode plan.

### Output

Add theme persistence hook and dark token overrides

```markdown
Establishes the data model and persistence layer for dark mode, enabling subsequent phases to wire it to the UI.

## Changes

- **Theme hook**: New `useTheme` hook (`src/hooks/useTheme.ts`) reads `prefers-color-scheme` as the default, persists explicit choices to localStorage, and exposes resolved theme for consumers.
- **Token overrides**: Dark palette overrides under `[data-theme="dark"]` in `src/tokens.css`, covering all existing color tokens.

## Why

localStorage was chosen over a backend preference API to avoid a new endpoint and keep the scope limited to per-device persistence. The three-way state model (light / dark / system) supports OS-sync as default while allowing explicit overrides — this matches how next-themes and similar libraries model the problem.
```

## Example 2: Dark mode (multi-component change)

### Diff context

A full dark-mode implementation: `useTheme` hook, ThemeProvider wrapper, settings toggle, inline script for flash prevention, and component color audit. Spans phases 1 through 3 of the dark-mode plan.

### Output

Implement dark mode with persistence, OS sync, and flash prevention

```markdown
Adds full dark mode support: a persistence hook, global theme application, a settings toggle, and flash-of-wrong-theme prevention.

## Changes

- **Theme model and persistence**: `useTheme` hook (`src/hooks/useTheme.ts`) manages three-way state (light / dark / system), persists to localStorage, and syncs with `prefers-color-scheme`.
- **Global application**: ThemeProvider in `src/App.tsx` sets `data-theme` on the document root. Inline script in `<head>` sets the attribute before first paint to prevent flash.
- **Settings toggle**: Three-way toggle (light / dark / system) added to `src/pages/Settings.tsx` following existing form control patterns.
- **Token coverage**: Dark palette overrides in `src/tokens.css` and hardened colors across all components after audit — no hardcoded `#fff` or `#000` remain.

## Why

The inline `<script>` approach for flash prevention is borrowed from next-themes: it avoids the brief flash that a CSS-only default causes while JS loads. Three-way toggle (light / dark / system) rather than simple on/off because the spec requires OS-sync as default with explicit override capability. Component audit was necessary because four components used inline `style=` attributes that bypass token overrides — these were migrated to token-based classes.
```