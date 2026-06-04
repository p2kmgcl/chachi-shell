if [ -f "${XDG_CONFIG_HOME:-$HOME/.config}/shell/shell.sh" ]; then
  . "${XDG_CONFIG_HOME:-$HOME/.config}/shell/shell.sh"
fi
if [ -f "$HOME/.zshenv.local" ]; then
    . "$HOME/.zshenv.local"
fi
