#!/usr/bin/env bash

THIS_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
. "$THIS_DIR/echo.sh"
. "$THIS_DIR/transform.sh"
. "$THIS_DIR/link_overrides.sh"

_run_silently() {
  link_all_overrides >/dev/null 2>&1
}

test_noop_when_overrides_unset() {
  CHACHI_OVERRIDES_PATH="" HOME="/tmp/nonexistent_home" _run_silently
  assert_eq 0 $? 'no-op when CHACHI_OVERRIDES_PATH empty'
}

test_noop_when_home_dir_missing() {
  local overrides_dir home_dir
  overrides_dir="$(mktemp -d)"
  home_dir="$(mktemp -d)"
  CHACHI_OVERRIDES_PATH="$overrides_dir" HOME="$home_dir" _run_silently
  assert_eq 0 $? 'no-op when overrides has no home/ subtree'
  rm -rf "$overrides_dir" "$home_dir"
}

test_links_top_level_file() {
  local overrides_dir home_dir
  overrides_dir="$(mktemp -d)"
  home_dir="$(mktemp -d)"
  mkdir -p "$overrides_dir/home"
  echo 'override' > "$overrides_dir/home/.bashrc"
  CHACHI_OVERRIDES_PATH="$overrides_dir" HOME="$home_dir" _run_silently
  assert_eq \
    "$overrides_dir/home/.bashrc" \
    "$(readlink "$home_dir/.bashrc.local")" \
    'top-level file linked with .local transform'
  rm -rf "$overrides_dir" "$home_dir"
}

test_links_nested_file() {
  local overrides_dir home_dir
  overrides_dir="$(mktemp -d)"
  home_dir="$(mktemp -d)"
  mkdir -p "$overrides_dir/home/.claude/skills/create-ticket"
  echo 'override' > "$overrides_dir/home/.claude/skills/create-ticket/SKILL.md"
  CHACHI_OVERRIDES_PATH="$overrides_dir" HOME="$home_dir" _run_silently
  assert_eq \
    "$overrides_dir/home/.claude/skills/create-ticket/SKILL.md" \
    "$(readlink "$home_dir/.claude/skills/create-ticket/SKILL.local.md")" \
    'nested file linked with .local transform'
  rm -rf "$overrides_dir" "$home_dir"
}

test_creates_parent_dirs() {
  local overrides_dir home_dir
  overrides_dir="$(mktemp -d)"
  home_dir="$(mktemp -d)"
  mkdir -p "$overrides_dir/home/dd/web-ui/.claude"
  echo 'override' > "$overrides_dir/home/dd/web-ui/.claude/settings.json"
  CHACHI_OVERRIDES_PATH="$overrides_dir" HOME="$home_dir" _run_silently
  assert_eq \
    "$overrides_dir/home/dd/web-ui/.claude/settings.json" \
    "$(readlink "$home_dir/dd/web-ui/.claude/settings.local.json")" \
    'missing parent dirs created under $HOME'
  rm -rf "$overrides_dir" "$home_dir"
}

test_handles_multiple_files() {
  local overrides_dir home_dir
  overrides_dir="$(mktemp -d)"
  home_dir="$(mktemp -d)"
  mkdir -p "$overrides_dir/home/.claude/skills/a" "$overrides_dir/home/.claude/skills/b"
  echo 'a' > "$overrides_dir/home/.claude/skills/a/SKILL.md"
  echo 'b' > "$overrides_dir/home/.claude/skills/b/SKILL.md"
  echo 'root' > "$overrides_dir/home/.bashrc"
  CHACHI_OVERRIDES_PATH="$overrides_dir" HOME="$home_dir" _run_silently
  assert_eq \
    "$overrides_dir/home/.claude/skills/a/SKILL.md" \
    "$(readlink "$home_dir/.claude/skills/a/SKILL.local.md")" \
    'overlay A'
  assert_eq \
    "$overrides_dir/home/.claude/skills/b/SKILL.md" \
    "$(readlink "$home_dir/.claude/skills/b/SKILL.local.md")" \
    'overlay B'
  assert_eq \
    "$overrides_dir/home/.bashrc" \
    "$(readlink "$home_dir/.bashrc.local")" \
    'top-level file also overlaid'
  rm -rf "$overrides_dir" "$home_dir"
}

test_idempotent_rerun() {
  local overrides_dir home_dir
  overrides_dir="$(mktemp -d)"
  home_dir="$(mktemp -d)"
  mkdir -p "$overrides_dir/home"
  echo 'override' > "$overrides_dir/home/.bashrc"
  CHACHI_OVERRIDES_PATH="$overrides_dir" HOME="$home_dir" _run_silently
  CHACHI_OVERRIDES_PATH="$overrides_dir" HOME="$home_dir" _run_silently
  assert_eq 0 $? 'idempotent rerun'
  rm -rf "$overrides_dir" "$home_dir"
}

test_fails_on_wrong_existing_symlink() {
  local overrides_dir home_dir other
  overrides_dir="$(mktemp -d)"
  home_dir="$(mktemp -d)"
  other="$(mktemp)"
  mkdir -p "$overrides_dir/home"
  echo 'override' > "$overrides_dir/home/.bashrc"
  ln -s "$other" "$home_dir/.bashrc.local"
  CHACHI_OVERRIDES_PATH="$overrides_dir" HOME="$home_dir" _run_silently
  assert_eq 2 $? 'fails with code 2 when overlay points elsewhere'
  rm -rf "$overrides_dir" "$home_dir" "$other"
}

test_fails_on_real_file_at_target() {
  local overrides_dir home_dir
  overrides_dir="$(mktemp -d)"
  home_dir="$(mktemp -d)"
  mkdir -p "$overrides_dir/home"
  echo 'override' > "$overrides_dir/home/.bashrc"
  echo 'real' > "$home_dir/.bashrc.local"
  CHACHI_OVERRIDES_PATH="$overrides_dir" HOME="$home_dir" _run_silently
  assert_eq 4 $? 'fails with code 4 for real file at overlay path'
  rm -rf "$overrides_dir" "$home_dir"
}

test_noop_when_overrides_unset
test_noop_when_home_dir_missing
test_links_top_level_file
test_links_nested_file
test_creates_parent_dirs
test_handles_multiple_files
test_idempotent_rerun
test_fails_on_wrong_existing_symlink
test_fails_on_real_file_at_target
