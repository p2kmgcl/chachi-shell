let g:fzf_command_prefix = 'Fzf'
let g:fzf_preview_window = ['hidden,up,50%', 'ctrl-/']

command! -bang -nargs=* FzfRg
  \ call fzf#vim#grep(
  \   "rg --column --line-number --no-heading --color=always --smart-case -- ".shellescape(<q-args>), 1,
  \   fzf#vim#with_preview('up', 'ctrl-/'), 1)

nnoremap <C-r> :FzfBuffers<Cr>
nnoremap <C-p> :FzfGFiles<Cr>
nnoremap <C-f> :FzfRg<Cr>
