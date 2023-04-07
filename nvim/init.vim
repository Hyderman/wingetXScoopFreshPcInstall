set clipboard=unnamedplus
nnoremap <C-/> <Cmd>call VSCodeNotifyVisual('editor.action.commentLine', 1)<CR>
xnoremap <C-/> <Cmd>call VSCodeNotifyVisual('editor.action.commentLine', 1)<CR>
nnoremap <esc> :noh<return><esc>
" Keep undo/redo lists in sync with VSCode
nmap <silent> u <Cmd>call VSCodeNotify('undo')<CR>
nmap <silent> <C-r> <Cmd>call VSCodeNotify('redo')<CR>
" Ctrl-j/k deletes blank line below/above, and Alt-j/k inserts.
nnoremap <silent><C-j> m`:silent +g/\m^\s*$/d<CR>``:noh<CR>
nnoremap <silent><C-k> m`:silent -g/\m^\s*$/d<CR>``:noh<CR>
nnoremap <silent><A-j> :set paste<CR>m`o<Esc>``:set nopaste<CR>
nnoremap <silent><A-k> :set paste<CR>m`O<Esc>``:set nopaste<CR>
