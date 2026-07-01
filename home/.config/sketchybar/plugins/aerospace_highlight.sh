#!/usr/bin/env bash

# Fast path for focus changes: only recolor the workspace you left and the one
# you entered, instead of rebuilding all workspaces' icons. A focus change
# never changes any workspace's window contents, so no full icon rebuild (and
# no per-workspace `aerospace list-windows` sweep) is needed here.
#
# FOCUSED_WORKSPACE / PREV_WORKSPACE are passed by aerospace's
# exec-on-workspace-change trigger. Icon rebuilds are driven separately by the
# aerospace_windows_change event (see sketchybarrc).

source "$CONFIG_DIR/variables.sh"

FOCUSED="${FOCUSED_WORKSPACE:-$(aerospace list-workspaces --focused 2>/dev/null)}"
PREV="$PREV_WORKSPACE"

# Newly focused workspace: accent blue, always drawn. Label (number + icons) is
# already set, so leave it untouched — focus doesn't change window contents.
if [ -n "$FOCUSED" ]; then
    sketchybar --set "space.$FOCUSED" \
        drawing=on \
        background.color=0xff1f6feb \
        label.color=0xffffffff \
        label.font="$FONT_BOLD"
fi

# Previously focused workspace: revert to neutral if it still has windows, or
# hide it if it's now empty. This is the only query we need, and only for one
# workspace.
if [ -n "$PREV" ] && [ "$PREV" != "$FOCUSED" ]; then
    WINDOWS=$(aerospace list-windows --workspace "$PREV" 2>/dev/null | wc -l | tr -d ' ')
    if [ "$WINDOWS" -gt 0 ]; then
        sketchybar --set "space.$PREV" \
            drawing=on \
            background.color=0xcc3d444d \
            label.color=0xfff0f6fc \
            label.font="$FONT_REGULAR"
    else
        sketchybar --set "space.$PREV" drawing=off
    fi
fi
