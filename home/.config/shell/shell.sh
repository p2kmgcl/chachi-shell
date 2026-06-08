#!/bin/sh
: "${XDG_CONFIG_HOME:=$HOME/.config}"
export XDG_CONFIG_HOME

for _f in "$XDG_CONFIG_HOME/shell"/[0-9]*-*.sh; do
  case "$_f" in
  *.interactive.sh | *.interactive.*.sh) ;;
  *)
    if [ -f "$_f" ]; then
      . "$_f"
    fi
    ;;
  esac
done

unset _f
