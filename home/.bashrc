# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# Do not customize root
[[ "$(whoami)" = "root" ]] && return

# limits recursive functions, see 'man bash'
[[ -z "$FUNCNEST" ]] && export FUNCNEST=100

## Use the up and down arrow keys for finding a command in history
## (you can write some initial letters of the command first).
bind '"\e[A":history-search-backward'
bind '"\e[B":history-search-forward'

if [ -f "$HOME/.bashrc.local" ]; then
    source "$HOME/.bashrc.local"
fi
