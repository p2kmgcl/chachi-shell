#!/usr/bin/env bash
# Usage: sync-viewed-files.sh <owner/repo> <pr_number>
#
# After a pending review has been posted:
#   - Marks files with zero findings as viewed
#   - Unmarks files that have findings (so they stand out)

set -euo pipefail

REPO="${1:?Usage: sync-viewed-files.sh <owner/repo> <pr_number>}"
PR_NUMBER="${2:?Missing PR number}"
OWNER="${REPO%/*}"
NAME="${REPO#*/}"

# Fetch PR node ID and pending review comments in one call
DATA=$(gh api graphql -f query="{
  repository(owner: \"$OWNER\", name: \"$NAME\") {
    pullRequest(number: $PR_NUMBER) {
      id
      files(first: 100) { nodes { path } }
      reviews(first: 10, states: PENDING) {
        nodes {
          comments(first: 100) { nodes { path } }
        }
      }
    }
  }
}")

PR_ID=$(echo "$DATA" | jq -r '.data.repository.pullRequest.id')

mapfile -t ALL_FILES < <(echo "$DATA" | jq -r '.data.repository.pullRequest.files.nodes[].path')

# Collect unique flagged paths from all pending reviews
mapfile -t FLAGGED_FILES < <(echo "$DATA" | jq -r '
  .data.repository.pullRequest.reviews.nodes[].comments.nodes[].path
' | sort -u)

MARKED=0 UNMARKED=0
FAILED=()

for FILE in "${ALL_FILES[@]}"; do
  IS_FLAGGED=0
  for F in "${FLAGGED_FILES[@]}"; do
    [[ "$FILE" == "$F" ]] && IS_FLAGGED=1 && break
  done

  if [[ $IS_FLAGGED -eq 0 ]]; then
    MUTATION="markFileAsViewed"
  else
    MUTATION="unmarkFileAsViewed"
  fi

  RESULT=$(gh api graphql -f query="mutation {
    $MUTATION(input: { pullRequestId: \"$PR_ID\", path: \"$FILE\" }) {
      pullRequest { id }
    }
  }" 2>&1)

  if echo "$RESULT" | grep -q '"errors"'; then
    FAILED+=("$MUTATION $FILE")
  elif [[ $IS_FLAGGED -eq 0 ]]; then
    ((MARKED++)) || true
  else
    ((UNMARKED++)) || true
  fi
done

echo "Marked $MARKED file(s) as viewed, unmarked $UNMARKED file(s) with findings."

if [[ ${#FAILED[@]} -gt 0 ]]; then
  echo "WARNING: ${#FAILED[@]} call(s) failed:"
  for F in "${FAILED[@]}"; do echo "  - $F"; done
  exit 1
fi
