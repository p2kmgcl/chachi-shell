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
