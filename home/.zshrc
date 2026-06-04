[ "${CHACHI_SHELL_DEBUG:-0}" = "1" ] && echo "[shell] $HOME/.zshrc"
[ -f "${XDG_CONFIG_HOME:-$HOME/.config}/shell/shellrc.sh" ] && . "${XDG_CONFIG_HOME:-$HOME/.config}/shell/shellrc.sh"
[ -f "${XDG_CONFIG_HOME:-$HOME/.config}/zsh/zshrc.sh" ] && . "${XDG_CONFIG_HOME:-$HOME/.config}/zsh/zshrc.sh"
if [ -f "$HOME/.zshrc.local" ]; then
    [ "${CHACHI_SHELL_DEBUG:-0}" = "1" ] && echo "[shell] $HOME/.zshrc.local"
    . "$HOME/.zshrc.local"
fi
