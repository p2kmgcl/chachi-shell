#!/bin/sh
# Canonicalise XDG_CONFIG_HOME once so all downstream tools see a consistent value
: "${XDG_CONFIG_HOME:=$HOME/.config}"
export XDG_CONFIG_HOME

for _f in "$XDG_CONFIG_HOME/shell"/[0-9]*-*.sh; do
    case "$_f" in
        *.interactive.sh|*.interactive.*.sh) ;;
        *)
            [ -f "$_f" ] || continue
            [ "${CHACHI_SHELL_DEBUG:-0}" = "1" ] && echo "[shell] $_f"
            . "$_f"
            ;;
    esac
done

unset _f
