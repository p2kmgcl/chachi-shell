if status is-interactive
  set -U DENO_INSTALL "$HOME/.deno"

  fish_add_path $HOME/.fnm
  fnm env --use-on-cd | source
end
