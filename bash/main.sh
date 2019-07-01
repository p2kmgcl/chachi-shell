#!/bin/bash

[[ $- != *i* ]] && return

for bashrcFile in `ls $HOME/chachi-shell/bash/scripts`; do
  source $HOME/chachi-shell/bash/scripts/$bashrcFile
done
