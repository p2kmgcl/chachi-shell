#!/bin/bash

echo Updating repositories
sudo apt-get -q -y update
sudo apt-get install -q -y git git-extras vim vim-gtk wget build-essential cmake powerline-fonts python3-dev python-dev
sudo pacman -Syy base-devel cmake git vim wget
yaourt -Syy powerline-fonts-git
clear

./bash/install.sh
./editorconfig/install.sh
./git/install.sh
./npm/install.sh
./vim/install.sh
./z/install.sh

echo ""
echo "done ('source ~/.bashrc' needed)"
