#!/usr/bin/env bash
# Posts a reply to a pull request review comment.
#
# Usage: reply-comment.sh <owner> <repo> <number> <databaseId> <body-file>
#
# The body file contains the markdown reply content. On success, the file is
# deleted. On failure, the file remains for retry.
#
# Uses the REST API replies endpoint to create an in-thread reply (not a
# top-level issue comment). The databaseId is the numeric comment ID from the
# GraphQL thread data, not the GraphQL node ID.
#
# Requires: gh (GitHub CLI), authenticated

set -euo pipefail

if [ $# -lt 5 ]; then
  echo "Usage: reply-comment.sh <owner> <repo> <number> <databaseId> <body-file>" >&2
  exit 1
fi

OWNER="$1"
REPO="$2"
NUMBER="$3"
DATABASE_ID="$4"
BODY_FILE="$5"

if [ ! -f "$BODY_FILE" ]; then
  echo "Error: body file not found: $BODY_FILE" >&2
  exit 1
fi

gh api \
  --exit-status \
  --method POST \
  "repos/${OWNER}/${REPO}/pulls/${NUMBER}/comments/${DATABASE_ID}/replies" \
  -f body=@"${BODY_FILE}"

rm -f "$BODY_FILE"
