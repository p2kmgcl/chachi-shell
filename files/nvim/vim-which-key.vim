let g:mapleader = "\<Space>"
let g:maplocalleader = ','
let g:which_key_map =  {}
let g:which_key_sep = '→'

nnoremap <silent> <leader>      :<c-u>WhichKey '<Space>'<CR>
nnoremap <silent> <localleader> :<c-u>WhichKey  ','<CR>
set timeoutlen=100

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

let g:which_key_map.e = {
  \ 'name': '+esearch',
  \ 's' : ['<Plug>(esearch)', 'search'],
  \ 'w' : ['<Plug>(esearch-word-under-cursor)', 'search word under cursor'],
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
  \ }

let g:which_key_map.g = {
  \ 'name': '+git',
  \ 's': [':Gstatus', 'status'],
  \ }

let g:which_key_map.t = {
  \ 'name': '+terminal',
  \ 'd': [':FloatermNew --autoclose=0 gradlew clean deploy -Dbuild="portal"', 'deploy'],
  \ 'f': [':FloatermNew --autoclose=0 gradlew formatSource', 'format'],
  \ 'o': [':FloatermToggle', 'open terminal'],
  \ 't': [':FloatermNew --autoclose=0 yarn test', 'test'],
  \ }

let g:which_key_map.w = {
  \ 'name': '+window',
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
