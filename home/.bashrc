if [ -f "${XDG_CONFIG_HOME:-$HOME/.config}/shell/shellrc.sh" ]; then
  . "${XDG_CONFIG_HOME:-$HOME/.config}/shell/shellrc.sh"
fi
if [ -f "$HOME/.bashrc.local" ]; then
    . "$HOME/.bashrc.local"
fi
