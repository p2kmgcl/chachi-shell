#!/bin/bash

sudo apt-get install -y git

cp ./bash/main.sh ~/.bashrc--main.sh
cp ./bash/aliases.sh ~/.bashrc--aliases.sh
cp ./bash/prompt.sh ~/.bashrc--prompt.sh

if [ -z "$(grep "bashrc--main.sh" ~/.bashrc)" ]; then
    echo "source ~/.bashrc--main.sh" >> ~/.bashrc
fi
