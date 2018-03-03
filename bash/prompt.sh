#!/bin/bash

prompt_user() {
  echo -e "\n: `whoami`"
}

prompt_dir() {
  echo -e "\n: `realpath $(pwd)`"
}

prompt_gits() {
  if [ -d .git ] || git rev-parse --git-dir > /dev/null 2>&1; then
    echo -e "\n: `git status -s -b | head -1 | cut -c4-100`"
  fi
}

export PS1="\[\033[35m\]\$(prompt_user) \$(prompt_dir) \$(prompt_gits) \n: \[\033[00m\]"
