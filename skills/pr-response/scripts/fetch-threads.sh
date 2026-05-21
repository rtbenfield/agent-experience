#!/usr/bin/env bash
# Fetches unresolved review threads for a pull request.
#
# Usage: fetch-threads.sh <owner> <repo> <number>
#
# Outputs a JSON array of unresolved review threads. Each thread contains:
#   id          - GraphQL node ID (for resolving the thread)
#   isResolved  - always false (filtered by this script)
#   path        - file path the thread is on
#   line        - line number the thread is on
#   comments.nodes[] - ordered comments with:
#     id, databaseId, author.login, body, createdAt
#
# Requires: gh (GitHub CLI), authenticated
# Note: fetches up to 100 threads with up to 100 comments each.
#       For larger PRs, pagination would be needed.

set -euo pipefail

if [ $# -lt 3 ]; then
  echo "Usage: fetch-threads.sh <owner> <repo> <number>" >&2
  exit 1
fi

OWNER="$1"
REPO="$2"
NUMBER="$3"

QUERY='query($owner: String!, $repo: String!, $number: Int!) {
  repository(owner: $owner, name: $repo) {
    pullRequest(number: $number) {
      reviewThreads(first: 100) {
        nodes {
          id
          isResolved
          path
          line
          comments(first: 100) {
            nodes {
              id
              databaseId
              author { login }
              body
              createdAt
            }
          }
        }
      }
    }
  }
}'

gh api graphql \
  --exit-status \
  -f query="$QUERY" \
  -f owner="$OWNER" \
  -f repo="$REPO" \
  -F number="$NUMBER" \
  --jq '.data.repository.pullRequest.reviewThreads.nodes | map(select(.isResolved == false))'
