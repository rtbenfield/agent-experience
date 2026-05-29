## Code Review: main...feature/user-list-api

One correctness issue found. One existing issue flagged.

### Feedback

#### F1: Off-by-one in pagination boundary

**Location**: `src/routes/users.ts:58`

The `limit` check uses `>` instead of `>=`, allowing one more result than the limit specifies. With `limit=20`, the response can contain 21 items.

**Suggestion**: Change `if (results.length > limit)` to `if (results.length >= limit)` and slice accordingly.

#### F2: `authenticate` middleware swallows expired token errors

**Location**: `src/middleware/auth.ts:15`

The `authenticate` middleware catches all JWT errors and returns a generic 401. An expired token and an invalid token get the same response, preventing clients from distinguishing "re-authenticate" from "you're not authorized." This is a pre-existing issue, but the new endpoint depends on this behavior and its callers would benefit from the distinction.

**Suggestion**: This is an existing issue — the bar for flagging is higher. Flagging because the new endpoint's callers need to handle token expiry gracefully. Consider returning 401 with a `WWW-Authenticate` header that includes an `error="invalid_token"` or `error="expired_token"` hint per RFC 6750.

### Summary

Pagination boundary is off-by-one. The authentication middleware's error handling predates this change but limits the new endpoint's usability for token-expiry flows.
