# HTTP Proxy with CDN

## Problem

End users experience high latency for static assets, especially in regions far from origin servers. No caching layer exists to reduce origin load or accelerate delivery.

## Stakeholders

- **End users** — need fast page loads and reliable asset delivery
- **Infrastructure team** — need reduced origin load and cost efficiency
- **Content publishers** — need cache invalidation to propagate promptly

## Functional requirements

- **FR1**: The proxy forwards HTTP requests to origin servers transparently; on origin failure, serves stale content if available
- **FR2**: Static assets are served from cache when available — given a cached static asset, the proxy responds without contacting origin
- **FR3**: Cache invalidation propagates within 60 seconds after content changes — given an invalidation signal, stale content is not served after the propagation window
- **FR4**: The proxy handles HTTPS termination for client connections
- **FR5**: Requests for dynamic or personalized content bypass cache — given a personalized request, the proxy forwards to origin without caching

## Non-functional requirements

- **NFR1**: Cache hit rate ≥ 95% for static assets under normal load, measured by proxy access logs comparing cache hits to total static requests over a 24-hour window
- **NFR2**: Median latency for cached responses ≤ 20ms at the edge, measured by synthetic requests from each edge node with timing headers
- **NFR3**: TLS handshake completes in under 100ms, measured by synthetic TLS connection tests from representative client locations
- **NFR4**: Origin shielded from traffic spikes: 99th percentile request rate to origin ≤ 5% of total incoming, measured by comparing origin request logs to proxy ingress logs over a 1-hour window during peak load

## Assumptions

- Invalidation for FR3 is push-based (API call to purge), not pull-based (short TTL with revalidation). Push-based gives control over propagation timing and avoids stale-content windows.
- For FR5, "static assets" means files with immutable URLs (content-hashed filenames, versioned paths). Query-string–parameterized URLs are assumed dynamic and bypass cache.
- Single-region deployment for initial release. Multi-region PoPs are a future extension.
- FR1's graceful degradation serves stale content on origin failure rather than returning errors.
- Stale-while-revalidate serves stale content in the background while revalidating ⚠️ **RF1** (assumed stale-while-revalidate over block-until-fresh; verify this tradeoff is acceptable given FR3's 60-second propagation window).

## Out of scope

- WebSocket proxying
- Edge-side logic (ESI, edge functions)
- Multi-region PoP deployment (single region for initial release)

## Open questions

- **Q1**: What invalidation protocol should the proxy expose for cache purging — REST API, webhook, or message queue?
  - **Recommended**: REST API. Simplest to implement and debug, matches standard CDN purge APIs. A message queue adds operational complexity unwarranted for single-region deployment.
