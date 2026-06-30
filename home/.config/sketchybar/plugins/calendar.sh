#!/bin/sh

ICAL=/opt/homebrew/bin/icalBuddy

# All-day events today
ALLDAY=$("$ICAL" -b "" -nc -iep "title,datetime" eventsFrom:today to:today 2>/dev/null | \
  awk 'NR%2==1{title=$0} NR%2==0 && !/at [0-9]/{print title}' | \
  sed 's/^[[:space:]]*//;s/[[:space:]]*$//' | \
  awk 'NR==1{s=$0} NR>1{s=s"・"$0} END{print s}')

# Current ongoing timed event
TIMED=""
CURRENT=$("$ICAL" -li 1 -b "" -nc -iep "title,datetime" -tf "%H:%M" -ea eventsFrom:now to:now 2>/dev/null)
if [ -n "$CURRENT" ]; then
  TITLE=$(echo "$CURRENT" | sed -n '1p' | sed 's/^[[:space:]]*//;s/[[:space:]]*$//')
  TIMES=$(echo "$CURRENT" | sed -n '2p' | grep -oE '[0-9]{2}:[0-9]{2} - [0-9]{2}:[0-9]{2}' | sed 's/ - /-/')
  TIMED="$TITLE  $TIMES"
else
  # Next timed event today
  NEXT=$("$ICAL" -li 1 -b "" -nc -iep "title,datetime" -tf "%H:%M" -ea eventsFrom:now to:today 2>/dev/null)
  if [ -n "$NEXT" ]; then
    TITLE=$(echo "$NEXT" | sed -n '1p' | sed 's/^[[:space:]]*//;s/[[:space:]]*$//')
    START=$(echo "$NEXT" | sed -n '2p' | grep -oE '[0-9]{2}:[0-9]{2}' | head -1)
    TIMED="@ $START  $TITLE"
  fi
fi

# Combine
SEP="・"

if [ -n "$ALLDAY" ] && [ -n "$TIMED" ]; then
  LABEL="$ALLDAY$SEP$TIMED"
elif [ -n "$ALLDAY" ]; then
  LABEL="$ALLDAY"
elif [ -n "$TIMED" ]; then
  LABEL="$TIMED"
fi

if [ -n "$LABEL" ]; then
  sketchybar --set "$NAME" label="$LABEL" drawing=on
else
  sketchybar --set "$NAME" drawing=off
fi
