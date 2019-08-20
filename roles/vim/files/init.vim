call plug#begin('~/.config/nvim/plugged')
Plug 'junegunn/fzf.vim'
Plug 'junegunn/fzf'
Plug 'junegunn/vim-slash'
Plug 'eugen0329/vim-esearch'
Plug 'philip-karlsson/bolt.nvim', { 'do': ':UpdateRemotePlugins' }

Plug 'neoclide/coc.nvim', {'branch': 'release'}

Plug 'chriskempson/base16-vim'
Plug 'editorconfig/editorconfig-vim'
Plug 'prettier/vim-prettier', { 'do': 'npm install' }
call plug#end()

syntax on
filetype plugin indent on

set background=dark
set termguicolors
colorscheme base16-onedark

set autoindent smartindent
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
set textwidth=80
set cmdheight=2
set updatetime=300
set shortmess+=c
set signcolumn=yes
set number

set wildmenu
set wildignore+=*/.git/*,
set wildignore+=*/.sass-cache/*,
set wildignore+=*/build/*
set wildignore+=*/classes/*
set wildignore+=*/gradle/*
set wildignore+=*/node_modules/*
set wildignore+=*/tmp/*

inoremap <silent><expr> <c-space> coc#refresh()

let g:esearch = {
  \ 'adapter':          'rg',
  \ 'backend':          'nvim',
  \ 'out':              'win',
  \ 'batch_size':       1000,
  \ 'use':              ['visual', 'hlsearch', 'last'],
  \ 'default_mappings': 1,
  \}

let g:fzf_command_prefix = 'Fzf'
nm <silent> <C-p> :FzfFiles<CR>
nm <silent> <C-g> :FzfGFiles?<CR>
nm <silent> <C-f> :FzfRg<CR>

let g:prettier#quickfix_enabled = 0
let g:prettier#autoformat = 0
autocmd BufWritePre *.js,*.jsx,*.mjs,*.ts,*.tsx,*.css,*.less,*.scss,*.json,*.graphql,*.md,*.vue,*.yaml,*.html PrettierAsync
