#!/bin/bash

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

source ~/.bashrc--aliases.sh
source ~/.bashrc--prompt.sh

if [ -d ~/.z-bin ]; then
  source ~/.z-bin/z.sh
fi
