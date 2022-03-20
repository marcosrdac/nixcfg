" --- automation --- "
" editing from where you were
au BufReadPost * call EditAtLastPosition()
" set filetype if not already set
autocmd BufNewFile,BufRead * AutoSetFiletype
" deletes trailing whitespace on save
"autocmd BufWritePre * RmTrailingSpaces
" saving and loading fold views
"DONT KNOW
"" fold based on indent level and manual choices
""augroup vimrc
""  au BufReadPre * setlocal foldmethod=indent
""  au BufWinEnter * if &fdm == 'indent' | setlocal foldmethod=manual | endif
""augroup END
"" xrdb whenever Xdefaults or Xresources are updated
"autocmd BufWritePost ~/.Xresources,~/.Xdefaults !xrdb %
"" update crontab when editing crontab file
""autocmd BufWritePost ~/.config/cron/crontab !crontab %
autocmd BufWritePost user.cron !crontab %
" update root crontab when editing root crontab file
"  Add to /etc/sudoers: "Defaults rootpw"
autocmd BufWritePost root.cron !st -e sudo crontab %
" generate site html files after _content files edition
" NOT WORKING IM DOING SOMETHING STUPID
"autocmd BufWritePost /home/marcosrdac/projects/site/marcosrdac.github.io/_content !python /home/marcosrdac/projects/site/marcosrdac.github.io/maker.py
"" st + tmux + vim with correct cursor

"if exists('$TMUX')
"    let &t_SI = "\<Esc>Ptmux;\<Esc>\e[6 q\<Esc>\\"
"    let &t_SR = "\<Esc>Ptmux;\<Esc>\e[4 q\<Esc>\\"
"    let &t_EI = "\<Esc>Ptmux;\<Esc>\e[2 q\<Esc>\\"
"else
"    let &t_SI = "\e[6 q"
"    let &t_SR = "\e[4 q"
"    let &t_EI = "\e[2 q"
"endif
