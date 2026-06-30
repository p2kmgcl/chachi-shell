#!/bin/sh

LOG=/tmp/sketchybar-calendar.log
log() { echo "$(date '+%H:%M:%S') $*" >> "$LOG"; }

LABEL=$(swift "$HOME/.config/sketchybar/plugins/calendar_events.swift" 2>/dev/null)

log "label='$LABEL'"

if [ -n "$LABEL" ]; then
  sketchybar --set "$NAME" label="$LABEL" drawing=on
else
  sketchybar --set "$NAME" drawing=off
fi
