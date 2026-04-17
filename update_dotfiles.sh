#!/usr/bin/env bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
. "$SCRIPT_DIR/lib/echo.sh"
. "$SCRIPT_DIR/lib/transform.sh"
. "$SCRIPT_DIR/lib/link.sh"
. "$SCRIPT_DIR/lib/link_overrides.sh"

if [ -z "$CHACHI_PATH" ]; then
  echo_error "dotfiles" "CHACHI_PATH is not set. Add this to your environment before running this script."
  exit 1
fi

ENTRIES_BASE=(
  .bin
  .ssh

  .config/alacritty
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

for entry in "${ENTRIES_BASE[@]}"; do
  if [ ! -e "$CHACHI_PATH/home/$entry" ]; then
    echo_error "$entry" "missing base source at '$CHACHI_PATH/home/$entry'"
    exit 1
  fi
  link_thing "$entry"
done

link_all_overrides

if [ -n "${CHACHI_OVERRIDES_PATH:-}" ] && [ -x "$CHACHI_OVERRIDES_PATH/update_dotfiles.post.sh" ]; then
  "$CHACHI_OVERRIDES_PATH/update_dotfiles.post.sh"
fi
