" Ensure correct syntax highlighting and auto-indentation for Fortran free-form
" source code.
let fortran_free_source=1
let fortran_do_enddo=1
filetype plugin indent on

" Breaking lines with more colums than 79
set textwidth=79

" Insert spaces when hitting tabs
set expandtab

" align the new line indent with the previous line
set autoindent

" Turning a hard TAB into 4 colums
set tabstop=2

" insert/delete 4 spaces when hitting a tab/backspace
set softtabstop=2

" Indenting 4 columns, unindenting 4 columns
set shiftwidth=2

" Round indent to multiple of 'shiftwidth'
set shiftround


nnoremap <silent> <F3> :!gfortran % -c -fcheck=bounds<CR>
nnoremap <silent> <F4> :!gfortran % -o %:r<CR>
nnoremap <silent> <F5> :!gfortran % -o %:r && ./%:r<CR>
nnoremap <silent> <F6> :!gfortran % -o %:r -fcheck=bounds<CR>
