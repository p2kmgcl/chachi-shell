if status is-interactive
   if test -f "$(which tmux)" -a -z "$TMUX"
       exec tmux new-session -A -s chachi-shell && exit 0
   end
end
