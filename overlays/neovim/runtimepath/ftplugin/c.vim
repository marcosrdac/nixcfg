" compile code
nnoremap <silent> <F5> :!g++ %<CR>

" run code
nnoremap <silent> <F6> :!./a.out<CR>

" Insert spaces when hitting tabs
set expandtab

" Turning a hard TAB into 4 colums
set tabstop=4

" insert/delete 4 spaces when hitting a tab/backspace
set softtabstop=4

" Indenting 4 columns, unindenting 4 columns
set shiftwidth=4

" Round indent to multiple of 'shiftwidth'
set shiftround

" align the new line indent with the previous line
set autoindent

inoremap {<Enter> {<Enter>}<Esc>O
