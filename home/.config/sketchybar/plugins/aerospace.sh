#!/usr/bin/env bash

# make sure it's executable with:
# chmod +x ~/.config/sketchybar/plugins/aerospace.sh

source "$CONFIG_DIR/variables.sh"

WS="$1"
FOCUSED="${FOCUSED_WORKSPACE:-$(aerospace list-workspaces --focused 2>/dev/null)}"

# Query windows once and reuse for both the count and the icon list. Each
# aerospace CLI call is a round-trip to the server, so avoid doing it twice.
WINDOW_LIST=$(aerospace list-windows --workspace "$WS" --format '%{app-name}|%{window-title}' 2>/dev/null | sort -u)
if [ -n "$WINDOW_LIST" ]; then
    WINDOWS=$(printf '%s\n' "$WINDOW_LIST" | wc -l | tr -d ' ')
else
    WINDOWS=0
fi

app_icon() {
    local app="$1"
    local title="$2"
    case "$app" in
        "OrionWebApp")
            case "$title" in
                *WhatsApp*) echo "" ;;
                *Telegram*) echo "" ;;
                *) echo "󰾔" ;;
            esac
            ;;
        "Appgate SDP") echo "" ;;
        "Codex") echo "󰚩" ;;
        "Finder") echo "" ;;
        "Ghostty") echo "" ;;
        "Google Chrome"|"Chrome") echo "" ;;
        "Obsidian") echo "" ;;
        "Orion") echo "" ;;
        "Safari") echo "" ;;
        "zoom.us") echo "󰤙" ;;
        "Visual Studio Code"|"Code") echo "󰨞" ;;
        "Cursor") echo "󰨞" ;;
        "Zed") echo "󱃖" ;;
        "Slack") echo "" ;;
        "Discord") echo "" ;;
        "Spotify") echo "" ;;
        "Mail") echo "󰶊" ;;
        "Calendar") echo "" ;;
        "Notes") echo "" ;;
        "Messages") echo "" ;;
        "Telegram") echo "" ;;
        "1Password 7"|"1Password") echo "󰌾" ;;
        "Music") echo "" ;;
        "Figma") echo "" ;;
        *) echo "󰣆" ;;
    esac
}

APP_ICONS=""
if [ "$WINDOWS" -gt 0 ]; then
    declare -A seen
    while IFS='|' read -r app title; do
        [ -z "$app" ] && continue
        icon=$(app_icon "$app" "$title")
        [ "${seen[$icon]+_}" ] && continue
        seen[$icon]=1
        APP_ICONS="$APP_ICONS $icon"
    done < <(printf '%s\n' "$WINDOW_LIST")
fi

if [ -n "$APP_ICONS" ]; then
    LABEL="$WS$APP_ICONS"
else
    LABEL="$WS"
fi

# github-colorblind palette — see docs/colorschemes/github-colorblind.md
# focused = accent emphasis (blue), occupied = neutral, empty = muted fg
if [ "$WS" = "$FOCUSED" ]; then
    sketchybar --set "$NAME" \
        drawing=on \
        label="$LABEL" \
        background.color=0xff1f6feb \
        label.color=0xffffffff \
        label.font="$FONT_BOLD"
elif [ "$WINDOWS" -gt 0 ]; then
    sketchybar --set "$NAME" \
        drawing=on \
        label="$LABEL" \
        background.color=0xcc3d444d \
        label.color=0xfff0f6fc \
        label.font="$FONT_REGULAR"
else
    sketchybar --set "$NAME" drawing=off
fi
