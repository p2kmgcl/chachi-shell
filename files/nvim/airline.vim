let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#formatter = 'jsformatter'
let g:airline_section_b = ''
let g:airline_section_x = ''
let g:airline_section_y = airline#section#create(['linenr'])
let g:airline_section_z = airline#section#create(['branch'])
let g:airline_symbols.linenr = 'ln'
let g:airline_section_error = ''
let g:airline_section_warning = ''