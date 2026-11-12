#!/usr/bin/env bash

source "$CONFIG_DIR/theme.sh"
PREVIOUS_APPEARANCE=$(sketchybar --query "$NAME" | jq -r '.label.value')
if [ "$SYSTEM_APPEARANCE" != "$PREVIOUS_APPEARANCE" ]; then
  sketchybar --reload
fi
