" Run script on python3
nnoremap <silent> <F5> :!julia %<CR>

"au BufRead,BufNewFile *.py,*.pyw,*.c,*.h match BadWhitespace /\s\+$/

" Breaking lines with more colums than 79
"set textwidth=79

" increasing readability
"set textwidth=80
"set colorcolumn=+1
au BufWinEnter * let w:m2=matchadd('ErrorMsg', '\%>80v.\+', -1)

" Insert spaces when hitting tabs
set expandtab

" align the new line indent with the previous line
set autoindent

" Turning a hard TAB into 4 colums
set tabstop=4

" insert/delete 4 spaces when hitting a tab/backspace
set softtabstop=4

" Indenting 4 columns, unindenting 4 columns
set shiftwidth=4

" Round indent to multiple of 'shiftwidth'
set shiftround


inoremap #! #!/usr/bin/env julia<enter><enter>
