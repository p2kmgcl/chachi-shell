#!/bin/bash

curl -sL https://deb.nodesource.com/setup_10.x | sudo -E bash -
sudo apt-get -q -y update
sudo apt-get install -q -y cmake git git-extras vim vim-gtk wget build-essential cmake nodejs python3-dev python-dev
clear

if [ -f /usr/bin/npm ]; then
  npm config set prefix $HOME/.npm-global
  mkdir -p $HOME/.npm-global
fi

npm i -g npm

for installFile in `find $HOME/chachi-shell -mindepth 2 -maxdepth 2 -name "install.sh"`; do
  echo $installFile
  $installFile
done

echo "done"
