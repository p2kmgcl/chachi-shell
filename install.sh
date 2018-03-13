#!/bin/bash

echo Updating repositories
sudo apt-get -q -y update
sudo apt-get install -q -y git vim wget build-essential cmake python3-dev python-dev
clear

./bash/install.sh
./editorconfig/install.sh
./git/install.sh
./vim/install.sh
./z/install.sh

echo ""
echo "done ('source ~/.bashrc' needed)"
