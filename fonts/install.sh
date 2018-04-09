#!/bin/bash

echo Copying Fira Code font

if [ ! -d /usr/share/fonts/truetype/fira-code ]; then
  git clone -q git@github.com:tonsky/FiraCode.git /tmp/fira-code
  sudo mkdir -p /usr/share/fonts/truetype/fira-code
  sudo cp /tmp/fira-code/distr/ttf/* /usr/share/fonts/truetype/fira-code/
  sudo rm -r /tmp/fira-code/distr/ttf/
fi
