#!/bin/bash

echo Updating repositories
sudo apt-get -q -y update
sudo apt-get install -q -y cmake git git-extras vim vim-gtk wget build-essential cmake python3-dev python-dev
sudo pacman -Syy bat base-devel cmake git ttf-anonymous-pro ttf-fira-code ttf-fira-mono ttf-fira-sans vim wget
clear

./bash/install.sh
./editorconfig/install.sh
./fzf/install.sh
./git/install.sh
./npm/install.sh
./ripgrep/install.sh
./vim/install.sh

echo ""
echo "done ('source ~/.bashrc' needed)"
