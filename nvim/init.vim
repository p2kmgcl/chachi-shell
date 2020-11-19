call plug#begin('~/.config/nvim/plugged')
" Moving through files
Plug 'junegunn/fzf.vim'
Plug 'junegunn/fzf'
Plug 'junegunn/vim-slash'
Plug 'eugen0329/vim-esearch'

" UI
Plug 'vim-airline/vim-airline'
Plug 'arcticicestudio/nord-vim'
Plug 'scrooloose/nerdtree'
Plug 'liuchengxu/vim-which-key'
Plug 'voldikss/vim-floaterm'
Plug 'junegunn/goyo.vim'

" Project management
Plug 'tpope/vim-fugitive'
Plug 'airblade/vim-gitgutter'
Plug 'mbbill/undotree'

" Completion
Plug 'leafgarland/typescript-vim'
Plug 'pangloss/vim-javascript'
Plug 'MaxMEllon/vim-jsx-pretty'
Plug 'elzr/vim-json'
Plug 'cakebaker/scss-syntax.vim'
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'tpope/vim-commentary'

" Formatting and fixing
Plug 'editorconfig/editorconfig-vim'
Plug 'prettier/vim-prettier', { 'do': 'npm install' }
Plug 'dense-analysis/ale'
call plug#end()

" Coloring
set background=dark
set termguicolors
syntax on
filetype plugin indent on
colorscheme nord
highlight SignColumn guibg=none
set signcolumn yes:1

" Visual
set autoindent smartindent
let &colorcolumn=join(range(80,1000),",")
set cursorline
set expandtab
set nobackup
set noeol
set noswapfile
set nowrap
set nowritebackup
set nonumber
set shiftwidth=2
set tabstop=2
set textwidth=80

"persistent undo history
set undodir=~/.config/nvim/undo-dir
set undofile

" Behavior
set clipboard=unnamedplus
set cmdheight=1
set completeopt=noinsert,menuone,noselect
set hidden
set hlsearch
set ignorecase smartcase
"set mouse=a
set shortmess+=c
set showmatch
set signcolumn=yes
set updatetime=300

" Ignored paths
set wildmenu
set wildignore+=*/.cache/*,
set wildignore+=*/.git/*,
set wildignore+=*/.sass-cache/*,
set wildignore+=*/build/*
set wildignore+=*/classes/*
set wildignore+=*/dist/*
set wildignore+=*/gradle/*
set wildignore+=*/node_modules/*
set wildignore+=*/tmp/*

" Plugin config
source ~/.config/nvim/airline.vim
source ~/.config/nvim/ale.vim
source ~/.config/nvim/coc.vim
source ~/.config/nvim/esearch.vim
source ~/.config/nvim/fzf.vim
source ~/.config/nvim/gitgutter.vim
source ~/.config/nvim/goyo.vim
source ~/.config/nvim/nerdtree.vim
source ~/.config/nvim/prettier.vim

" Keys
source ~/.config/nvim/vim-which-key.vim
