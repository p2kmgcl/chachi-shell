#!/bin/bash

echo Updating repositories
curl -sL https://deb.nodesource.com/setup_10.x | sudo -E bash -
sudo apt-get -q -y update
sudo apt-get install -q -y cmake git git-extras vim vim-gtk wget build-essential cmake nodejs python3-dev python-dev terminator
clear

./bash/install.sh
./editorconfig/install.sh
./fzf/install.sh
./git/install.sh
./node/install.sh
./ripgrep/install.sh
./vim/install.sh

echo ""
echo "done ('source ~/.bashrc' needed)"
