[ "${CHACHI_SHELL_DEBUG:-0}" = "1" ] && echo "[shell] $HOME/.bashrc"
[ -f "${XDG_CONFIG_HOME:-$HOME/.config}/shell/shellrc.sh" ] && . "${XDG_CONFIG_HOME:-$HOME/.config}/shell/shellrc.sh"
if [ -f "$HOME/.bashrc.local" ]; then
    [ "${CHACHI_SHELL_DEBUG:-0}" = "1" ] && echo "[shell] $HOME/.bashrc.local"
    . "$HOME/.bashrc.local"
fi
