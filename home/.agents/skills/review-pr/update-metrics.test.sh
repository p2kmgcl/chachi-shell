#!/usr/bin/env bash
# Tests for update-metrics.sh. Runs against a throwaway CSV in a temp dir,
# never touching the real metrics.csv. Run: ./update-metrics.test.sh
set -euo pipefail

DIR="$(cd "$(dirname "$0")" && pwd)"
SCRIPT="$DIR/update-metrics.sh"
WORK="$(mktemp -d)"
CSV="$WORK/metrics.csv"
trap 'rm -rf "$WORK"' EXIT

FAILED=0
check() {
  local name="$1" expected="$2" actual="$3"
  if [[ "$expected" == "$actual" ]]; then
    echo "ok   - $name"
  else
    echo "FAIL - $name"
    echo "       expected: $expected"
    echo "       actual:   $actual"
    FAILED=1
  fi
}
row() { grep "^$1," "$CSV"; }

# 1. Creates the file with a header; groups findings by priority; P3 found but not kept.
printf 'BUG-SECURITY,P0,1\nBUG-SECURITY,P2,1\nBUG-SECURITY,P2,0\nBUG-SECURITY,P3,0\n' \
  | "$SCRIPT" "$CSV" >/dev/null
check "header written" \
  "lens,found_p0,found_p1,found_p2,found_p3,kept_p0,kept_p1,kept_p2" \
  "$(head -1 "$CSV")"
# found: p0=1 p2=2 p3=1 ; kept: p0=1 p2=1
check "grouped + p3 not kept" "BUG-SECURITY,1,0,2,1,1,0,1" "$(row BUG-SECURITY)"

# 2. Accumulates across runs.
printf 'BUG-SECURITY,P1,1\n' | "$SCRIPT" "$CSV" >/dev/null
check "accumulates" "BUG-SECURITY,1,1,2,1,1,1,1" "$(row BUG-SECURITY)"

# 3. P3 marked kept=1 is still never counted as kept.
printf 'SMELL,P3,1\nSMELL,P3,1\n' | "$SCRIPT" "$CSV" >/dev/null
check "p3 never kept even if flagged" "SMELL,0,0,0,2,0,0,0" "$(row SMELL)"

# 4. Unknown lens appended; case-insensitive priority.
printf 'NEW-LENS,p1,1\n' | "$SCRIPT" "$CSV" >/dev/null
check "new lens + lowercase priority" "NEW-LENS,0,1,0,0,0,1,0" "$(row NEW-LENS)"

# 5. Merged finding credited to every contributing lens (one row each).
printf 'PATTERN-REUSE,P2,1\nARCHITECTURE,P2,1\n' | "$SCRIPT" "$CSV" >/dev/null
check "merge credit: PATTERN-REUSE" "PATTERN-REUSE,0,0,1,0,0,0,1" "$(row PATTERN-REUSE)"
check "merge credit: ARCHITECTURE" "ARCHITECTURE,0,0,1,0,0,0,1" "$(row ARCHITECTURE)"

# 6. Header line and unknown priority in the stream are ignored.
printf 'lens,found_p0,found_p1,found_p2,found_p3,kept_p0,kept_p1,kept_p2\nSMELL,P9,1\n' \
  | "$SCRIPT" "$CSV" >/dev/null
check "header + bad priority ignored" "SMELL,0,0,0,2,0,0,0" "$(row SMELL)"
check "no stray 'lens' row" "1" "$(grep -c '^lens,' "$CSV")"

if [[ $FAILED -eq 0 ]]; then
  echo "All tests passed."
else
  echo "Some tests failed." >&2
  exit 1
fi
