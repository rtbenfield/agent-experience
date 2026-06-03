> **Diff context**: Full dark-mode implementation — `useTheme` hook, ThemeProvider wrapper, settings toggle, inline script for flash prevention, and component color audit. Spans phases 1–3 of the dark-mode plan.

```
Implement dark mode with persistence, OS sync, and flash prevention
```

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
