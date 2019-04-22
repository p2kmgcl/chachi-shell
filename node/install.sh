#!/bin/bash

if [ -f /usr/bin/npm ]; then
  npm config set prefix '~/.npm-global'
  mkdir -p ~/.npm-global
fi

npm i -g npm
npm i -g diff-so-fancy
npm i -g gradle-launcher
npm i -g gh gh-jira
