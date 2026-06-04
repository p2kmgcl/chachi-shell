if [ -f "$HOME/.cargo/bin/btm" ]; then
    btm_basic() { btm --basic --theme default "$@"; }
fi
