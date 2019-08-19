call plug#begin('~/.config/nvim/plugged')
Plug 'junegunn/fzf.vim'
Plug 'junegunn/fzf'
Plug 'junegunn/vim-slash'
Plug 'philip-karlsson/bolt.nvim', { 'do': ':UpdateRemotePlugins' }
Plug 'editorconfig/editorconfig-vim'
Plug 'eugen0329/vim-esearch'
call plug#end()

syntax on
filetype plugin indent on

set autoindent smartindent
set background=dark
set clipboard=unnamedplus
set noeol
set hidden
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

let g:deoplete#enable_at_startup = 1

let g:esearch = {
  \ 'adapter': 'rg',
  \ 'backend': 'nvim',
  \ 'out': 'win',
  \ 'batch_size': 1000,
  \ 'use': ['visual', 'hlsearch', 'last'],
  \ 'default_mappings': 1,
  \}

let g:LanguageClient_serverCommands = {
    \ 'javascript': ['javascript-typescript-stdio'],
    \ 'typescript': ['javascript-typescript-stdio'],
    \ 'javascript.jsx': ['javascript-typescript-stdio'],
    \ 'typescript.tsx': ['javascript-typescript-stdio'],
    \ }

let g:LanguageClient_rootMarkers = {
    \ 'javascript': ['package.json'],
    \ 'typescript': ['package.json'],
    \ }

let g:fzf_command_prefix = 'Fzf'
nm <silent> <C-p> :FzfFiles<CR>
nm <silent> <C-g> :FzfGFiles?<CR>
nm <silent> <C-f> :FzfRg<CR>
