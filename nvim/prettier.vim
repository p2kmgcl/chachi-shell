let g:prettier#autoformat = 0
let g:prettier#quickfix_enabled = 0

nmap <Leader>zp <Plug>(Prettier)
autocmd BufWritePre *.js,*.jsx,*.mjs,*.ts,*.tsx,*.css,*.less,*.scss,*.json,*.graphql,*.md,*.vue,*.yaml,*.html,*.ejs PrettierAsync
