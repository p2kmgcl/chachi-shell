[ "${CHACHI_SHELL_DEBUG:-0}" = "1" ] && echo "[shell] $HOME/.zprofile"
if [ -f "$HOME/.zprofile.local" ]; then
    [ "${CHACHI_SHELL_DEBUG:-0}" = "1" ] && echo "[shell] $HOME/.zprofile.local"
    . "$HOME/.zprofile.local"
fi
