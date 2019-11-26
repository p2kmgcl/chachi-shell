call plug#begin('~/.config/nvim/plugged')
" Moving through files
Plug 'junegunn/fzf.vim'
Plug 'junegunn/fzf'
Plug 'junegunn/vim-slash'
Plug 'eugen0329/vim-esearch'

" UI
Plug 'vim-airline/vim-airline'
Plug 'scrooloose/nerdtree'
Plug 'arcticicestudio/nord-vim'

" Project management
Plug 'tpope/vim-fugitive'
Plug 'airblade/vim-gitgutter'
Plug 'mbbill/undotree'

" Completion
Plug 'sheerun/vim-polyglot'
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'tpope/vim-commentary'

" Formatting and fixing
Plug 'editorconfig/editorconfig-vim'
Plug 'prettier/vim-prettier', { 'do': 'npm install' }
Plug 'dense-analysis/ale'
call plug#end()

" Coloring
syntax on
filetype plugin indent on
colorscheme nord

" Visual
set autoindent smartindent
set cursorline
set expandtab
set nobackup
set noeol
set noswapfile
set nowrap
set nowritebackup
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
set mouse=a
set shortmess+=c
set showmatch
set signcolumn=yes
set updatetime=300

" Ignored paths
set wildmenu
set wildignore+=*/.git/*,
set wildignore+=*/.sass-cache/*,
set wildignore+=*/build/*
set wildignore+=*/classes/*
set wildignore+=*/dist/*
set wildignore+=*/gradle/*
set wildignore+=*/node_modules/*
set wildignore+=*/tmp/*

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Global variables
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#formatter = 'jsformatter'
let g:airline_section_b = ''
let g:airline_section_x = ''
let g:airline_section_y = airline#section#create(['linenr'])
let g:airline_section_z = airline#section#create(['branch'])
let g:airline_symbols.linenr = 'ln'
let g:airline_section_error = ''
let g:airline_section_warning = ''
let g:ale_sign_column_always = 1
let g:ale_sign_error = '! '
let g:ale_sign_warning = '? '
let g:esearch#out#win#open = 'new'
let g:gitgutter_sign_added = '█ '
let g:gitgutter_sign_modified = '█ '
let g:gitgutter_sign_removed = '█ '
let g:gitgutter_sign_removed_first_line = '█ '
let g:gitgutter_sign_modified_removed = '█ '
let g:fzf_command_prefix = 'Fzf'
let g:prettier#autoformat = 0
let g:prettier#quickfix_enabled = 0

let g:esearch = {
  \ 'adapter':          'rg',
  \ 'backend':          'nvim',
  \ 'out':              'win',
  \ 'batch_size':       1000,
  \ 'use':              ['visual', 'hlsearch', 'last'],
  \ 'default_mappings': 1,
  \}

" Autorun commands
autocmd BufWritePre *.js,*.jsx,*.mjs,*.ts,*.tsx,*.css,*.less,*.scss,*.json,*.graphql,*.md,*.vue,*.yaml,*.html PrettierAsync
autocmd CursorHold * silent call CocActionAsync('highlight')

" Mapped keys
map <silent> <C-p> :FzfFiles<CR>
map <silent> <C-g> :FzfBuffers<CR>
map <silent> <C-n> :NERDTreeToggle<CR>
map <silent> <C-b> :NERDTreeFind<CR>
map <silent> <C-f> \ff
inoremap <silent><expr> <TAB> pumvisible() ? "\<C-n>" : <SID>check_back_space() ? "\<TAB>" : coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"
inoremap <silent><expr> <c-space> coc#refresh()
inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"
nnoremap <silent> gd <Plug>(coc-definition)
nnoremap <silent> gy <Plug>(coc-type-definition)
nnoremap <silent> gi <Plug>(coc-implementation)
nnoremap <silent> gr <Plug>(coc-references)
