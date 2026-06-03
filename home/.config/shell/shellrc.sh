#!/bin/sh
# Non-interactive env is expected to already be loaded via shell.sh (login shell).
: "${XDG_CONFIG_HOME:=$HOME/.config}"
export XDG_CONFIG_HOME

for _f in "$XDG_CONFIG_HOME/shell"/[0-9]*-*interactive*.sh; do
    [ -f "$_f" ] || continue
    [ "${CHACHI_SHELL_DEBUG:-0}" = "1" ] && echo "[shell] $_f"
    . "$_f"
done

unset _f
