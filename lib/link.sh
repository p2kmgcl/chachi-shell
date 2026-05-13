#!/usr/bin/env bash

link_thing() {
  local thing_name="$1"
  local source_path="$CHACHI_PATH/home/$thing_name"
  local target_path="$HOME/$thing_name"
  local backup_path="${target_path}.bak"

  if [ -f "$source_path" ] && [ -d "$target_path" ]; then
    echo_error "$thing_name" "'$target_path' is a directory, it should be a file"
    return 1
  fi

  if [ -d "$source_path" ] && [ -f "$target_path" ]; then
    echo_error "$thing_name" "'$target_path' is a file, it should be a directory"
    return 1
  fi

  if [ -L "$target_path" ]; then
    local existing_link="$(readlink $target_path)"

    if [ "$source_path" = "$existing_link" ]; then
      echo_ok "$thing_name"
      return 0
    else
      echo_error "$thing_name" "'$target_path' is already a link to '$existing_link'"
      return 2
    fi
  fi

  if [ -e "$target_path" ]; then
    echo_side_effect "$thing_name" "'$target_path' already exists, moving to '$backup_path'"

    if [ -e "$backup_path" ]; then
      echo_error "$thing_name" "'$backup_path' backup directory already exists"
      return 3
    fi

    mv "$target_path" "$backup_path"
  fi

  mkdir -p "$(dirname "$target_path")"
  ln -s "$source_path" "$target_path"
  echo_new "$thing_name" "'$target_path' → '$source_path'"
}

link_dir() {
  local source_path="$1"
  local target_path="$2"
  local label="$3"
  local backup_path="${target_path}.bak"

  if [ ! -d "$source_path" ]; then
    echo_error "$label" "source '$source_path' is not a directory"
    return 1
  fi

  if [ -L "$target_path" ]; then
    local existing_link="$(readlink $target_path)"

    if [ "$source_path" = "$existing_link" ]; then
      echo_ok "$label"
      return 0
    else
      echo_error "$label" "'$target_path' is already a link to '$existing_link'"
      return 2
    fi
  fi

  if [ -f "$target_path" ]; then
    echo_error "$label" "'$target_path' is a file, it should be a directory"
    return 1
  fi

  if [ -e "$target_path" ]; then
    echo_side_effect "$label" "'$target_path' already exists, moving to '$backup_path'"

    if [ -e "$backup_path" ]; then
      echo_error "$label" "'$backup_path' backup directory already exists"
      return 3
    fi

    mv "$target_path" "$backup_path"
  fi

  mkdir -p "$(dirname "$target_path")"
  ln -s "$source_path" "$target_path"
  echo_new "$label" "'$target_path' → '$source_path'"
}
