#!/bin/bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
. "$SCRIPT_DIR/lib/echo.sh"
. "$SCRIPT_DIR/lib/transform.sh"
. "$SCRIPT_DIR/lib/link.sh"

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

link_thing .Xresources
link_thing .bash_profile
link_thing .bashrc
link_thing .claude
link_thing .editorconfig
link_thing .gitconfig
link_thing .ideavimrc
link_thing .wezterm.lua
