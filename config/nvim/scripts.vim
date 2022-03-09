function! EditAtLastPosition()
    if line("'\"") > 0
        if line("'\"") <= line("$")
            exe("norm '\"")
        else
            exe("norm $")
        endif
    endif
endfunction


function! AutoSetFiletype()
    if did_filetype()       " filetype already set..
        return 0             " ..don't do these checks
    endif
    if getline(1) =~ '^#!.*\<mine\>'
        setfiletype mine
    elseif getline(1) =~? '\<drawing\>'
        setfiletype drawing
    endif
endfunction
command! AutoSetFiletype call AutoSetFiletype()


" Multipurpose command to preserve vim state
function! Preserve(command)
  " Preparation: save window state
  let l:saved_winview = winsaveview()
  " execute argument maintaining searched patterns
  keeppatterns execute a:command
  " Clean up: restore previous window position
  call winrestview(l:saved_winview)
endfunction
command! RmTrailingSpaces call Preserve("%s/\\s\\+$//e")
