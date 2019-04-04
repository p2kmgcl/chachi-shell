#!/bin/bash

HERE=`pwd`

mkdir -p ~/.vim/bundle
mkdir -p ~/.vim/autoload

if [ ! -f ~/.vim/autoload/pathogen.vim ]; then
  echo Adding vim pathogen
  wget -q https://tpo.pe/pathogen.vim
  mv pathogen.vim ~/.vim/autoload/pathogen.vim
fi

function addVimPlugin {
  echo Adding vim plugin $1/$2
  if [ ! -d ~/.vim/bundle/${2} ]; then
    git clone -q git@github.com:$1/$2.git ~/.vim/bundle/$2
  fi
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

if [ ! -d ~/.vim/bundle/youcompleteme ]; then
  addVimPlugin valloric youcompleteme
  echo Installing youcompleteme
  cd ~/.vim/bundle/youcompleteme && \
  git submodule update --init --recursive && \
  python3 ./install.py --ts-completer
fi

echo Copying vim configuration
cd $HERE && cp ./vim/vimrc ~/.vimrc
