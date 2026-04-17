#!/usr/bin/env bash

echo_success() {
  echo -e "\e[32;1m[$1]\e[0m\e[32m $2\e[0m"
}

echo_warning() {
  echo -e "\e[33;1m[$1]\e[0m\e[33m $2\e[0m"
}

echo_error() {
  echo -e "\e[31;1m[$1]\e[0m\e[31m $2\e[0m"
}
