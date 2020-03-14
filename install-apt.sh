#!/bin/bash

if hash ansible 2>/dev/null; then
  echo Ansible already installed
else
  echo Installing ansible
  sudo apt-get update -y
  sudo apt-get install -y software-properties-common curl git
  sudo apt-add-repository -y ppa:ansible/ansible
  sudo apt-get update -y
  sudo apt-get install ansible
fi
