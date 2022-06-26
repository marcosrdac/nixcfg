" Run script
"nnoremap <silent> <F5> :

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

