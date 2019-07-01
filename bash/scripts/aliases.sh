#!/bin/bash

export FZF_DEFAULT_COMMAND='rg --color=never --files'

if [ ! -f "/tmp/FZF_RESULTS" ]; then
  echo "`find $HOME -maxdepth 1 -type d -not -path '*/\.*'`" >> /tmp/FZF_RESULTS
  echo "`find $HOME/Projects -maxdepth 1 -type d`" >> /tmp/FZF_RESULTS
  echo "`find $HOME/Projects/community-portal/liferay-portal/modules/apps/ -maxdepth 4 -type f -name "bnd.bnd" -printf "echo %p | rev | cut -c 9- | rev \n" | sh`" >> /tmp/FZF_RESULTS
fi

export FZF_RESULTS=`cat /tmp/FZF_RESULTS`

alias ..='cd ..'
alias cdd='cd $(echo "$FZF_RESULTS" | fzf --color=16)'
alias ls='ls --color=auto'
alias ll='ls --color=auto -lh'
alias lla='ls --color=auto -lha'
alias serve='python3 -m http.server 8080'
