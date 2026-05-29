## Code Review: main...feature/rate-limiter

Two correctness issues and one contract concern found.

### Feedback

#### F1: Window reset loses buffered requests

**Location**: `src/lib/rate-limiter.ts:34`

When the window expires, `resetWindow()` zeroes the counter and sets a new start time, but any requests that arrived during the expiry gap are discarded. A request at t=0 and t=61 (with a 60s window) results in a count of 1 instead of 2 — the second request starts a fresh window rather than being counted.

**Suggestion**: Use a sliding window or track individual timestamps so requests near the boundary aren't lost. For a fixed-window limiter, document that this boundary behavior is intentional.

#### F2: `remaining()` can return negative values

**Location**: `src/lib/rate-limiter.ts:42`

`remaining()` computes `maxRequests - count` without clamping. If `count` somehow exceeds `maxRequests` (e.g., due to a race condition in concurrent calls), the result is negative, which is confusing for callers.

**Suggestion**: Clamp the return value to zero: `return Math.max(0, this.maxRequests - this.count)`.

#### F3: `check()` is not safe for concurrent callers

**Location**: `src/lib/rate-limiter.ts:22`

`check()` reads and mutates `this.count` and `this.windowStart` without any synchronization. In a concurrent environment (e.g., multiple request handlers), two callers can both read `count` as below the limit, both increment, and exceed the limit.

**Suggestion**: If this is intended for single-threaded use only, document that constraint on the class. If concurrent use is possible, consider an atomic compare-and-swap or queue-based approach.

### Summary

The fixed-window implementation has a boundary condition that silently drops requests and lacks protection for concurrent access. The contract should either constrain usage or the implementation should handle these cases.
