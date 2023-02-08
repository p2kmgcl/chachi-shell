call plug#begin('~/.config/nvim/plugged')

Plug 'airblade/vim-gitgutter'
Plug 'catppuccin/nvim', {'as': 'catppuccin'}
Plug 'dense-analysis/ale'
Plug 'editorconfig/editorconfig-vim'
Plug 'ianks/vim-tsx'
Plug 'junegunn/fzf'
Plug 'junegunn/fzf.vim'
Plug 'junegunn/goyo.vim'
Plug 'junegunn/vim-slash'
Plug 'leafgarland/typescript-vim'
Plug 'liuchengxu/vim-which-key'
Plug 'mbbill/undotree'
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'prettier/vim-prettier', { 'do': 'yarn install' }
Plug 'scrooloose/nerdtree'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-fugitive'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'

call plug#end()

""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Coloring
""""""""""""""""""""""""""""""""""""""""""""""""""""""

set t_Co=256
syntax on
colorscheme catppuccin-latte
let g:airline_theme = 'catppuccin'
filetype plugin indent on
lua require("catppuccin").setup()
highlight SignColumn guibg=none
"highlight CursorLine guibg=#888888
"highlight Visual guibg=white
"highlight PmenuSel guibg=white
"highlight CocMenuSel guibg=white
let &colorcolumn=join(range(2000,10000),",")

""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Base config
""""""""""""""""""""""""""""""""""""""""""""""""""""""

set autoindent smartindent
set breakindent
set clipboard=unnamedplus
set cmdheight=1
set completeopt=noinsert,menuone,noselect
set cursorline
set expandtab
set hidden
set hlsearch
set ignorecase smartcase
set linebreak
set mouse=a
set nobackup
set noeol
set noswapfile
set nowritebackup
set number
set shiftwidth=2
set shortmess+=c
set showmatch
set signcolumn=yes
set tabstop=2
set textwidth=100
set updatetime=300
set wrap
" Support ts and tsx
au BufNewFile,BufRead *.ts setlocal filetype=typescript
au BufNewFile,BufRead *.tsx setlocal filetype=typescript.tsx
" Persistent undo history
set undodir=~/.config/nvim/undo-dir
set undofile
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

""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Airline
""""""""""""""""""""""""""""""""""""""""""""""""""""""

let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#formatter = 'jsformatter'
let g:airline_powerline_fonts = 0
let g:airline_section_b = ''
let g:airline_section_x = ''
let g:airline_section_y = airline#section#create(['linenr'])
let g:airline_section_z = airline#section#create(['branch'])
let g:airline_symbols.linenr = 'ln'
let g:airline_section_error = ''
let g:airline_section_warning = ''

""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Ale
""""""""""""""""""""""""""""""""""""""""""""""""""""""

let g:ale_sign_column_always = 1
let g:ale_sign_error = '! '
let g:ale_sign_warning = '? '

""""""""""""""""""""""""""""""""""""""""""""""""""""""
" COC
""""""""""""""""""""""""""""""""""""""""""""""""""""""

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

autocmd CursorHold * silent call CocActionAsync('highlight')

let g:coc_global_extensions = ['coc-tsserver', 'coc-emmet', 'coc-css', 'coc-html', 'coc-json', 'coc-yank', 'coc-prettier', 'coc-rust-analyzer']

inoremap <silent><expr> <TAB> pumvisible() ? "\<C-n>" : <SID>check_back_space() ? "\<TAB>" : coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"
inoremap <silent><expr> <c-space> coc#refresh()
inoremap <silent><expr> <CR> coc#pum#visible() ? coc#pum#confirm()
                              \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

""""""""""""""""""""""""""""""""""""""""""""""""""""""
" FZF
""""""""""""""""""""""""""""""""""""""""""""""""""""""

let g:fzf_command_prefix = 'Fzf'
let g:fzf_preview_window = ['hidden,up,50%', 'ctrl-/']

command! -bang -nargs=* FzfRg
  \ call fzf#vim#grep(
  \   "rg --column --line-number --no-heading --color=always --smart-case -- ".shellescape(<q-args>), 1,
  \   fzf#vim#with_preview('up', 'ctrl-/'), 1)

nnoremap <C-r> :FzfBuffers<Cr>
nnoremap <C-p> :FzfGFiles<Cr>
nnoremap <C-f> :FzfRg<Cr>

""""""""""""""""""""""""""""""""""""""""""""""""""""""
" GitGutter
""""""""""""""""""""""""""""""""""""""""""""""""""""""

let g:gitgutter_sign_added = '█ '
let g:gitgutter_sign_modified = '█ '
let g:gitgutter_sign_removed = '█ '
let g:gitgutter_sign_removed_first_line = '█ '
let g:gitgutter_sign_modified_removed = '█ '
let g:gitgutter_set_sign_backgrounds = 1

highlight GitGutterAdd guifg=#009900 ctermfg=2
highlight GitGutterChange guifg=#bbbb00 ctermfg=3
highlight GitGutterDelete guifg=#ff2222 ctermfg=1

nmap <leader>zgph <Plug>(GitGutterPreviewHunk)
nmap <leader>zgsh <Plug>(GitGutterStageHunk)
nmap <leader>zguh <Plug>(GitGutterUndoHunk)

""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Goyo
""""""""""""""""""""""""""""""""""""""""""""""""""""""

function! s:goyo_enter()
  set noshowcmd
  set noshowmode
  set wrap
  set textwidth=0
  set scrolloff=999
endfunction

function! s:goyo_leave()
  set showcmd
  set showmode
  set nowrap
  set textwidth=80
  set scrolloff=5
endfunction

autocmd! User GoyoEnter nested call <SID>goyo_enter()
autocmd! User GoyoLeave nested call <SID>goyo_leave()

""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Prettier
""""""""""""""""""""""""""""""""""""""""""""""""""""""

let g:prettier#autoformat = 1
let g:prettier#autoformat_require_pragma = 0
let g:prettier#autoformat_config_present = 1
let g:prettier#quickfix_auto_focus = 0
let g:prettier#autoformat_config_files = ['.prettierrc', '.prettierrc.json']

nmap <Leader>zp <Plug>(Prettier)

""""""""""""""""""""""""""""""""""""""""""""""""""""""
" VIM Which Key
""""""""""""""""""""""""""""""""""""""""""""""""""""""

let g:mapleader = "\<Space>"
let g:maplocalleader = ','
let g:which_key_map =  {}
let g:which_key_sep = '→'

nnoremap <silent> <leader>      :<c-u>WhichKey '<Space>'<CR>
nnoremap <silent> <localleader> :<c-u>WhichKey  ','<CR>
set timeoutlen=0

autocmd! FileType which_key
autocmd  FileType which_key set laststatus=0 noshowmode noruler
  \| autocmd BufLeave <buffer> set laststatus=2 noshowmode ruler

let g:which_key_use_floating_win = 0

let g:which_key_map.c = {
  \ 'name': '+coc',
  \ 'd' : ['<Plug>(coc-definition)', 'definition'],
  \ 'i' : ['<Plug>(coc-implementation)', 'implementation'],
  \ 'r' : ['<Plug>(coc-references)', 'references'],
  \ 't' : ['<Plug>(coc-type-definition)', 'type definition'],
  \ }

let g:which_key_map.f = {
  \ 'name': '+fzf',
  \ 'b' : [':FzfBuffers', 'buffer'],
  \ 'c' : [':FzfCommits', 'commit'],
  \ 'f' : [':FzfFiles', 'file'],
  \ 'g' : [':FzfGFiles?', 'modified file'],
  \ 'h' : [':FzfHelptags', 'help'],
  \ 'm' : [':FzfMaps', 'mapped keys'],
  \ 't' : [':FzfFiletypes', 'file type'],
  \ 'w' : [':FzfRg', 'word'],
  \ }

let g:which_key_map.g = {
  \ 'name': '+git',
  \ 'c': [':Gcommit', 'commit'],
  \ 's': [':Gstatus', 'status'],
  \ }

let g:which_key_map.s = {
  \ 'name': '+sidebar',
  \ 'f': [':NERDTreeFind', 'find'],
  \ 't': [':NERDTreeToggle', 'toggle'],
  \ }

let g:which_key_map.w = {
  \ 'name': '+window',
  \ 'c': [':bd', 'close(delete) buffer'],
  \ 'h': ['sp', 'split horizontally'],
  \ 'v': ['vs', 'split vertically'],
  \ }

let g:which_key_map.z = {
  \ 'name': '+miscelaneous',
  \ 'e': [':e', 'reload current file'],
  \ 'g': [':Goyo', 'toggle Goyo'],
  \ 'p': ['<Plug>(Prettier)', 'run prettier'],
  \ 'r': [':source ~/.config/nvim/init.vim', 'reload config'],
  \ }

call which_key#register('<Space>', "g:which_key_map")
