" both markdown and html use this file
if (&filetype == 'html')
  " Open in browser
  nnoremap <silent> <F5> :!$BROWSER % &<CR>
else
  " Run makefile
  nnoremap <silent> <F5> :!make<CR>
endif

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
