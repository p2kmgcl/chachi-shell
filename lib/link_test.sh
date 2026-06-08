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
  echo 'base' >"$base_dir/home/.bashrc"
  CHACHI_PATH="$base_dir" HOME="$home_dir" _link_thing_silently '.bashrc'
  assert_eq "$base_dir/home/.bashrc" "$(readlink "$home_dir/.bashrc")" 'file linked when missing'
  rm -rf "$base_dir" "$home_dir"
}

test_idempotent_on_correct_existing_link() {
  local base_dir home_dir
  base_dir="$(mktemp -d)"
  home_dir="$(mktemp -d)"
  mkdir -p "$base_dir/home"
  echo 'base' >"$base_dir/home/.bashrc"
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
  echo 'base' >"$base_dir/home/.bashrc"
  echo 'user original' >"$home_dir/.bashrc"
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
  echo 'base' >"$base_dir/home/.bashrc"
  echo 'user' >"$home_dir/.bashrc"
  echo 'existing backup' >"$home_dir/.bashrc.bak"
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
  echo 'base' >"$base_dir/home/.bashrc"
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
  echo 'not a dir' >"$home_dir/.config"
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
  echo 'base' >"$base_dir/home/.bashrc"
  ln -s "$other" "$home_dir/.bashrc"
  CHACHI_PATH="$base_dir" HOME="$home_dir" _link_thing_silently '.bashrc'
  assert_eq 2 $? 'fails with code 2 when symlink points elsewhere'
  rm -rf "$base_dir" "$home_dir" "$other"
}

_link_dir_silently() {
  link_dir "$@" >/dev/null 2>&1
}

test_link_dir_creates_symlink_when_target_missing() {
  local src tgt
  src="$(mktemp -d)"
  tgt="$(mktemp -d)/state"
  _link_dir_silently "$src" "$tgt" 'state'
  assert_eq "$src" "$(readlink "$tgt")" 'dir linked when target missing'
  rm -rf "$src" "$(dirname "$tgt")"
}

test_link_dir_creates_parent_dirs() {
  local src parent tgt
  src="$(mktemp -d)"
  parent="$(mktemp -d)"
  tgt="$parent/nested/deeper/state"
  _link_dir_silently "$src" "$tgt" 'state'
  assert_eq "$src" "$(readlink "$tgt")" 'dir linked with parent created'
  rm -rf "$src" "$parent"
}

test_link_dir_idempotent_on_correct_existing_link() {
  local src tgt
  src="$(mktemp -d)"
  tgt="$(mktemp -d)/state"
  ln -s "$src" "$tgt"
  _link_dir_silently "$src" "$tgt" 'state'
  assert_eq 0 $? 'rerun on correct existing link exits 0'
  assert_eq "$src" "$(readlink "$tgt")" 'symlink unchanged'
  rm -rf "$src" "$(dirname "$tgt")"
}

test_link_dir_fails_when_existing_symlink_points_elsewhere() {
  local src other tgt
  src="$(mktemp -d)"
  other="$(mktemp -d)"
  tgt="$(mktemp -d)/state"
  ln -s "$other" "$tgt"
  _link_dir_silently "$src" "$tgt" 'state'
  assert_eq 2 $? 'fails with code 2 when symlink points elsewhere'
  assert_eq "$other" "$(readlink "$tgt")" 'symlink untouched'
  rm -rf "$src" "$other" "$(dirname "$tgt")"
}

test_link_dir_backs_up_existing_real_dir() {
  local src parent tgt
  src="$(mktemp -d)"
  echo 'new content' >"$src/marker"
  parent="$(mktemp -d)"
  tgt="$parent/state"
  mkdir -p "$tgt"
  echo 'pre-existing' >"$tgt/old"
  _link_dir_silently "$src" "$tgt" 'state'
  assert_eq "$src" "$(readlink "$tgt")" 'target replaced with symlink'
  assert_eq 'pre-existing' "$(cat "$parent/state.bak/old")" 'original dir backed up'
  rm -rf "$src" "$parent"
}

test_link_dir_fails_when_backup_already_exists() {
  local src parent tgt
  src="$(mktemp -d)"
  parent="$(mktemp -d)"
  tgt="$parent/state"
  mkdir -p "$tgt" "$tgt.bak"
  echo 'live' >"$tgt/file"
  echo 'old-backup' >"$tgt.bak/file"
  _link_dir_silently "$src" "$tgt" 'state'
  assert_eq 3 $? 'fails with code 3 when .bak already exists'
  assert_eq 'live' "$(cat "$tgt/file")" 'target untouched'
  assert_eq 'old-backup' "$(cat "$tgt.bak/file")" 'backup untouched'
  rm -rf "$src" "$parent"
}

test_link_dir_fails_when_target_is_file() {
  local src parent tgt
  src="$(mktemp -d)"
  parent="$(mktemp -d)"
  tgt="$parent/state"
  echo 'i am a file' >"$tgt"
  _link_dir_silently "$src" "$tgt" 'state'
  assert_eq 1 $? 'fails with code 1 when target is a regular file'
  assert_eq 'i am a file' "$(cat "$tgt")" 'file untouched'
  rm -rf "$src" "$parent"
}

test_link_dir_fails_when_source_is_not_a_directory() {
  local src parent tgt
  src="$(mktemp)"
  parent="$(mktemp -d)"
  tgt="$parent/state"
  _link_dir_silently "$src" "$tgt" 'state'
  assert_eq 1 $? 'fails with code 1 when source is not a directory'
  [ ! -e "$tgt" ]
  assert_eq 0 $? 'target not created'
  rm -rf "$src" "$parent"
}

test_links_file_when_target_missing
test_links_directory_when_target_missing
test_idempotent_on_correct_existing_link
test_backs_up_existing_real_file
test_fails_when_backup_already_exists
test_fails_when_source_file_target_directory
test_fails_when_source_directory_target_file
test_fails_when_existing_symlink_points_elsewhere
test_link_dir_creates_symlink_when_target_missing
test_link_dir_creates_parent_dirs
test_link_dir_idempotent_on_correct_existing_link
test_link_dir_fails_when_existing_symlink_points_elsewhere
test_link_dir_backs_up_existing_real_dir
test_link_dir_fails_when_backup_already_exists
test_link_dir_fails_when_target_is_file
test_link_dir_fails_when_source_is_not_a_directory
