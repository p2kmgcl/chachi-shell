#!/bin/bash

export FZF_DEFAULT_COMMAND='rg --color=never --files'

alias ..='cd ..'
alias f="${FZF_DEFAULT_COMMAND} --null ~ | xargs -0 dirname | sort -u | fzf --color=16"
alias ls='ls --color=auto'
alias ll='ls --color=auto -lh'
alias lla='ls --color=auto -lha'
alias serve='python3 -m http.server 8080'
