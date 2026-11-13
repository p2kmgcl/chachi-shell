#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
FIXTURE="$(mktemp -d)"
trap 'rm -rf "$FIXTURE"' EXIT
cp "$ROOT/test.sh" "$FIXTURE/test.sh"
mkdir "$FIXTURE/lib"

printf 'test_missing_function\nassert_eq yes yes\n' >"$FIXTURE/lib/fixture_test.sh"
if bash "$FIXTURE/test.sh" >"$FIXTURE/output" 2>&1; then
  printf 'FAIL: runner accepted an undefined test function\n'
  exit 1
fi
grep -q 'test_missing_function' "$FIXTURE/output"
grep -q '1 failed' "$FIXTURE/output"

# A nonzero command can be the behavior under test, not a runner failure.
printf 'false\nassert_eq 1 $? "expected failure"\n' >"$FIXTURE/lib/fixture_test.sh"
bash "$FIXTURE/test.sh" >"$FIXTURE/output" 2>&1
grep -q '1 passed, 0 failed' "$FIXTURE/output"

printf 'Test runner tests passed\n'
