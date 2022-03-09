" Insert spaces when hitting tabs
set expandtab

" align the new line indent with the previous line
set autoindent

" Turning a hard TAB into 2 colums
set tabstop=2

" insert/delete 4 spaces when hitting a tab/backspace
set softtabstop=2

" Indenting 2 columns, unindenting 2 columns
set shiftwidth=2

" Round indent to multiple of 'shiftwidth'
set shiftround


" Compile with compiler
nnoremap <silent> <F5> :!compiler %<CR>
