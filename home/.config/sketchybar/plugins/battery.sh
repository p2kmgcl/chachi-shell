#!/bin/sh

BATT="$(pmset -g batt)"
PMSET="$(pmset -g)"
PERCENTAGE="$(echo "$BATT" | grep -Eo "\d+%" | cut -d% -f1)"
CHARGING="$(echo "$BATT" | grep 'AC Power')"
POWER_MODE="$(echo "$PMSET" | grep -w powermode | awk '{print $2}')"

if [ "$PERCENTAGE" = "" ]; then
  exit 0
fi

case "${PERCENTAGE}" in
  9[0-9]|100) ICON=""   ;;
  [6-8][0-9]) ICON=""   ;;
  [3-5][0-9]) ICON=""    ;;
  [1-2][0-9]) ICON=""    ;;
  *)           ICON="" ;;
esac

if [[ "$CHARGING" != "" ]]; then
  ICON=""
fi

# Icon color by energy mode
# 0 = Automatic, 1 = Low Power, 2 = High Power
case "$POWER_MODE" in
  1) COLOR=0xff9a6700 ;; # attention         — Low Power
  2) COLOR=0xff0969da ;; # accent blue       — High Power
  *) COLOR=0xff1f2328 ;; # default foreground — Automatic
esac

# Success blue when charging in automatic mode
if [[ "$CHARGING" != "" ]] && [ "$POWER_MODE" = "0" ]; then
  COLOR=0xff0969da
fi

sketchybar --set "$NAME" icon="$ICON" icon.color="$COLOR" label="${PERCENTAGE}%"
