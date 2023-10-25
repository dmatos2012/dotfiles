function! s:small_terminal() abort
  new
  wincmd J
  call nvim_win_set_height(0, 12)
  set winfixheight
  term

  " This relies on kitty being launched with 
  " kitty -o allow_remote_control=yes --listen-on unix:/tmp/mykitty
  " Uncomment stuff below to make it work via kitty
  " term kitty @ --to unix:/tmp/mykitty launch --title Output
  " silent! call system("kitty @ --to unix:/tmp/mykitty launch --title Output")
  " sleep is needed otherwise enter is not pressed?
  " sleep 1
  " term kitty @ --to unix:/tmp/mykitty send-text --match 'title:^Output' python hi.py
  " call system("kitty @ --to unix:/tmp/mykitty send-text --match 'title:^Output' python hi.py")
  " call system("kitty @ --to unix:/tmp/mykitty send-text --match 'title:^Output' \\x0d")
endfunction


function! s:small_terminal_vert() abort
  new
  wincmd H
  " we dont set height or width since we want it evenly
  set winfixwidth
  term
endfunction

" ANKI: Make a small terminal at the bottom of the screen.
nnoremap <leader>st :call <SID>small_terminal()<CR>
nnoremap <leader>sv :call <SID>small_terminal_vert()<CR>

" TODO: Make a floating terminal for one shot command?
