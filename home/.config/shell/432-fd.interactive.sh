if [ -f "$HOME/.cargo/bin/fd" ]; then
    fd_nocolor() { fd --color=never "$@"; }
fi
