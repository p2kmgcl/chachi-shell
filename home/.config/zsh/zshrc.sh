#!/bin/zsh
: "${XDG_CONFIG_HOME:=$HOME/.config}"

for _f in "$XDG_CONFIG_HOME/zsh"/[0-9]*-*.zsh; do
    if [ -f "$_f" ]; then
      . "$_f"
    fi
done

unset _f
