#!/usr/bin/env bash

THIS_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
. "$THIS_DIR/echo.sh"
. "$THIS_DIR/transform.sh"
. "$THIS_DIR/link_override_subtree.sh"

_run_silently() {
  link_override_subtree "$@" >/dev/null 2>&1
}

test_noop_when_overrides_unset() {
  CHACHI_OVERRIDES_PATH="" CHACHI_PATH="/tmp/nonexistent" _run_silently '.claude'
  assert_eq 0 $? 'no-op when CHACHI_OVERRIDES_PATH empty'
}

test_noop_when_subtree_missing() {
  local base_dir overrides_dir
  base_dir="$(mktemp -d)"
  overrides_dir="$(mktemp -d)"
  CHACHI_PATH="$base_dir" CHACHI_OVERRIDES_PATH="$overrides_dir" _run_silently '.claude'
  assert_eq 0 $? 'no-op when subtree missing'
  rm -rf "$base_dir" "$overrides_dir"
}

test_creates_overlay_for_single_file() {
  local base_dir overrides_dir
  base_dir="$(mktemp -d)"
  overrides_dir="$(mktemp -d)"
  mkdir -p "$base_dir/home/.claude/skills/create-ticket"
  mkdir -p "$overrides_dir/home/.claude/skills/create-ticket"
  echo 'override' > "$overrides_dir/home/.claude/skills/create-ticket/SKILL.md"
  CHACHI_PATH="$base_dir" CHACHI_OVERRIDES_PATH="$overrides_dir" _run_silently '.claude'
  assert_eq \
    "$overrides_dir/home/.claude/skills/create-ticket/SKILL.md" \
    "$(readlink "$base_dir/home/.claude/skills/create-ticket/SKILL.local.md")" \
    'overlay symlink at .local target'
  rm -rf "$base_dir" "$overrides_dir"
}

test_creates_overlay_when_base_subdir_missing() {
  local base_dir overrides_dir
  base_dir="$(mktemp -d)"
  overrides_dir="$(mktemp -d)"
  mkdir -p "$base_dir/home/.claude"
  mkdir -p "$overrides_dir/home/.claude/skills/new-skill"
  echo 'override' > "$overrides_dir/home/.claude/skills/new-skill/SKILL.md"
  CHACHI_PATH="$base_dir" CHACHI_OVERRIDES_PATH="$overrides_dir" _run_silently '.claude'
  assert_eq \
    "$overrides_dir/home/.claude/skills/new-skill/SKILL.md" \
    "$(readlink "$base_dir/home/.claude/skills/new-skill/SKILL.local.md")" \
    'overlay created alongside missing base dir'
  rm -rf "$base_dir" "$overrides_dir"
}

test_handles_multiple_files() {
  local base_dir overrides_dir
  base_dir="$(mktemp -d)"
  overrides_dir="$(mktemp -d)"
  mkdir -p "$base_dir/home/.claude"
  mkdir -p "$overrides_dir/home/.claude/skills/a" "$overrides_dir/home/.claude/skills/b"
  echo 'a' > "$overrides_dir/home/.claude/skills/a/SKILL.md"
  echo 'b' > "$overrides_dir/home/.claude/skills/b/SKILL.md"
  CHACHI_PATH="$base_dir" CHACHI_OVERRIDES_PATH="$overrides_dir" _run_silently '.claude'
  assert_eq \
    "$overrides_dir/home/.claude/skills/a/SKILL.md" \
    "$(readlink "$base_dir/home/.claude/skills/a/SKILL.local.md")" \
    'overlay A'
  assert_eq \
    "$overrides_dir/home/.claude/skills/b/SKILL.md" \
    "$(readlink "$base_dir/home/.claude/skills/b/SKILL.local.md")" \
    'overlay B'
  rm -rf "$base_dir" "$overrides_dir"
}

test_idempotent_rerun() {
  local base_dir overrides_dir
  base_dir="$(mktemp -d)"
  overrides_dir="$(mktemp -d)"
  mkdir -p "$base_dir/home/.claude/skills/x"
  mkdir -p "$overrides_dir/home/.claude/skills/x"
  echo 'x' > "$overrides_dir/home/.claude/skills/x/SKILL.md"
  CHACHI_PATH="$base_dir" CHACHI_OVERRIDES_PATH="$overrides_dir" _run_silently '.claude'
  CHACHI_PATH="$base_dir" CHACHI_OVERRIDES_PATH="$overrides_dir" _run_silently '.claude'
  assert_eq 0 $? 'idempotent rerun'
  rm -rf "$base_dir" "$overrides_dir"
}

test_fails_on_wrong_existing_overlay() {
  local base_dir overrides_dir other
  base_dir="$(mktemp -d)"
  overrides_dir="$(mktemp -d)"
  other="$(mktemp)"
  mkdir -p "$base_dir/home/.claude/skills/x"
  mkdir -p "$overrides_dir/home/.claude/skills/x"
  echo 'override' > "$overrides_dir/home/.claude/skills/x/SKILL.md"
  ln -s "$other" "$base_dir/home/.claude/skills/x/SKILL.local.md"
  CHACHI_PATH="$base_dir" CHACHI_OVERRIDES_PATH="$overrides_dir" _run_silently '.claude'
  assert_eq 2 $? 'fails with code 2 when overlay points elsewhere'
  rm -rf "$base_dir" "$overrides_dir" "$other"
}

test_fails_on_real_file_at_overlay_path() {
  local base_dir overrides_dir
  base_dir="$(mktemp -d)"
  overrides_dir="$(mktemp -d)"
  mkdir -p "$base_dir/home/.claude/skills/x"
  mkdir -p "$overrides_dir/home/.claude/skills/x"
  echo 'override' > "$overrides_dir/home/.claude/skills/x/SKILL.md"
  echo 'real' > "$base_dir/home/.claude/skills/x/SKILL.local.md"
  CHACHI_PATH="$base_dir" CHACHI_OVERRIDES_PATH="$overrides_dir" _run_silently '.claude'
  assert_eq 4 $? 'fails with code 4 for real file at overlay path'
  rm -rf "$base_dir" "$overrides_dir"
}

test_noop_when_overrides_unset
test_noop_when_subtree_missing
test_creates_overlay_for_single_file
test_creates_overlay_when_base_subdir_missing
test_handles_multiple_files
test_idempotent_rerun
test_fails_on_wrong_existing_overlay
test_fails_on_real_file_at_overlay_path
