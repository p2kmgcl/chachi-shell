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
  .agents
  .claude
  .codex
  .config/shell
  .config/zsh
  .config/git
  .config/ghostty
  .config/lazygit
  .config/nvim
  .config/starship
  .config/tmux
  .config/zed

  .bash_profile
  .bashrc
  .editorconfig
  .gitconfig
  .profile
  .zprofile
  .zshenv
  .zshrc
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
  "$CHACHI_OVERRIDES_PATH/update_dotfiles.post.sh" 2>&1 | prefix "⏭️ update_dotfiles.post.sh"
fi
