#!/usr/bin/env bash
# Resolves a pull request review thread.
#
# Usage: resolve-thread.sh <thread_id>
#
# The thread_id is the GraphQL node ID from the review thread data (the "id"
# field, not "databaseId"). This uses the resolveReviewThread GraphQL mutation.
#
# Requires: gh (GitHub CLI), authenticated

set -euo pipefail

if [ $# -lt 1 ]; then
  echo "Usage: resolve-thread.sh <thread_id>" >&2
  exit 1
fi

THREAD_ID="$1"

QUERY='mutation($threadId: ID!) {
  resolveReviewThread(input: {threadId: $threadId}) {
    thread {
      id
      isResolved
    }
  }
}'

gh api graphql \
  --exit-status \
  -f query="$QUERY" \
  -f threadId="$THREAD_ID"
