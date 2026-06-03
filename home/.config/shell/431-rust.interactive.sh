if [ -f "$HOME/.cargo/bin/exa" ]; then
    exa_list() { exa -l "$@"; }
    exa_tree() { exa --tree "$@"; }
fi

if [ -f "$HOME/.cargo/bin/fd" ]; then
    fd_nocolor() { fd --color=never "$@"; }
fi

if [ -f "$HOME/.cargo/bin/btm" ]; then
    btm_basic() { btm --basic --theme default "$@"; }
fi

[ -f "$HOME/.cargo/bin/zoxide" ] && eval "$(zoxide init "$CURRENT_SHELL")"
[ -f "$HOME/.cargo/bin/starship" ] && eval "$(starship init "$CURRENT_SHELL")"
