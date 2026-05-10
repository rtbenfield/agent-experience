# Project Spec Examples

## Example 1: Dark mode

### Outcome-focused prompt

> Add a dark mode toggle to settings. Should persist across sessions and apply globally.

### Generated spec (`.agents/projects/dark-mode.spec.md`)

```markdown
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

- **NFR1**: Theme changes render in under 100ms (no visible flash of wrong theme on load)
- **NFR2**: Dark mode meets WCAG AA contrast ratios across all components
- **NFR3**: All existing color usages are covered by theme tokens — no components may remain light in dark mode

## Assumptions

- Theme preference is stored per-device (localStorage), not per-account. This avoids backend changes and aligns with how most web apps handle theme persistence initially.
- OS-level preference is honored as the default, with explicit user choice overriding it.
- Only light and dark themes are in scope. Additional themes (high contrast, custom colors) would follow the same pattern later.

## Out of scope

- Additional themes beyond light and dark
- Per-component theme overrides
- Theme scheduling (e.g., auto-dark at sunset)

## Open questions

- None — remaining ambiguities are covered by assumptions above.
```

## Example 2: HTTP proxy with CDN

### Outcome-focused prompt

> Build an HTTP proxy that integrates a CDN layer for caching static assets and accelerating delivery to end users.

### Generated spec (`.agents/projects/http-proxy-cdn.spec.md`)

```markdown
# HTTP Proxy with CDN

## Problem

End users experience high latency for static assets, especially in regions far from origin servers. No caching layer exists to reduce origin load or accelerate delivery.

## Stakeholders

- **End users** — need fast page loads and reliable asset delivery
- **Infrastructure team** — need reduced origin load and cost efficiency
- **Content publishers** — need cache invalidation to propagate promptly

## Functional requirements

- **FR1**: The proxy forwards HTTP requests to origin servers transparently; on origin failure, serves stale content if available (graceful degradation; also covers FR6)
- **FR2**: Static assets are served from cache when available — given a cached static asset, the proxy responds without contacting origin
- **FR3**: Cache invalidation propagates within 60 seconds after content changes — given an invalidation signal, stale content is not served after the propagation window
- **FR4**: The proxy handles HTTPS termination for client connections
- **FR5**: Requests for dynamic or personalized content bypass cache — given a personalized request, the proxy forwards to origin without caching
- **FR6**: Cache miss requests are forwarded to origin and the response is cached when eligible

## Non-functional requirements

- **NFR1**: Cache hit rate ≥ 95% for static assets under normal load
- **NFR2**: Median latency for cached responses ≤ 20ms at the edge
- **NFR3**: Cache invalidation propagates within 60 seconds
- **NFR4**: TLS handshake completes in under 100ms
- **NFR5**: Origin shielded from traffic spikes: 99th percentile request rate to origin ≤ 5% of total incoming

## Assumptions

- Invalidation for FR3 is push-based (API call to purge), not pull-based (short TTL with revalidation). Push-based gives control over propagation timing and avoids stale-content windows.
- For FR5, "static assets" means files with immutable URLs (content-hashed filenames, versioned paths). Query-string–parameterized URLs are assumed dynamic and bypass cache.
- Single-region deployment for initial release. Multi-region PoPs are a future extension.
- FR1's graceful degradation serves stale content on origin failure rather than returning errors.

## Out of scope

- WebSocket proxying
- Edge-side logic (ESI, edge functions)
- Multi-region PoP deployment (single region for initial release)

## Open questions

> ⚠️ **REVIEW**: TTL for stale-while-revalidate — should cached content be served stale while revalidating in the background (preferred), or should it block until fresh? Serving stale in background keeps perceived latency low. Operator input needed because this affects both UX and origin load tradeoffs for FR3.
```
