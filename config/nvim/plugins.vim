" quick-scope on key-press
"let g:qs_highlight_on_keys = ['f', 'F', 't', 'T']
if has('nvim')
    highlight QuickScopePrimary   ctermfg=5 cterm=underline guifg=5 gui=underline
    highlight QuickScopeSecondary ctermfg=6 cterm=underline guifg=6 gui=underline
else
    highlight QuickScopePrimary   ctermfg=5 cterm=underline gui=underline
    highlight QuickScopeSecondary ctermfg=6 cterm=underline gui=underline
endif

let g:DOCUMENTS = system("echo -n ${XDG_DOCUMENTS_DIR:-'$HOME/Documents'}")

" VimWiki
let g:vimwiki_ext2syntax = {'.md': 'markdown',
                          \ '.gpg': 'markdown',}
let vimwiki_nested_syntaxes = {'shell': 'sh', 'sh': 'sh', 'bash': 'sh',
                             \ 'python': 'python', 'julia': 'julia',
                             \ 'c': 'c', 'c++': 'cpp', 'fortran': 'fortran'}

let wiki_1 = {}
let wiki_1.path = g:DOCUMENTS
let wiki_1.diary_rel_path = 'psn/log/jrn'
let wiki_1.diary_index = 'index'
let wiki_1.diary_header = 'Journal'
let wiki_1.ext = '.md'
let wiki_1.syntax = 'markdown'
let wiki_1.nested_syntaxes = vimwiki_nested_syntaxes
let wiki_1.auto_diary_index = 1

let g:vimwiki_list = [wiki_1]


" vim-calendar
let g:calendar_options = 'nonu nornu'

" vim-gnupg
let g:GPGFilePattern = '*.\(gpg\|asc\|pgp\)\(.md\)\='
let g:GPGDefaultRecipients = [expand('$PUBKEYID')]
"let g:GPGPossibleRecipients=["me ".expand('$PERSONAL_MAIL'),]


" NERDTree
"   ignoring node modules
let g:NERDTreeIgnore = ['^node_modules$', '^.git$', '\.pyc$', '\~$']
" vim-nerdtree-syntax-highlight
"   diminishing lag
let g:NERDTreeLimitedSyntax = 1
"   highlighting entire line
let g:NERDTreeFileExtensionHighlightFullName = 1
let g:NERDTreeExactMatchHighlightFullName = 1
let g:NERDTreePatternMatchHighlightFullName = 1


" CtrlP
let g:ctrlp_user_command = ['.git/',
            \ 'git --git-dir=%s/.git ls-files -oc --exclude-standard']

" languagetool
let g:languagetool_lang = 'en'

" ALE
" Disable auto-detection of virtualenvironments
"let g:ale_virtualenv_dir_names = [expand('$VIRTUAL_ENV')]
" Environment variable ${VIRTUAL_ENV} is always used
" pylint has the errors
"" Check Python files with flake8 and pylint.
"let b:ale_linters = ['flake8']  " , 'pylint']
"" Fix Python files with autopep8 and yapf.
"let b:ale_fixers = ['autopep8', 'yapf']
" Disable warnings about trailing whitespace for Python files.
let b:ale_warn_about_trailing_whitespace = 0
" take a look at this site
"   http://blog.algarvio.me/2012/12/27/pylint-+-virtualenv/
let g:ale_python_pylint_executable = 'pylint'


" deoplete
"   setting python hosts
" tell deoplete where to search right binarys
let g:deoplete#sources#jedi#python_path=expand('$VIRTUAL_ENV/bin/python')
"   fallback
let g:deoplete#sources#jedi#extra_path='/bin/python'
let g:jedi#auto_initialization = 0
" Use deoplete.
let g:deoplete#enable_at_startup = 1
let g:deoplete#auto_completion_start_length = 0
let g:deoplete#enable_camel_case = 1
" setting a little delay for windows to appear
"call deoplete#custom#option('auto_complete_delay', 50)


" Goyo / Limelight
" automating limelight plugin to follow goyo
"autocmd! User GoyoEnter Limelight
"autocmd! User GoyoLeave Limelight!


" vim-tmux-navigator
let g:tmux_navigator_no_mappings = 0


" delimitMate
let delimitMate_expand_cr = 1


" nvim lua colorizer
"set termguicolors
"lua require'colorizer'.setup()
