" Run script on python3
nnoremap <silent> <F5> :!$TERMINAL -e lf<CR>

" Insert spaces when hitting tabs
set expandtab

" Turning a hard TAB into 4 colums
set tabstop=2

" insert/delete 4 spaces when hitting a tab/backspace
set softtabstop=2

" Indenting 4 columns, unindenting 4 columns
set shiftwidth=2

" Round indent to multiple of 'shiftwidth'
set shiftround

" align the new line indent with the previous line
set autoindent

" run script
nnoremap <silent> <F5> :!sh %<CR>
