---
name: pr-response
description: Use when the operator says "pr-response" or "/pr-response", asks to address PR review feedback, or asks to reply to review comments on an open PR.
metadata:
  author: Tyler Benfield
  version: "2026.5.21"
compatibility: Requires the GitHub CLI (gh) installed and authenticated.
---

# PR Response

Process unresolved review comments on an open PR. You are the PR author — you hold the domain context and decide what feedback is valid and in scope. You have authority to push back on feedback that doesn't serve the PR.

## Pre-conditions — halt if unmet

1. **No PR identified.** Requires an open PR number, URL, or a branch with an associated PR. If none is available, halt and ask the operator.
2. **GitHub CLI unavailable.** `gh` must be installed and authenticated. Verify with `gh auth status`. If unavailable, instruct the operator to install and authenticate before proceeding.

## Workflow

### 1. Identify the PR

If the operator provides a PR number or URL, use it directly. If the PR was created earlier in the current conversation, use that. Otherwise, detect from the current branch:

```bash
gh pr view --json number,url
```

### 2. Collect unresolved comments

```bash
scripts/fetch-threads.sh <owner> <repo> <number>
```

Output is a JSON array of unresolved threads. Each thread has:

- `id` — GraphQL node ID (for resolution, step 6)
- `path`, `line` — file and line context
- `comments.nodes` — ordered comments, each with `id`, `databaseId`, `author.login`, `body`, `createdAt`

Use `databaseId` for replying (step 5) and `id` for resolving (step 6).

### 3. Assess each thread

Evaluate each unresolved thread:

- **Valid and in scope**: Identifies a real issue the current PR should fix. Implement the change.
- **Valid but out of scope**: Identifies a real issue, but fixing it belongs in a separate change. Do **not** implement it. Add to the out-of-scope list.
- **Not valid or not relevant**: Based on a misunderstanding, applies to a different context, or conflicts with the PR's intent. Do **not** implement it.

You are the PR author and the subject matter expert for this change. You decide what is valid and in scope. Push back on feedback that doesn't serve the PR — don't adopt changes just because a reviewer suggested them. If a comment raises a concern you cannot assess (e.g., organizational policy, cross-team impact), flag it and ask the operator before proceeding.

### 4. Implement valid in-scope feedback

For each in-scope comment, make the change and commit individually. Do **not** push until all in-scope changes are committed — batch into a single push to avoid wasteful CI runs.

1. Make the change.
2. Commit with a message referencing the feedback (e.g., `fix: address review feedback on error handling`).
3. Repeat for all in-scope comments.
4. Push once after all commits are ready.

### 5. Reply to every comment

Write the reply body to a file, then call the script with the file path:

1. Write the reply body to `.agents/tmp/reply-<databaseId>.md`.
2. Call:

```bash
scripts/reply-comment.sh <owner> <repo> <number> <databaseId> .agents/tmp/reply-<databaseId>.md
```

On success the script deletes the body file. On failure the file remains for retry.

Do **not** use `gh pr comment` — it posts top-level comments, not in-thread replies.

Reply formats:

- **Implemented**: State what changed and why. Reference the commit if pushed (e.g., "Updated to use the typed constant as suggested. Pushed in abc1234.")
- **Out of scope**: Acknowledge the point, state it's out of scope for this change, and suggest follow-up in a separate issue (e.g., "Good point, but this is out of scope for this change. I'll suggest a follow-up for it.")
- **Not valid**: Explain concisely why the feedback doesn't apply (e.g., "The null check is intentional — this code path receives values from the legacy format that omits this field.")

### 6. Resolve threads

After replying, resolve the thread if:

- You implemented the feedback and pushed the change, **or**
- Your reply explains why the feedback doesn't apply and the reviewer has not pushed back, **or**
- The last reply is yours and the reviewer has accepted your response.

Resolve using:

```bash
scripts/resolve-thread.sh <thread_id>
```

The `thread_id` is the GraphQL node ID from step 2.

**Do not** resolve a thread where the reviewer's last message indicates disagreement or a follow-up question you haven't answered.

### 7. Report out-of-scope items

If any valid-but-out-of-scope items were identified, present them to the operator:

```markdown
## Out-of-scope items for follow-up

- **F1**: [Summary] — suggested by @reviewer in [comment link]
- **F2**: [Summary] — suggested by @reviewer in [comment link]
```

Suggest the operator capture these as tickets. The F-labels are ephemeral session labels for this reply — do not persist them into code.

## Constraints

- Never resolve a thread while the reviewer's concern is unaddressed.
- Never include session-internal designations in PR replies, commit messages, or code.
- Use repo-relative paths only. Never embed absolute paths in code, comments, or replies.
