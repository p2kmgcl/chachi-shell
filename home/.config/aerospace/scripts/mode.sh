#!/usr/bin/env sh

mode="$1"
aerospace mode "$mode"

case "$1" in
  main)
    aerospace mode main
    sketchybar --set aerospace_mode icon="󱗃" label="normal"
    ;;
  resize)
    aerospace mode resize
    sketchybar --set aerospace_mode icon="󰤼" label="resize"
    ;;
  service)
    aerospace mode service
    sketchybar --set aerospace_mode icon="" label="service"
    ;;
  *)
    exit 1
    ;;
esac
