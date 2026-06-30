#!/usr/bin/env bash

# make sure it's executable with:
# chmod +x ~/.config/sketchybar/plugins/aerospace.sh

source "$CONFIG_DIR/variables.sh"

WS="$1"
FOCUSED="${FOCUSED_WORKSPACE:-$(aerospace list-workspaces --focused 2>/dev/null)}"

WINDOWS=$(aerospace list-windows --workspace "$WS" 2>/dev/null | wc -l | tr -d ' ')

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
        "Appgate SDP") echo "󰊙" ;;
        "Claude") echo "󰚩" ;;
        "Codex") echo "󰚩" ;;
        "Finder") echo "󰀶" ;;
        "Ghostty"|"Terminal"|"iTerm2"|"Alacritty"|"WezTerm") echo "" ;;
        "Google Chrome"|"Chrome") echo "" ;;
        "Obsidian") echo "" ;;
        "Orion") echo "󰣘" ;;
        "Safari") echo "" ;;
        "zoom.us") echo "󰤙" ;;
        "Visual Studio Code"|"Code") echo "" ;;
        "Cursor") echo "" ;;
        "Zed") echo "" ;;
        "Slack") echo "" ;;
        "Discord") echo "" ;;
        "Spotify") echo "" ;;
        "Mail") echo "" ;;
        "Calendar") echo "" ;;
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
    done < <(aerospace list-windows --workspace "$WS" --format '%{app-name}|%{window-title}' 2>/dev/null | sort -u)
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
