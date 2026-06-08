#!/bin/sh
: "${XDG_CONFIG_HOME:=$HOME/.config}"
export XDG_CONFIG_HOME

for _f in "$XDG_CONFIG_HOME/shell"/[0-9]*-*interactive*.sh; do
  if [ -f "$_f" ]; then
    . "$_f"
  fi
done

unset _f
