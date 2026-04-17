#!/usr/bin/env bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
. "$SCRIPT_DIR/lib/echo.sh"
. "$SCRIPT_DIR/lib/transform.sh"
. "$SCRIPT_DIR/lib/link.sh"
. "$SCRIPT_DIR/lib/link_override.sh"

if [ -z "$CHACHI_PATH" ]; then
  echo_error "dotfiles" "CHACHI_PATH is not set. Add this to your environment before running this script."
  exit 1
fi

ENTRIES=(
  .bin
  .ssh

  .config/alacritty
  .config/environment.d
  .config/fish
  .config/git
  .config/ghostty
  .config/hypr
  .config/i3
  .config/karabiner
  .config/kitty
  .config/helix
  .config/lazygit
  .config/nushell
  .config/nvim
  .config/opencode
  .config/rofi
  .config/starship
  .config/sway
  .config/tmux
  .config/waybar
  .config/zed

  .Xresources
  .bash_profile
  .bashrc
  .claude
  .editorconfig
  .gitconfig
  .ideavimrc
  .wezterm.lua
)

for entry in "${ENTRIES[@]}"; do
  link_thing "$entry"
  link_override "$entry"
done
