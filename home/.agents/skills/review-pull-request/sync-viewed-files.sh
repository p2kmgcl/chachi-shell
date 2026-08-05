#!/usr/bin/env bash
# Usage: printf '%s\n' <finding-paths> | sync-viewed-files.sh <owner/repo> <pr-number>

set -euo pipefail

REPO="${1:?Usage: sync-viewed-files.sh <owner/repo> <pr-number>}"
PR_NUMBER="${2:?Missing PR number}"
OWNER="${REPO%/*}"
NAME="${REPO#*/}"
WORK="$(mktemp -d)"
ALL_FILES="$WORK/all-files"
FLAGGED_FILES="$WORK/flagged-files"
trap 'rm -rf "$WORK"' EXIT

sort -u >"$FLAGGED_FILES"

PR_ID=$(gh api graphql \
  -f query='query($owner:String!,$name:String!,$number:Int!){repository(owner:$owner,name:$name){pullRequest(number:$number){id}}}' \
  -f owner="$OWNER" \
  -f name="$NAME" \
  -F number="$PR_NUMBER" \
  --jq '.data.repository.pullRequest.id')

gh api --paginate "repos/$REPO/pulls/$PR_NUMBER/files?per_page=100" \
  --jq '.[].filename' >"$ALL_FILES"

MARKED=0
UNMARKED=0
FAILED=()

while IFS= read -r FILE; do
  if grep -Fxq -- "$FILE" "$FLAGGED_FILES"; then
    MUTATION="unmarkFileAsViewed"
  else
    MUTATION="markFileAsViewed"
  fi

  QUERY="mutation(\$pullRequestId:ID!,\$path:String!){$MUTATION(input:{pullRequestId:\$pullRequestId,path:\$path}){clientMutationId}}"
  if gh api graphql \
    -f query="$QUERY" \
    -f pullRequestId="$PR_ID" \
    -f path="$FILE" >/dev/null 2>&1; then
    if [[ "$MUTATION" == "markFileAsViewed" ]]; then
      ((MARKED++)) || true
    else
      ((UNMARKED++)) || true
    fi
  else
    FAILED+=("$MUTATION $FILE")
  fi
done <"$ALL_FILES"

echo "Marked $MARKED file(s) as viewed, unmarked $UNMARKED file(s) with findings."

if [[ ${#FAILED[@]} -gt 0 ]]; then
  echo "WARNING: ${#FAILED[@]} call(s) failed:"
  for FAILURE in "${FAILED[@]}"; do
    echo "  - $FAILURE"
  done
  exit 1
fi
