#!/usr/bin/env bash

STATE_FILE="/tmp/sketchybar_monitor_count"
MONITOR_COUNT=$(aerospace list-monitors | wc -l | tr -d ' ')

PREV_COUNT=$(cat "$STATE_FILE" 2>/dev/null)
[ "$MONITOR_COUNT" = "$PREV_COUNT" ] && exit 0

echo "$MONITOR_COUNT" > "$STATE_FILE"

while IFS='|' read -r sid monitor_id sketchybar_display; do
    case "$sid" in
        1|2|3|4|A|B|C|D) ;;
        *) continue ;;
    esac

    if [ "$MONITOR_COUNT" -gt 1 ]; then
        display_val="$sketchybar_display"
    else
        display_val=1
    fi

    sketchybar --set "space.$sid" display="$display_val"
done < <(aerospace list-workspaces --all --format '%{workspace}|%{monitor-id}|%{monitor-appkit-nsscreen-screens-id}')
