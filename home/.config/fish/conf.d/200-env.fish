if status is-interactive
  set -U EDITOR nvim

  set -U FZF_DEFAULT_COMMAND 'rg --color=never --files --glob "!.git/*,!.gradle/*,!.hg/*,!.sass-cache/*,!.svn/*,!bower_components/*,!build/*,!classes/*,!CVS/*,!node_modules/*,!tmp/*"'
  set -U FZF_DEFAULT_OPTS '--color=bw'

  fish_add_path $HOME/.local/bin
  fish_add_path $CHACHI_PATH/home/.bin
end
