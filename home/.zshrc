if [ -f "${XDG_CONFIG_HOME:-$HOME/.config}/shell/shellrc.sh" ]; then
  . "${XDG_CONFIG_HOME:-$HOME/.config}/shell/shellrc.sh"
fi
if [ -f "${XDG_CONFIG_HOME:-$HOME/.config}/zsh/zshrc.sh" ]; then
  . "${XDG_CONFIG_HOME:-$HOME/.config}/zsh/zshrc.sh"
fi
if [ -f "$HOME/.zshrc.local" ]; then
    . "$HOME/.zshrc.local"
fi
