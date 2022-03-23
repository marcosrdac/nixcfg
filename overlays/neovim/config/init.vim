" init.vim (neovim configuration file)

" --- setting vim path --- "
if has('nvim')
    let g:vimpath = expand('$XDG_CONFIG_HOME/nvim')
else                                          
    let g:vimpath = expand('$XDG_CONFIG_HOME/vim')
    set nocompatible
    filetype plugin on
    syntax on
endif


" --- plugin management --- "
call plug#begin(g:vimpath.'/plugged')
    " navigation
    Plug 'unblevable/quick-scope'          " find that word
    Plug 'christoomey/vim-tmux-navigator'  " tmux navigation integration

    " vim-gnupg
    Plug 'jamessan/vim-gnupg'

    " vimwiki
    Plug 'vimwiki/vimwiki'
    " calendar-vim integration
    Plug 'mattn/calendar-vim'

    " viewing colors
    Plug 'norcalli/nvim-colorizer.lua'     " colors become colored
    "Plug 'rrethy/vim-hexokinase',
    "    \ { 'do': 'make hexokinase' }

    " syntax checkers
    Plug 'dense-analysis/ale'            " asynchronous syntax checking

    " grammar checkers (backends to languagetool, pacman install it)
    if has('nvim')
        Plug 'vigoux/LanguageTool.nvim'  " asynchronous grammar checker
    else
        Plug 'dpelle/vim-LanguageTool'   " grammar checker
    endif

    " focused writing
    Plug 'junegunn/goyo.vim'       " center text
    Plug 'junegunn/limelight.vim'  " focused writing

    " File managing
    "" NERDTree
    Plug 'scrooloose/nerdtree'                      " file system explorer
    Plug 'Xuyuanp/nerdtree-git-plugin'              " NERDTree git marks
    Plug 'ryanoasis/vim-devicons'                   " NERDTree file icons
    Plug 'tiagofumo/vim-nerdtree-syntax-highlight'  " highlights filetypes
    "" ctrlP
    Plug 'ctrlpvim/ctrlp.vim'                       " file fuzyfinder

    " easy-writting
    "" bracketting
    Plug 'jiangmiao/auto-pairs'            " closing brackets
    Plug 'tpope/vim-surround'              " changing brackets
    Plug 'tpope/vim-repeat'                " needed to . with vim-surround
    "" commenting
    Plug 'scrooloose/nerdcommenter'        " (un)comments text
    "" deoplete (auto-completion)
    if has('nvim')
        Plug 'Shougo/deoplete.nvim',
            \ { 'do': ':UpdateRemotePlugins' }
    else
        Plug 'Shougo/deoplete.nvim'
        Plug 'roxma/nvim-yarp'
        Plug 'roxma/vim-hug-neovim-rpc'
    endif
    "" Deoplete
    Plug 'zchee/deoplete-jedi'     " deoplete python source
    "" TabNine deoplete: general completions every filetype
    if has('win32') || has('win64')
        Plug 'tbodt/deoplete-tabnine',
            \ { 'do': 'powershell.exe .\install.ps1' }
    else
        Plug 'tbodt/deoplete-tabnine',
            \ { 'do': './install.sh' }
    endif
    " HTML
    Plug 'mattn/emmet-vim'  " easy html typing

    " correct syntax highlighting for different filetypes
    Plug 'VebbNix/lf-vim'                   " lfrc
    Plug 'drmingdrmer/vim-syntax-markdown'  " markdown with latex
    Plug 'dart-lang/dart-vim-plugin'        " dart syntax highlighting
    Plug 'thosakwe/vim-flutter'             " flutter tools
    Plug 'JuliaEditorSupport/julia-vim'     " julia syntax highlighting
    
    Plug 'tshirtman/vim-cython'             " cython filetype and syntax

call plug#end()


" --- setting variables --- "
exec 'source '.g:vimpath.'/variables.vim'
" --- loading scripts --- "
exec 'source '.g:vimpath.'/scripts.vim'
" --- loading automation settings --- "
exec 'source '.g:vimpath.'/automation.vim'
" --- plugin settings --- "
exec 'source '.g:vimpath.'/plugins.vim'
" --- abbreviations --- "
exec 'source '.g:vimpath.'/abbreviations.vim'


" --- general settings --- "
" aesthetics
colorscheme wal
"colorscheme default
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




" --- mappings --- "

" setting leader
let mapleader=" "

" plugins
"   nerdtree
map <C-n> :NERDTreeToggle<CR>
" NERDCommenter <c-_> means <c-/>
nmap <c-_> <plug>NERDCommenterToggle
vmap <c-_> <plug>NERDCommenterToggle
"   ctrlp
map <space>o :CtrlP<CR>


" -- splitscreens -- "

" <c-{direction}>
"nnoremap <silent> {Left-Mapping} :TmuxNavigateLeft<cr>
"nnoremap <silent> {Down-Mapping} :TmuxNavigateDown<cr>
"nnoremap <silent> {Up-Mapping} :TmuxNavigateUp<cr>
"nnoremap <silent> {Right-Mapping} :TmuxNavigateRight<cr>
"nnoremap <silent> {Previous-Mapping} :TmuxNavigatePrevious<cr>

" -- bracketing -- "
"inoremap ( ()<++><Esc>4hi
"inoremap ( ()<++><C-o>4h
"inoremap [ []<++><Esc>4hi
"inoremap { {}<++><Esc>4hi
"inoremap < <><++><Esc>4hi
"inoremap " ""<++><Esc>4hi
"inoremap ' ''<++><Esc>4hi
"inoremap (<Space> (
"inoremap [<Space> [
"inoremap {<Space> {
"inoremap <<Space> <
"inoremap "<Space> "
"inoremap '<Space> '
"inoremap () ()
"inoremap [] []
"inoremap {} {}
"inoremap <> <>
"inoremap "" ""
"inoremap '' ''

" -- function buttons -- "
" saving with <F1>
nmap <F1> :w<CR>
imap <F1> <C-o>:w<CR>
" fix code
nmap <F2> :ALEFix<CR>
imap <F2> <C-o>:ALEFix<CR>

" mappings
nnoremap <BS> :q<CR>
nnoremap <C-\> :set number!<CR>
map <F7> :setlocal spell! spelllang=pt-BR,en_us<CR>
map <F8> :set hlsearch!<CR>

" -- navigation through marks -- "
" creating marks
inoremap m<leader><leader> <++>
nnoremap m<leader><leader> a<++><Esc>
" forward finding marks
inoremap f<leader><leader> <Esc>/<++><Enter>:noh<CR>"_c4l
vnoremap f<leader><leader> <Esc>/<++><Enter>:noh<CR>"_c4l
nnoremap f<leader><leader> <Esc>/<++><Enter>:noh<CR>"_c4l
" backward finding marks
inoremap F<leader><leader> <Esc>?<++><Enter>:noh<CR>"_c4l
vnoremap F<leader><leader> <Esc>?<++><Enter>:noh<CR>"_c4l
nnoremap F<leader><leader> <Esc>?<++><Enter>:noh<CR>"_c4l

" -- date stuff -- "
"inoremap ;df <++><Esc>:r !date '+\%Y\%m\%d\%H\%M\%S'<Enter>0v$h"dd"_dd?<++><Enter>v3l"dpa
"inoremap ;dl <++><Esc>:r !date '+[\%Y\%m\%d\%H\%M\%S+-<++>]'<Enter>0v$h"dd"_dd?<++><Enter>v3l"dpa<Space><++><Esc>2?<++><Enter>"_c4l
inoremap ;d <++><Esc>:r !date '+\%Y\%m\%d'<Enter>0v$h"dd"_dd?<++><Enter>v3l"dpa
"inoremap ;dc <++><Esc>:r !date '+\%d/\%m/\%Y'<Enter>0v$h"dd"_dd?<++><Enter>v3l"dpa

" goyo plugin
"   center writing
map <silent> <leader>c :Goyo \| set linebreak<CR>
