if status is-interactive
  export DENO_INSTALL="$HOME/.deno"

  fish_add_path $HOME/.fnm
  fish_add_path $HOME/.deno/bin
  fnm env --use-on-cd | source
end
