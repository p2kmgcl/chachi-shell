#!/bin/bash

mkdir -p $HOME/.vim/bundle
mkdir -p $HOME/.vim/autoload

if [ ! -f $HOME/.vim/autoload/pathogen.vim ]; then
  echo Adding vim pathogen
  wget -q https://tpo.pe/pathogen.vim
  mv pathogen.vim ~/.vim/autoload/pathogen.vim
fi

function addVimPlugin {
  echo Adding vim plugin $1/$2
  rm -rf $HOME/.vim/bundle/${2}
  git clone -q git@github.com:$1/$2.git $HOME/.vim/bundle/$2
}

addVimPlugin rafi awesome-vim-colorschemes
addVimPlugin raimondi delimitmate
addVimPlugin mattn emmet-vim
addVimPlugin scrooloose nerdcommenter
addVimPlugin vim-airline vim-airline
addVimPlugin vim-airline vim-airline-themes
addVimPlugin airblade vim-gitgutter
addVimPlugin pangloss vim-javascript
addVimPlugin mxw vim-jsx
addVimPlugin editorconfig editorconfig-vim
addVimPlugin tpope vim-fugitive
addVimPlugin junegunn fzf
addVimPlugin junegunn fzf.vim
addVimPlugin scrooloose nerdtree
addVimPlugin terryma vim-multiple-cursors

if [ ! -d $HOME/.vim/bundle/youcompleteme ]; then
  addVimPlugin valloric youcompleteme
  echo Installing youcompleteme
  cd $HOME/.vim/bundle/youcompleteme && \
    git submodule update --init --recursive && \
    python3 ./install.py --ts-completer
fi

ln -sf $HOME/chachi-shell/vim/vimrc $HOME/.vimrc
