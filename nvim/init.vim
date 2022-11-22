call plug#begin('~/.config/nvim/plugged')

" Moving through files
Plug 'junegunn/fzf.vim'
Plug 'junegunn/fzf'
Plug 'junegunn/vim-slash'

" UI
Plug 'catppuccin/nvim', {'as': 'catppuccin'}
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'scrooloose/nerdtree'
Plug 'liuchengxu/vim-which-key'
Plug 'voldikss/vim-floaterm'
Plug 'junegunn/goyo.vim'

" Project management
Plug 'tpope/vim-fugitive'
Plug 'airblade/vim-gitgutter'
Plug 'mbbill/undotree'

" Completion
Plug 'ianks/vim-tsx'
Plug 'leafgarland/typescript-vim'
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'tpope/vim-commentary'
Plug 'github/copilot.vim'

" Formatting and fixing
Plug 'editorconfig/editorconfig-vim'
Plug 'prettier/vim-prettier', { 'do': 'yarn install' }
Plug 'dense-analysis/ale'

call plug#end()

" Coloring
set t_Co=256
syntax on
colorscheme catppuccin-latte
let g:airline_theme = 'catppuccin'
filetype plugin indent on

lua require("catppuccin").setup()

" Theme tweaks
highlight SignColumn guibg=none

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
set number
set shiftwidth=2
set signcolumn=yes
set tabstop=2
set textwidth=80

" Support ts and tsx
au BufNewFile,BufRead *.ts setlocal filetype=typescript
au BufNewFile,BufRead *.tsx setlocal filetype=typescript.tsx

" Persistent undo history
set undodir=~/.config/nvim/undo-dir
set undofile

" Behavior
set clipboard=unnamedplus
set cmdheight=1
set completeopt=noinsert,menuone,noselect
set hidden
set hlsearch
set ignorecase smartcase
set shortmess+=c
set showmatch
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
source ~/.config/nvim/fzf.vim
source ~/.config/nvim/gitgutter.vim
source ~/.config/nvim/goyo.vim
source ~/.config/nvim/prettier.vim

" Keys
source ~/.config/nvim/vim-which-key.vim
