#!/bin/bash

echo Copying Google Fonts

if [ ! -d /usr/share/fonts/truetype/google-fonts ]; then
  git clone -q git@github.com:google/fonts.git /tmp/google-fonts
  sudo mkdir -p /usr/share/fonts/truetype/google-fonts
  sudo cp /tmp/google-fonts/ofl/inconsolata/*.ttf /usr/share/fonts/truetype/google-fonts/
  sudo rm -r /tmp/google-fonts
fi
