#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
CONFIG_DIR="$ROOT/home/.config/sketchybar"
export CONFIG_DIR

# Exercise macOS detection without changing the machine's appearance.
defaults() {
  if [ "$APPEARANCE" = dark ]; then
    printf 'Dark\n'
  else
    return 1 # macOS removes AppleInterfaceStyle in light mode.
  fi
}

for APPEARANCE in light dark; do
  source "$CONFIG_DIR/theme.sh"
  [ "$SYSTEM_APPEARANCE" = "$APPEARANCE" ]
  if [ "$APPEARANCE" = dark ]; then
    [ "$BAR_FOREGROUND" = 0xffc9d1d9 ]
    [ "$BAR_ACCENT" = 0xff58a6ff ]
  else
    [ "$BAR_FOREGROUND" = 0xff1f2328 ]
    [ "$BAR_ACCENT" = 0xff0969da ]
  fi
done

# Reload only on transitions: unchanged polling must not rebuild workspaces.
NAME=theme_watcher
export NAME
sketchybar() {
  case "$1" in
    --query) printf '{"label":{"value":"%s"}}\n' "$PREVIOUS_APPEARANCE" ;;
    --reload) printf 'reload\n' ;;
    *) return 1 ;;
  esac
}
for APPEARANCE in light dark; do
  PREVIOUS_APPEARANCE="$APPEARANCE"
  [ "$(source "$CONFIG_DIR/plugins/theme_change.sh")" = '' ]
  if [ "$APPEARANCE" = light ]; then
    PREVIOUS_APPEARANCE=dark
  else
    PREVIOUS_APPEARANCE=light
  fi
  [ "$(source "$CONFIG_DIR/plugins/theme_change.sh")" = reload ]
done

printf 'System theme tests passed\n'
