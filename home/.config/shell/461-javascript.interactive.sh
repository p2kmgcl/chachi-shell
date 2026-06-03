[ -d "$HOME/.volta" ] && alias man='npx -y tldr'

[ -d "$HOME/.volta" ] || echo "volta is not installed"
[ -f "$HOME/.deno/bin/deno" ] || echo "deno is not installed"
