#!/usr/bin/env bash

# make sure it's executable with:
# chmod +x ~/.config/sketchybar/plugins/aerospace.sh

FOCUSED="$FOCUSED_WORKSPACE"
WS="$1"

WINDOWS=$(aerospace list-windows --workspace "$WS" 2>/dev/null | wc -l | tr -d ' ')

# github-colorblind palette — see docs/colorschemes/github-colorblind.md
# focused = accent emphasis (blue), occupied = neutral, empty = muted fg
if [ "$WS" = "$FOCUSED" ]; then
    sketchybar --set "$NAME" \
        background.drawing=on \
        background.color=0xff1f6feb \
        label.color=0xffffffff \
        label.font="Maple Mono NF CN:Bold:14.0"
elif [ "$WINDOWS" -gt 0 ]; then
    sketchybar --set "$NAME" \
        background.drawing=on \
        background.color=0x44f0f6fc \
        label.color=0xfff0f6fc \
        label.font="Maple Mono NF CN:Regular:14.0"
else
    sketchybar --set "$NAME" \
        background.drawing=off \
        label.color=0x66f0f6fc \
        label.font="Maple Mono NF CN:Regular:14.0"
fi
