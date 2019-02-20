#!/bin/bash

export FZF_DEFAULT_COMMAND='rg --color=never --files --glob "!.git/*,!.gradle/*,!.hg/*,!.sass-cache/*,!.svn/*,!bower_components/*,!build/*,!classes/*,!CVS/*,!node_modules/*,!tmp/*"'

function cdd() {
  DIR=$(rg --color=never --files --null --glob '!{.git,.gradle,.hg,.sass-cache,.svn,bower_components,build,classes,CVS,node_modules,tmp}/*' ~ | xargs -0 dirname | sort -u | fzf)
  echo $DIR
  cd $DIR
}

alias ls='ls --color=auto'
alias ll='ls --color=auto -lh'
alias lla='ls --color=auto -lha'
alias ..='cd ..'
alias serve='python -m http.server 8080'
