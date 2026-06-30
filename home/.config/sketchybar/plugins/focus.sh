#!/bin/sh

FOCUS_DB="$HOME/Library/DoNotDisturb/DB/Assertions.json"

if [ ! -f "$FOCUS_DB" ]; then
  sketchybar --set "$NAME" drawing=off
  exit 0
fi

# Only read from storeAssertionRecords, not storeInvalidationRecords
MODE_ID=$(plutil -p "$FOCUS_DB" 2>/dev/null \
  | awk '/storeAssertionRecords/{found=1} /storeInvalidationRecords/{found=0} found && /assertionDetailsModeIdentifier/' \
  | head -1 \
  | sed 's/.*=> "\(.*\)"/\1/')

if [ -n "$MODE_ID" ]; then
  case "$MODE_ID" in
    com.apple.donotdisturb.mode.default)       ICON="" ;; # Do Not Disturb
    com.apple.donotdisturb.mode.bicycle)       ICON="" ;; # Coche
    com.apple.donotdisturb.mode.driving)       ICON="" ;; # Conducción
    com.apple.focus.personal-time)             ICON="󰔱" ;; # Tiempo libre
    com.apple.focus.reduce-interruptions)      ICON="󰋋" ;; # Reduce Interruptions
    com.apple.focus.work)                      ICON="" ;; # Trabajo
    com.apple.sleep.sleep-mode)                ICON="" ;; # Descanso
    *)                                         ICON="?" ;;
  esac

  sketchybar --set "$NAME" drawing=on icon="$ICON"
else
  sketchybar --set "$NAME" drawing=off
fi
