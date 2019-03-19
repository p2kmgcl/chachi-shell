#!/bin/bash

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

export FZF_DEFAULT_COMMAND='rg --color=never --files --glob "!.git/*,!.gradle/*,!.hg/*,!.sass-cache/*,!.svn/*,!bower_components/*,!build/*,!classes/*,!CVS/*,!node_modules/*,!tmp/*"'
export FZF_DEFAULT_OPTS='--color=bw'

if [ -d ~/.npm-global ]; then
  export PATH=~/.npm-global/bin:$PATH
fi

source ~/.bashrc--aliases.sh
source ~/.bashrc--liferay.sh
source ~/.bashrc--prompt.sh
source ~/.bashrc--pending.sh
