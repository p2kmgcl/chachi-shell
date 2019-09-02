call plug#begin('~/.config/nvim/plugged')
" Moving through files
Plug 'junegunn/fzf.vim'
Plug 'junegunn/fzf'
Plug 'junegunn/vim-slash'
Plug 'eugen0329/vim-esearch'
Plug 'scrooloose/nerdtree'

" Split navigation
Plug 'christoomey/vim-tmux-navigator'

" Project management
Plug 'tpope/vim-fugitive'
Plug 'airblade/vim-gitgutter'

" Completion and formatting
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'editorconfig/editorconfig-vim'
Plug 'prettier/vim-prettier', { 'do': 'npm install' }

" Snippets
Plug 'SirVer/ultisnips'

" Colors
Plug 'chriskempson/base16-vim'
call plug#end()

syntax on
filetype plugin indent on

set background=light
set termguicolors
colorscheme base16-one-light

set autoindent smartindent
set clipboard=unnamedplus
set cmdheight=2
set hidden
set hlsearch
set ignorecase smartcase
set mouse=a
set nobackup
set noeol
set noswapfile
set nowrap
set nowritebackup
set number
set shortmess+=c
set showmatch
set signcolumn=yes
set textwidth=80
set updatetime=300

set wildmenu
set wildignore+=*/.git/*,
set wildignore+=*/.sass-cache/*,
set wildignore+=*/build/*
set wildignore+=*/classes/*
set wildignore+=*/gradle/*
set wildignore+=*/node_modules/*
set wildignore+=*/tmp/*

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

inoremap <silent><expr> <TAB> pumvisible() ? "\<C-n>" : <SID>check_back_space() ? "\<TAB>" : coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"
inoremap <silent><expr> <c-space> coc#refresh()
inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"
nnoremap <silent> gd <Plug>(coc-definition)
nnoremap <silent> gy <Plug>(coc-type-definition)
nnoremap <silent> gi <Plug>(coc-implementation)
nnoremap <silent> gr <Plug>(coc-references)

map <C-n> :NERDTreeToggle<CR>

let g:esearch = {
  \ 'adapter':          'rg',
  \ 'backend':          'nvim',
  \ 'out':              'win',
  \ 'batch_size':       1000,
  \ 'use':              ['visual', 'hlsearch', 'last'],
  \ 'default_mappings': 1,
  \}

let g:fzf_command_prefix = 'Fzf'
nnoremap <silent> <C-p> :FzfFiles<CR>
nnoremap <silent> <C-g> :FzfBuffers<CR>
nmap <silent> <C-f> \ff

let g:prettier#quickfix_enabled = 0
let g:prettier#autoformat = 0
autocmd BufWritePre *.js,*.jsx,*.mjs,*.ts,*.tsx,*.css,*.less,*.scss,*.json,*.graphql,*.md,*.vue,*.yaml,*.html PrettierAsync

command GradlewCleanDeploy :te gradlewCleanDeploy<CR>
command GradlewFormatSource :te gradlewFormatSource<CR>

let g:UltiSnipsSnippetsDir = '~/.neovim-snippets'
