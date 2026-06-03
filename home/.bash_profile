[ "${CHACHI_SHELL_DEBUG:-0}" = "1" ] && echo "[shell] $HOME/.bash_profile"
[ -f "${XDG_CONFIG_HOME:-$HOME/.config}/shell/shell.sh" ] && . "${XDG_CONFIG_HOME:-$HOME/.config}/shell/shell.sh"
[[ -f ~/.bashrc ]] && . ~/.bashrc
