#!/usr/bin/env bash

# Link a local override file into its `.local`-transformed target under $HOME.
# No-op unless CHACHI_OVERRIDES_PATH is set and the override source is a file.
link_override() {
  local thing_name="$1"

  if [ -z "${CHACHI_OVERRIDES_PATH:-}" ]; then
    return 0
  fi

  local source_path="$CHACHI_OVERRIDES_PATH/home/$thing_name"

  if [ ! -f "$source_path" ]; then
    return 0
  fi

  local target_relpath target_path label parent_dir
  target_relpath="$(compute_local_target "$thing_name")"
  target_path="$HOME/$target_relpath"
  label="override $target_relpath"

  if [ -L "$target_path" ]; then
    local existing_link
    existing_link="$(readlink "$target_path")"

    if [ "$source_path" = "$existing_link" ]; then
      echo_success "$label" "already linked"
      return 0
    else
      echo_error "$label" "'$target_path' is already a link to '$existing_link'"
      return 2
    fi
  fi

  if [ -e "$target_path" ]; then
    echo_error "$label" "'$target_path' exists as a real file; remove or merge into '$source_path' manually"
    return 4
  fi

  parent_dir="$(dirname "$target_path")"
  mkdir -p "$parent_dir"

  ln -s "$source_path" "$target_path"
  echo_success "$label" "'$target_path' → '$source_path'"
}
