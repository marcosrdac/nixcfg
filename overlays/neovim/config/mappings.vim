" --- mappings --- "

" setting leader
"let mapleader=" "
"let mapleader = "\<Space>" 

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
"map <silent> <leader>c :Goyo<CR>

"Nix
autocmd FileType nix inoremap ,meta meta = with lib; {<Enter>description = "<++>";<Enter>homepage = "<++>";<Enter>license = licenses.<++>;<Enter>platforms.<++>;<Enter>maintainers = with maintainers; [ atila ];<Enter>};<Esc>6k^i
