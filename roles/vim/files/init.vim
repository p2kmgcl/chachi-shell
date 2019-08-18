call plug#begin('~/.config/nvim/plugged')
Plug 'https://github.com/autozimu/LanguageClient-neovim.git'
call plug#end()

syntax on
filetype plugin indent on

set autoindent smartindent
set background=dark
set clipboard=unnamedplus
set noeol
set hlsearch
set ignorecase smartcase
set mouse=a
set nobackup
set noswapfile
set nowrap
set nowritebackup
set showmatch
set termguicolors
set textwidth=80

set wildmenu
set wildignore+=*/.git/*,
set wildignore+=*/.sass-cache/*,
set wildignore+=*/build/*
set wildignore+=*/classes/*
set wildignore+=*/gradle/*
set wildignore+=*/node_modules/*
set wildignore+=*/tmp/*
