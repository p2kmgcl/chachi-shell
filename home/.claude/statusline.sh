#!/bin/bash
input=$(cat)

MODEL=$(echo "$input" | jq -r '.model.display_name // "Claude"')
CWD=$(echo "$input" | jq -r '.workspace.current_dir // .cwd // "."')
COST=$(echo "$input" | jq -r '.cost.total_cost_usd // 0')
TRANSCRIPT=$(echo "$input" | jq -r '.transcript_path // ""')

PROJECT="${CWD##*/}"
BRANCH=$(git -C "$CWD" branch --show-current 2>/dev/null)

USED=0
if [ -f "$TRANSCRIPT" ]; then
  USED=$(tac "$TRANSCRIPT" | jq -r 'select(.message.usage) | .message.usage | (.input_tokens + (.cache_creation_input_tokens // 0) + (.cache_read_input_tokens // 0))' 2>/dev/null | head -1)
  [ -z "$USED" ] && USED=0
fi

fmt_tok() { awk -v n="$1" 'BEGIN{ if(n>=1000000)printf "%.1fM",n/1000000; else if(n>=1000)printf "%.1fk",n/1000; else printf "%d",n }'; }
USED_FMT=$(fmt_tok "$USED")
COST_FMT=$(printf '$%.2f' "$COST")

OUT="${PROJECT}"
[ -n "$BRANCH" ] && OUT="${OUT} | ${BRANCH}"
OUT="${OUT} | ${USED_FMT} | ${MODEL} | ${COST_FMT}"

echo "$OUT"
