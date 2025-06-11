" general settings

" aesthetics
"colorscheme default
colorscheme wal
" splits open bellow/right by default
set splitbelow splitright
" line numbering
set number relativenumber
" highlighting searches
set hlsearch
" colors for ctrl+n/p (terminal colors)
"hi PmenuSel ctermfg=5 ctermbg=8
" not redrawing screen while running macros
set lazyredraw
" tab completion in command line
set wildmenu
set wildmode=list:longest,full
" Enable folding
set foldmethod=indent
set foldcolumn=0
set foldlevel=99
" using case insensitive on searches (not good...)
"set ic
" mouse selection in VIM
set mouse=a
" making a link between OS' and VIM's clipboard space (+ or *)
"   something with unnamed or unnamedplus
set clipboard=unnamedplus
" making backups and undofiles (make sure the directory exists)
set dir=~/.cache/vim/swap//
set undodir=~/.cache/vim/undo//
set backupdir=~/.cache/vim//
set backup
set undofile
" spelling
"   enabling dictionary search when spell is on
set complete+=kspell
" getting system colors, not made up ones
set notermguicolors
