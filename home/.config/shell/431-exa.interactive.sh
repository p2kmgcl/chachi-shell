if [ -f "$HOME/.cargo/bin/exa" ]; then
  exa_list() { exa -l "$@"; }
  exa_tree() { exa --tree "$@"; }
fi
