#!/bin/bash

if hash ansible 2>/dev/null; then
  echo Ansible already installed
else
  echo Installing ansible
  sudo apt-get update -y 1> /dev/null
  sudo apt-get install -y software-properties-common curl git 1> /dev/null
  sudo apt-add-repository -y ppa:ansible/ansible 1> /dev/null
  sudo apt-get update -y 1> /dev/null
fi
