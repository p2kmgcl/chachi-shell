if status is-interactive
  if test -f "$(which tmux)" -a -z "$TMUX"
    exec tmux new-session && exit 0
  end
end
