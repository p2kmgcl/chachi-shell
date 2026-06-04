if [ -f "${XDG_CONFIG_HOME:-$HOME/.config}/shell/shell.sh" ]; then
  . "${XDG_CONFIG_HOME:-$HOME/.config}/shell/shell.sh"
fi
if [ -f "$HOME/.bashrc" ]; then
  . "$HOME/.bashrc"
fi
