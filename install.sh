#!/bin/bash

echo Updating repositories
sudo apt-get -q -y update
sudo apt-get install -q -y bat git git-extras vim vim-gtk wget build-essential cmake powerline-fonts python3-dev python-dev
sudo pacman -Syy bat base-devel cmake git ttf-anonymous-pro ttf-fira-code ttf-fira-mono ttf-fira-sans vim wget
clear

./bash/install.sh
./editorconfig/install.sh
./git/install.sh
./npm/install.sh
./vim/install.sh
./z/install.sh

echo ""
echo "done ('source ~/.bashrc' needed)"
