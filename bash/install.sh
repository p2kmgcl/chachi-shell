#!/bin/bash

ln -sf $HOME/chachi-shell/bash/main.sh $HOME/.bashrc--main.sh

if [ ! -d $HOME/.fzf ]; then
  git clone --depth 1 https://github.com/junegunn/fzf.git $HOME/.fzf
  $HOME/.fzf/install --all
fi

if [ ! -f /usr/bin/rg ]; then
  curl -LO https://github.com/BurntSushi/ripgrep/releases/download/0.10.0/ripgrep_0.10.0_amd64.deb
  sudo dpkg -i ripgrep_0.10.0_amd64.deb
  rm ripgrep_0.10.0_amd64.deb
fi

if [ -z "$(grep "bashrc--main.sh" ~/.bashrc)" ]; then
    echo "" >> $HOME/.bashrc
    echo "source $HOME/.bashrc--main.sh" >> $HOME/.bashrc
fi
