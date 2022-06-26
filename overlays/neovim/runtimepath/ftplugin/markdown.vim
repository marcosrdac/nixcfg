" Run make
"nnoremap <silent> <F5> :!pandoc % \| $BROWSER<CR>
"nnoremap <silent> <F5> :!make
"nnoremap <silent> <F5> :!make
nnoremap <silent> <F5> :silent exec "!make"<CR>

" align the new line indent with the previous line
set autoindent

" Turning a hard TAB into 2 colums
set tabstop=2

" Insert spaces when hitting tabs
set expandtab

" Indenting 2 columns, unindenting 2 columns
set shiftwidth=2

" Round indent to multiple of 'shiftwidth'
set shiftround

" insert/delete 2 spaces when hitting a tab/backspace
set softtabstop=2


imap ;; <Plug>(emmet-expand-abbr)
imap ;;! <Plug>(emmet-toogle-comment)
imap ;;i <Plug>(emmet-image-size)
imap ;;j <Plug>(emmet-split-join-tag)


"map <leader>w yiWi[<esc>Ea](<esc>pa)
"inoremap ,n ---<Enter><Enter>
"inoremap ,b ****<++><Esc>F*hi
"inoremap ,s ~~~~<++><Esc>F~hi
"inoremap ,e **<++><Esc>F*i
"inoremap ,h ====<Space><++><Esc>F=hi
"inoremap ,i ![](<++>)<++><Esc>F[a
"inoremap ,a [](<++>)<++><Esc>F[a
"inoremap ,1 #<Space><Enter><++><Esc>kA
"inoremap ,2 ##<Space><Enter><++><Esc>kA
"inoremap ,3 ###<Space><Enter><++><Esc>kA
"inoremap ,l --------<Enter>
"inoremap ,r ```{r}<CR>```<CR><CR><esc>2kO
"inoremap ,p ```{python}<CR>```<CR><CR><esc>2kO
"inoremap ,c ```<cr>```<cr><cr><esc>2kO
