#!/bin/sh

# The $NAME variable is passed from sketchybar and holds the name of
# the item invoking this script:
# https://felixkratz.github.io/SketchyBar/config/events#events-and-scripting

DAY=$(date '+%-d')
case $DAY in
  1|21|31) SUFFIX="st" ;;
  2|22)    SUFFIX="nd" ;;
  3|23)    SUFFIX="rd" ;;
  *)       SUFFIX="th" ;;
esac
LABEL="$(date '+%A') $(date '+%B') ${DAY}${SUFFIX} $(date '+%H:%M')"
sketchybar --set "$NAME" label="$LABEL"

