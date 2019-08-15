#!/bin/bash

prompt_newline() {
  echo -e '\n'
}

prompt_user() {
  echo -e " `whoami`"
}

prompt_dir() {
  echo -e " `realpath $(pwd)`"
}

prompt_gits() {
  if [ -d .git ] || git rev-parse --git-dir > /dev/null 2>&1; then
    echo -e " (`git branch | grep \* | cut -d ' ' -f2`)"
  fi
}

export PS1="\[\033[1;34m\]\$(prompt_newline):\$(prompt_gits)\$(prompt_dir)\n: \[\033[00m\]"
