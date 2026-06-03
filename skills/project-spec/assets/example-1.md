# Dark Mode

## Problem

Users cannot adapt the UI to their lighting conditions or personal preference. Light-only themes cause eye strain in low-light environments and are inconsistent with OS-level theme preferences.

## Stakeholders

- **End users** — want visual comfort and personalization
- **Design team** — need consistent theming across all components

## Functional requirements

- **FR1**: Users can toggle between light and dark themes from the settings page; the change takes effect immediately without a page reload and the toggle reflects the active theme
- **FR2**: The selected theme applies globally — given the user selects dark mode, all pages render with dark colors until changed
- **FR3**: Theme preference persists across browser sessions — given the user closes and reopens the browser, their preference is restored
- **FR4**: Theme preference syncs with OS-level preference when the user hasn't explicitly chosen a theme — given no user preference, the app matches the OS theme

## Non-functional requirements

- **NFR1**: Theme changes render in under 100ms, measured as time from toggle click to last painted frame via browser DevTools Performance panel
- **NFR2**: Dark mode meets WCAG 2.1 AA contrast ratios (≥ 4.5:1 for normal text, ≥ 3:1 for large text) across all components, verified by automated accessibility audit (e.g., axe-core)
- **NFR3**: All color usages reference theme tokens — no hardcoded color values remain, verified by grep for literal hex/hsl/rgb values in component files

## Assumptions

- Theme preference is stored per-device (localStorage), not per-account. This avoids backend changes and aligns with how most web apps handle theme persistence initially.
- OS-level preference is honored as the default, with explicit user choice overriding it.
- Only light and dark themes are in scope. Additional themes (high contrast, custom colors) would follow the same pattern later.

## Out of scope

- Additional themes beyond light and dark
- Per-component theme overrides
- Theme scheduling (e.g., auto-dark at sunset)

## Open questions

None — remaining ambiguities are covered by assumptions above.
