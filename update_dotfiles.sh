#!/bin/bash

echo_success() {
  echo -e "\e[32;1m[$1]\e[0m\e[32m $2\e[0m"
}

echo_warning() {
  echo -e "\e[33;1m[$1]\e[0m\e[33m $2\e[0m"
}

echo_error() {
  echo -e "\e[31;1m[$1]\e[0m\e[31m $2\e[0m"
}

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

if [ -z "$CHACHI_PATH" ]; then
  echo_error "dotfiles" "CHACHI_PATH is not set. Add this to your environment before running this script."
  exit 1
fi

link_thing .bin
link_thing .ssh

link_thing .config/alacritty
link_thing .config/environment.d
link_thing .config/fish
link_thing .config/git
link_thing .config/ghostty
link_thing .config/hypr
link_thing .config/i3
link_thing .config/karabiner
link_thing .config/kitty
link_thing .config/helix
link_thing .config/lazygit
link_thing .config/nushell
link_thing .config/nvim
link_thing .config/opencode
link_thing .config/rofi
link_thing .config/starship
link_thing .config/sway
link_thing .config/tmux
link_thing .config/waybar
link_thing .config/zed

link_thing .Xdefaults
link_thing .Xresources
link_thing .bash_profile
link_thing .bashrc
link_thing .claude
link_thing .editorconfig
link_thing .gitconfig
link_thing .gitconfig.extra
link_thing .ideavimrc
link_thing .tmux.conf
link_thing .wezterm.lua
