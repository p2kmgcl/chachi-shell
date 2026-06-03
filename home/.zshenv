[ "${CHACHI_SHELL_DEBUG:-0}" = "1" ] && echo "[shell] $HOME/.zshenv"
[ -f "${XDG_CONFIG_HOME:-$HOME/.config}/shell/shell.sh" ] && . "${XDG_CONFIG_HOME:-$HOME/.config}/shell/shell.sh"
if [ -f "$HOME/.zshenv.local" ]; then
    [ "${CHACHI_SHELL_DEBUG:-0}" = "1" ] && echo "[shell] $HOME/.zshenv.local"
    . "$HOME/.zshenv.local"
fi
