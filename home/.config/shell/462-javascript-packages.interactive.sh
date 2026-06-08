[ -d "$HOME/.volta" ] || return 0

for _pkg_bin in "neovim:nvim" "typescript:tsc"; do
  _pkg="${_pkg_bin%%:*}"
  _bin="${_pkg_bin##*:}"
  if ! command -v "$_bin" >/dev/null 2>&1; then
    echo "Installing missing NPM package $_pkg"
    npm install -g "$_pkg"
  fi
done

unset _pkg_bin _pkg _bin
