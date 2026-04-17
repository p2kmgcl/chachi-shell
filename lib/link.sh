#!/bin/bash

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
      echo_success "$thing_name" "already linked"
      return 0
    else
      echo_error "[$thing_name]" "'$target_path' is already a link to '$existing_link'"
      return 2
    fi
  fi

  if [ -e "$target_path" ]; then
    echo_warning "$thing_name" "'$target_path' already exists, moving to '$backup_path'"

    if [ -e "$backup_path" ]; then
      echo_error "$thing_name" "'$backup_path' backup directory already exists"
      return 3
    fi

    mv "$target_path" "$backup_path"
  fi

  ln -s "$source_path" "$target_path"
  echo_success "$thing_name" "'$target_path' → '$source_path'"
}
