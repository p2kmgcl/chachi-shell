#!/bin/bash

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

if [ -d ~/.npm-global ]; then
  export PATH=~/.npm-global/bin:$PATH
fi

source ~/.bashrc--aliases.sh
source ~/.bashrc--prompt.sh

if [ -d ~/.z-bin ]; then
  source ~/.z-bin/z.sh
fi
