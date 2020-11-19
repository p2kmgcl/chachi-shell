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
