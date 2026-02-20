#!/bin/bash
input=$(cat)

MODEL=$(echo "$input"  | jq -r '.model.display_name // "Claude"')
CWD=$(echo "$input"   | jq -r '.workspace.current_dir // .cwd // "."')
COST=$(echo "$input"  | jq -r '.cost.total_cost_usd // 0')
PCT=$(echo "$input"   | jq -r '.context_window.used_percentage // 0')
DUR=$(echo "$input"   | jq -r '.cost.total_duration_ms // 0')

CYAN='\033[36m'; YELLOW='\033[33m'; GREEN='\033[32m'; RESET='\033[0m'

PROJECT="${CWD##*/}"
BRANCH=$(git -C "$CWD" branch --show-current 2>/dev/null)

LINE1="${CYAN}[${MODEL}]${RESET} 🗂  ${PROJECT}"
[ -n "$BRANCH" ] && LINE1="${LINE1} | 🌿 ${BRANCH}"

BAR_W=20
FILLED=$(( (PCT * BAR_W) / 100 ))
EMPTY=$(( BAR_W - FILLED ))
FILLED_BAR=$(printf '%0.s█' $(seq 1 $FILLED) 2>/dev/null || true)
EMPTY_BAR=$(printf '%0.s░' $(seq 1 $EMPTY) 2>/dev/null || true)

MINS=$(( DUR / 60000 ))
SECS=$(( (DUR % 60000) / 1000 ))
COST_FMT=$(printf '$%.2f' "$COST")

LINE2="${GREEN}${FILLED_BAR}${RESET}${EMPTY_BAR} ${PCT}% | ${YELLOW}${COST_FMT}${RESET} | ⏱ ${MINS}m ${SECS}s"

echo -e "$LINE1"
echo -e "$LINE2"
