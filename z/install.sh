#!/bin/bash

echo Installing z

if [ ! -d ~/.z-bin ]; then
  git clone -q git@github.com:rupa/z.git ~/.z-bin
fi

chmod +x ~/.z-bin/z.sh
