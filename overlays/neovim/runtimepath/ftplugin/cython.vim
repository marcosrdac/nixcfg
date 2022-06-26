"source 'python.vim'

" Run script on python3
nnoremap <silent> <F5> :!/usr/bin/env python setup.py build_ext --inplace<CR>
