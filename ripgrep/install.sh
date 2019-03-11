#!/bin/bash

if [ ! -f /usr/bin/rg ]; then
  curl -LO https://github.com/BurntSushi/ripgrep/releases/download/0.10.0/ripgrep_0.10.0_amd64.deb
  sudo dpkg -i ripgrep_0.10.0_amd64.deb
  rm ripgrep_0.10.0_amd64.deb
fi
