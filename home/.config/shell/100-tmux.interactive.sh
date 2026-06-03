if command -v tmux >/dev/null 2>&1 && [ -z "$TMUX" ]; then
    exec tmux new-session -A -s chachi-shell
fi
