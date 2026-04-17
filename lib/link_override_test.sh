#!/usr/bin/env bash

THIS_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
. "$THIS_DIR/echo.sh"
. "$THIS_DIR/transform.sh"
. "$THIS_DIR/link_override.sh"

_link_override_silently() {
  link_override "$@" >/dev/null 2>&1
}

test_noop_when_overrides_unset() {
  CHACHI_OVERRIDES_PATH="" _link_override_silently '.bashrc'
  assert_eq 0 $? 'no-op when CHACHI_OVERRIDES_PATH empty'
}

test_noop_when_override_missing() {
  local overrides_dir home_dir
  overrides_dir="$(mktemp -d)"
  home_dir="$(mktemp -d)"
  CHACHI_OVERRIDES_PATH="$overrides_dir" HOME="$home_dir" _link_override_silently '.bashrc'
  assert_eq '' "$(ls -A "$home_dir")" 'no target created when override missing'
  rm -rf "$overrides_dir" "$home_dir"
}

test_noop_when_override_source_is_directory() {
  local overrides_dir home_dir
  overrides_dir="$(mktemp -d)"
  home_dir="$(mktemp -d)"
  mkdir -p "$overrides_dir/home/.claude"
  CHACHI_OVERRIDES_PATH="$overrides_dir" HOME="$home_dir" _link_override_silently '.claude'
  assert_eq '' "$(ls -A "$home_dir")" 'no target created when override source is a directory'
  rm -rf "$overrides_dir" "$home_dir"
}

test_links_override_to_local_target() {
  local overrides_dir home_dir
  overrides_dir="$(mktemp -d)"
  home_dir="$(mktemp -d)"
  mkdir -p "$overrides_dir/home"
  echo 'override' > "$overrides_dir/home/.bashrc"
  CHACHI_OVERRIDES_PATH="$overrides_dir" HOME="$home_dir" _link_override_silently '.bashrc'
  assert_eq "$overrides_dir/home/.bashrc" "$(readlink "$home_dir/.bashrc.local")" 'override symlink target'
  rm -rf "$overrides_dir" "$home_dir"
}

test_nested_path_creates_parent_dirs() {
  local overrides_dir home_dir rel
  overrides_dir="$(mktemp -d)"
  home_dir="$(mktemp -d)"
  rel='.claude/skills/write-code/SKILL.md'
  mkdir -p "$overrides_dir/home/$(dirname "$rel")"
  echo 'override' > "$overrides_dir/home/$rel"
  CHACHI_OVERRIDES_PATH="$overrides_dir" HOME="$home_dir" _link_override_silently "$rel"
  assert_eq "$overrides_dir/home/$rel" "$(readlink "$home_dir/.claude/skills/write-code/SKILL.local.md")" 'nested override linked'
  rm -rf "$overrides_dir" "$home_dir"
}

test_idempotent_on_correct_existing_link() {
  local overrides_dir home_dir
  overrides_dir="$(mktemp -d)"
  home_dir="$(mktemp -d)"
  mkdir -p "$overrides_dir/home"
  echo 'override' > "$overrides_dir/home/.bashrc"
  CHACHI_OVERRIDES_PATH="$overrides_dir" HOME="$home_dir" _link_override_silently '.bashrc'
  CHACHI_OVERRIDES_PATH="$overrides_dir" HOME="$home_dir" _link_override_silently '.bashrc'
  assert_eq 0 $? 'idempotent rerun exits 0'
  rm -rf "$overrides_dir" "$home_dir"
}

test_fails_on_real_file_at_local_target() {
  local overrides_dir home_dir
  overrides_dir="$(mktemp -d)"
  home_dir="$(mktemp -d)"
  mkdir -p "$overrides_dir/home"
  echo 'override' > "$overrides_dir/home/.bashrc"
  echo 'existing user file' > "$home_dir/.bashrc.local"
  CHACHI_OVERRIDES_PATH="$overrides_dir" HOME="$home_dir" _link_override_silently '.bashrc'
  assert_eq 4 $? 'fails with code 4 for real file at .local target'
  assert_eq 'existing user file' "$(cat "$home_dir/.bashrc.local")" 'real file left untouched'
  rm -rf "$overrides_dir" "$home_dir"
}

test_fails_on_wrong_existing_link() {
  local overrides_dir home_dir other
  overrides_dir="$(mktemp -d)"
  home_dir="$(mktemp -d)"
  other="$(mktemp)"
  mkdir -p "$overrides_dir/home"
  echo 'override' > "$overrides_dir/home/.bashrc"
  ln -s "$other" "$home_dir/.bashrc.local"
  CHACHI_OVERRIDES_PATH="$overrides_dir" HOME="$home_dir" _link_override_silently '.bashrc'
  assert_eq 2 $? 'fails with code 2 when symlink points elsewhere'
  rm -rf "$overrides_dir" "$home_dir" "$other"
}

test_noop_when_overrides_unset
test_noop_when_override_missing
test_noop_when_override_source_is_directory
test_links_override_to_local_target
test_nested_path_creates_parent_dirs
test_idempotent_on_correct_existing_link
test_fails_on_real_file_at_local_target
test_fails_on_wrong_existing_link
