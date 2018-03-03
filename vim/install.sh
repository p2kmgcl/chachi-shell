#!/bin/bash

sudo apt-get install -y git vim wget

rm -rf ~/.vimrc ~/.vim
mkdir -p ~/.vim/bundle
mkdir -p ~/.vim/autoload

wget https://tpo.pe/pathogen.vim
mv pathogen.vim ~/.vim/autoload/pathogen.vim

git clone https://github.com/rafi/awesome-vim-colorschemes ~/.vim/bundle/awesome-vim-colorschemes
git clone https://github.com/ctrlpvim/ctrlp.vim ~/.vim/bundle/ctrlp
git clone https://github.com/raimondi/delimitmate ~/.vim/bundle/delimitmate
git clone https://github.com/mattn/emmet-vim ~/.vim/bundle/emmet-vim
git clone https://github.com/scrooloose/nerdcommenter ~/.vim/bundle/nerdcommenter
git clone https://github.com/vim-airline/vim-airline ~/.vim/bundle/vim-airline
git clone https://github.com/vim-airline/vim-airline-themes ~/.vim/bundle/vim-airline-themes
git clone https://github.com/airblade/vim-gitgutter ~/.vim/bundle/vim-git-gutter
git clone https://github.com/pangloss/vim-javascript ~/.vim/bundle/vim-javascript
git clone https://github.com/mxw/vim-jsx ~/.vim/bundle/vim-jsx
git clone https://github.com/editorconfig/editorconfig-vim.git ~/.vim/bundle/editorconfig-vim
git clone https://github.com/tpope/vim-fugitive ~/.vim/bundle/vim-fugitive
git clone https://github.com/christoomey/vim-tmux-navigator ~/.vim/bundle/vim-tmux-navigator

cp ./vim/vimrc ~/.vimrc
