" TODO: Add Pytest & other useful commands for py here"
setlocal expandtab
setlocal smarttab
setlocal shiftwidth=4
setlocal tabstop=4

nnoremap <buffer><silent> <space>pb :!black %<CR>
nnoremap <buffer><silent> <space>pf :!flake8 %<CR>
" augroup run_flake8
"     au!
"     autocmd BufWritePost *.py black
" augroup END

