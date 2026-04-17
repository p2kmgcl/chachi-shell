#!/usr/bin/env bash

THIS_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
. "$THIS_DIR/echo.sh"
. "$THIS_DIR/link.sh"

_link_thing_silently() {
  link_thing "$@" >/dev/null 2>&1
}

test_links_file_when_target_missing() {
  local base_dir home_dir
  base_dir="$(mktemp -d)"
  home_dir="$(mktemp -d)"
  mkdir -p "$base_dir/home"
  echo 'base' > "$base_dir/home/.bashrc"
  CHACHI_PATH="$base_dir" HOME="$home_dir" _link_thing_silently '.bashrc'
  assert_eq "$base_dir/home/.bashrc" "$(readlink "$home_dir/.bashrc")" 'file linked when missing'
  rm -rf "$base_dir" "$home_dir"
}

test_links_directory_when_target_missing() {
  local base_dir home_dir
  base_dir="$(mktemp -d)"
  home_dir="$(mktemp -d)"
  mkdir -p "$base_dir/home/.config/fish"
  CHACHI_PATH="$base_dir" HOME="$home_dir" _link_thing_silently '.config/fish'
  assert_eq "$base_dir/home/.config/fish" "$(readlink "$home_dir/.config/fish")" 'dir linked when missing'
  rm -rf "$base_dir" "$home_dir"
}

test_idempotent_on_correct_existing_link() {
  local base_dir home_dir
  base_dir="$(mktemp -d)"
  home_dir="$(mktemp -d)"
  mkdir -p "$base_dir/home"
  echo 'base' > "$base_dir/home/.bashrc"
  CHACHI_PATH="$base_dir" HOME="$home_dir" _link_thing_silently '.bashrc'
  CHACHI_PATH="$base_dir" HOME="$home_dir" _link_thing_silently '.bashrc'
  assert_eq 0 $? 'rerun on correct existing link exits 0'
  rm -rf "$base_dir" "$home_dir"
}

test_backs_up_existing_real_file() {
  local base_dir home_dir
  base_dir="$(mktemp -d)"
  home_dir="$(mktemp -d)"
  mkdir -p "$base_dir/home"
  echo 'base' > "$base_dir/home/.bashrc"
  echo 'user original' > "$home_dir/.bashrc"
  CHACHI_PATH="$base_dir" HOME="$home_dir" _link_thing_silently '.bashrc'
  assert_eq "$base_dir/home/.bashrc" "$(readlink "$home_dir/.bashrc")" 'target replaced with symlink'
  assert_eq 'user original' "$(cat "$home_dir/.bashrc.bak")" 'original content backed up'
  rm -rf "$base_dir" "$home_dir"
}

test_fails_when_backup_already_exists() {
  local base_dir home_dir
  base_dir="$(mktemp -d)"
  home_dir="$(mktemp -d)"
  mkdir -p "$base_dir/home"
  echo 'base' > "$base_dir/home/.bashrc"
  echo 'user' > "$home_dir/.bashrc"
  echo 'existing backup' > "$home_dir/.bashrc.bak"
  CHACHI_PATH="$base_dir" HOME="$home_dir" _link_thing_silently '.bashrc'
  assert_eq 3 $? 'fails with code 3 when .bak already exists'
  assert_eq 'user' "$(cat "$home_dir/.bashrc")" 'target untouched'
  assert_eq 'existing backup' "$(cat "$home_dir/.bashrc.bak")" 'backup untouched'
  rm -rf "$base_dir" "$home_dir"
}

test_fails_when_source_file_target_directory() {
  local base_dir home_dir
  base_dir="$(mktemp -d)"
  home_dir="$(mktemp -d)"
  mkdir -p "$base_dir/home"
  echo 'base' > "$base_dir/home/.bashrc"
  mkdir -p "$home_dir/.bashrc"
  CHACHI_PATH="$base_dir" HOME="$home_dir" _link_thing_silently '.bashrc'
  assert_eq 1 $? 'fails with code 1 when target is a directory'
  rm -rf "$base_dir" "$home_dir"
}

test_fails_when_source_directory_target_file() {
  local base_dir home_dir
  base_dir="$(mktemp -d)"
  home_dir="$(mktemp -d)"
  mkdir -p "$base_dir/home/.config"
  echo 'not a dir' > "$home_dir/.config"
  CHACHI_PATH="$base_dir" HOME="$home_dir" _link_thing_silently '.config'
  assert_eq 1 $? 'fails with code 1 when target is a file'
  rm -rf "$base_dir" "$home_dir"
}

test_fails_when_existing_symlink_points_elsewhere() {
  local base_dir home_dir other
  base_dir="$(mktemp -d)"
  home_dir="$(mktemp -d)"
  other="$(mktemp)"
  mkdir -p "$base_dir/home"
  echo 'base' > "$base_dir/home/.bashrc"
  ln -s "$other" "$home_dir/.bashrc"
  CHACHI_PATH="$base_dir" HOME="$home_dir" _link_thing_silently '.bashrc'
  assert_eq 2 $? 'fails with code 2 when symlink points elsewhere'
  rm -rf "$base_dir" "$home_dir" "$other"
}

test_links_file_when_target_missing
test_links_directory_when_target_missing
test_idempotent_on_correct_existing_link
test_backs_up_existing_real_file
test_fails_when_backup_already_exists
test_fails_when_source_file_target_directory
test_fails_when_source_directory_target_file
test_fails_when_existing_symlink_points_elsewhere
