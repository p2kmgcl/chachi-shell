#!/bin/bash

function main() {
  mkdir -p ./.bashrc--pending-tasks

  for f in $(ls ./.bashrc--pending-tasks)
  do
    bash "./.bashrc--pending-tasks/${f}"
  done

  rm -rf ./.bashrc--pending-tasks
  mkdir -p ./.bashrc--pending-tasks
}

cd ~ && main
