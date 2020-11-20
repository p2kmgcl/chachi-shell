let g:prettier#autoformat = 1
let g:prettier#autoformat_require_pragma = 0
let g:prettier#autoformat_config_present = 1
let g:prettier#quickfix_auto_focus = 0

let g:prettier#autoformat_config_files = ['.prettierrc', '.prettierrc.json']

nmap <Leader>zp <Plug>(Prettier)
