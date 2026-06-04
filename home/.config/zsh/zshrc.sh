#!/bin/zsh
: "${XDG_CONFIG_HOME:=$HOME/.config}"

for _f in "$XDG_CONFIG_HOME/zsh"/[0-9]*-*.zsh; do
    [ -f "$_f" ] || continue
    [ "${CHACHI_SHELL_DEBUG:-0}" = "1" ] && echo "[zsh] $_f"
    . "$_f"
done

unset _f
