" searchant.vim - Vim plugin for improved search highlighting
" Author:   Tim Schumacher <tim@timakro.de>
" License:  GPLv3
" Version:  1.0.6

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

function s:Start()
    if g:searchant_all
        set hlsearch
    endif
    if g:searchant_current
        let pattern = '\%'.line('.').'l\%'.col('.').'c\%('.@/.'\)'
        if &ignorecase
            let pattern .= '\c'
        endif
        let w:current_match_id = matchadd("SearchCurrent", pattern, 2)
    endif
    " open fold
    try
        normal! zo
        catch /^Vim\%((\a\+)\)\=:E490/
    endtry
endfunction

function s:Stop()
    set nohlsearch
    if exists("w:current_match_id")
        call matchdelete(w:current_match_id)
        unlet w:current_match_id
    endif
endfunction

function s:Update()
    call s:Stop()
    call s:Start()
endfunction

" update highlighting after search commands
function s:OnCommand()
    if getcmdtype() == "/" || getcmdtype() == "?"
        call s:Stop()
        return "\<CR>:call <SNR>".s:SID()."_Start()\<CR>"
    else
        return "\<CR>"
    endif
endfunction
cnoremap <silent> <unique> <expr> <CR> <SID>OnCommand()

" update highlighting after search mappings
function s:MapUpdate(name)
    let recall = maparg(a:name, "n")
    if !len(recall)
        let recall = a:name
    endif
    execute "nnoremap <silent> ".a:name." ".recall.":call <SID>Update()<CR>"
endfunction
call s:MapUpdate("*")
call s:MapUpdate("#")
call s:MapUpdate("g*")
call s:MapUpdate("g#")
call s:MapUpdate("n")
call s:MapUpdate("N")

" define mapping to stop highlighting
nnoremap <silent> <unique> <Plug>SearchantStop :call <SID>Stop()<CR>
if g:searchant_map_stop
    nmap <unique> <C-C> <Plug>SearchantStop
endif
