#!/bin/sh

REPO_ROOT=$(git rev-parse --show-toplevel)
FSMONITOR_SOCKET="$REPO_ROOT/.git/fsmonitor--daemon.ipc"

out=$(timeout 0.5s git status --porcelain 2>/dev/null)
code=$?

if [ $code -gt 0 ]; then
  if [ -S "$FSMONITOR_SOCKET" ]; then
    PIDS=$(lsof "$FSMONITOR_SOCKET" 2>/dev/null | awk 'NR>1 {print $2}' | sort -u)
    if [ -n "$PIDS" ]; then
      echo "$PIDS" | xargs kill -TERM 2>/dev/null
      sleep 0.1
      echo "$PIDS" | xargs kill -KILL 2>/dev/null
    fi
    rm -f "$FSMONITOR_SOCKET" 2>/dev/null
  fi

  echo "?"
elif [ -n "$out" ]; then
  echo "*"
else
  echo ""
fi
