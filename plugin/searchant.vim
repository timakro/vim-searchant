" searchant.vim - Vim plugin for improved search highlighting
" Author:   Tim Schumacher <tim@timakro.de>
" License:  GPLv3
" Version:  1.0.2

if exists("g:loaded_searchant")
    finish
endif
let g:loaded_searchant = 1

" default variables
if !exists("g:searchant_map_stop")
    let g:searchant_map_stop = 1
endif
if !exists("g:searchant_all")
    let g:searchant_all = 1
endif
if !exists("g:searchant_current")
    let g:searchant_current = 1
endif

" default highlight current style
if !hlexists("SearchCurrent")
    highlight SearchCurrent ctermbg=red ctermfg=0 guibg=#ff0000 guifg=#000000
endif

function s:SID()
    return matchstr(expand('<sfile>'), '<SNR>\zs\d\+\ze_SID$')
endfun

function! s:Stop()
    set nohlsearch
    if exists("s:current_match_id")
        call matchdelete(s:current_match_id)
        unlet s:current_match_id
    endif
endfunction

function! s:Update()
    call s:Stop()
    if g:searchant_all
        set hlsearch
    endif
    if g:searchant_current
        let pattern = '\%'.line('.').'l\%'.col('.').'c\%('.@/.'\)'
        if &ignorecase
            let pattern .= '\c'
        endif
        let s:current_match_id = matchadd("SearchCurrent", pattern, 2)
    endif
endfunction

" update highlighting after various search actions
function! s:OnCommand()
    if getcmdtype() == "/" || getcmdtype() == "?"
        return "\<CR>:call <SNR>".s:SID()."_Update()\<CR>"
    else
        return "\<CR>"
    endif
endfunction
cnoremap <silent> <expr> <CR> <SID>OnCommand()
nnoremap <silent> * *:call <SID>Update()<CR>
nnoremap <silent> # #:call <SID>Update()<CR>
nnoremap <silent> g* g*:call <SID>Update()<CR>
nnoremap <silent> g# g#:call <SID>Update()<CR>
nnoremap <silent> n n:call <SID>Update()<CR>
nnoremap <silent> N N:call <SID>Update()<CR>

" define mapping to stop highlighting
nnoremap <silent> <unique> <Plug>SearchantStop :call <SID>Stop()<CR>
if g:searchant_map_stop
    nmap <unique> <C-C> <Plug>SearchantStop
endif
