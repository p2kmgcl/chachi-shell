#!/bin/bash

echo Copying bash scripts
cp ./bash/main.sh ~/.bashrc--main.sh
cp ./bash/aliases.sh ~/.bashrc--aliases.sh
cp ./bash/liferay.sh ~/.bashrc--liferay.sh
cp ./bash/prompt.sh ~/.bashrc--prompt.sh
cp ./bash/pending.sh ~/.bashrc--pending.sh

mkdir -p ~/.bashrc--pending-tasks

if [ -z "$(grep "bashrc--main.sh" ~/.bashrc)" ]; then
    echo "\
    source ~/.bashrc--main.sh" >> ~/.bashrc
fi
