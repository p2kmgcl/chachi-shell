if status is-interactive
  export EDITOR='nvim'

  export FZF_DEFAULT_COMMAND='rg --color=never --files --glob "!.git/*,!.gradle/*,!.hg/*,!.sass-cache/*,!.svn/*,!bower_components/*,!build/*,!classes/*,!CVS/*,!node_modules/*,!tmp/*"'
  export FZF_DEFAULT_OPTS='--color=bw'

  fish_add_path $HOME/.local/bin
  fish_add_path $CHACHI_PATH/home/.bin
end
