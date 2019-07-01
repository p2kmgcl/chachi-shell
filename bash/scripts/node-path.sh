#!/bin/bash

if [ -d ~/.npm-global ]; then
  export PATH=$HOME/.npm-global/bin:$PATH
fi
