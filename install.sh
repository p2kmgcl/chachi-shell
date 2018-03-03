#!/bin/bash

sudo apt-get update

./bash/install.sh
./editorconfig/install.sh
./git/install.sh
./vim/install.sh

echo "'source ~/.bashrc' needed"
