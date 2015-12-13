if exists('g:loaded_ag') | finish | endif
let s:cpo_save = &cpo
set cpo&vim

try
  call ag#opts#init()
catch
  echom v:exception | finish
endtry

try
  call ag#operator#init()
catch /E117:/
  " echom "Err: function not found or 'kana/vim-operator-user' not installed"
endtry


" NOTE: You must, of course, install ag / the_silver_searcher
command! -bang -nargs=* -complete=file Ag           call ag#Ag('grep<bang>',<q-args>)
command! -bang -nargs=* -complete=file AgAdd        call ag#Ag('grepadd<bang>', <q-args>)
command! -bang -nargs=* -complete=file AgBuffer     call ag#paths#buffers('grep<bang>',<q-args>)
command! -bang -nargs=* -complete=file AgFromSearch call ag#args#slash('grep<bang>', <q-args>)
command! -bang -nargs=* -complete=file AgFile       call ag#Ag('grep<bang> -g', <q-args>)
command! -bang -nargs=* -complete=help AgHelp       call ag#paths#help('grep<bang>',<q-args>)

command! -bang -nargs=* -complete=file LAg          call ag#Ag('lgrep<bang>', <q-args>)
command! -bang -nargs=* -complete=file LAgAdd       call ag#Ag('lgrepadd<bang>', <q-args>)
command! -bang -nargs=* -complete=file LAgBuffer    call ag#paths#buffers('lgrep<bang>',<q-args>)
command! -bang -nargs=* -complete=help LAgHelp      call ag#paths#help('lgrep<bang>',<q-args>)

command! -count                        AgRepeat     call ag#group#repeat(<count>)
command! -count -nargs=*               AgGroup      call ag#group#search(<count>, 0, '', <q-args>) "deprecated
command! -count -nargs=*               AgGroupFile  call ag#group#search(<count>, 0, <f-args>) "deprecated
command! -count -nargs=*               Agg          call ag#group#search(<count>, 0, '', <q-args>)
command! -count -nargs=*               AggFile      call ag#group#search(<count>, 0, <f-args>)


nnoremap <silent> <Plug>(ag-group)  :<C-u>call ag#group#tracked_search(v:count, 0)<CR>
xnoremap <silent> <Plug>(ag-group)  :<C-u>call ag#group#tracked_search(v:count, 1)<CR>
nnoremap <silent> <Plug>(ag-repeat) :<C-u>call ag#group#repeat(v:count)<CR>
" TODO: add <Plug> mappings for Ag* and LAg*


if !(exists("g:ag.no_default_mappings") && g:ag.no_default_mappings)
  let s:ag_mappings = [
    \ ['nx', '<Leader>af', '<Plug>(ag-qf)'],
    \ ['nx', '<Leader>aa', '<Plug>(ag-qf-add)'],
    \ ['nx', '<Leader>ab', '<Plug>(ag-qf-buffer)'],
    \ ['nx', '<Leader>as', '<Plug>(ag-qf-searched)'],
    \ ['nx', '<Leader>aF', '<Plug>(ag-qf-file)'],
    \ ['nx', '<Leader>aH', '<Plug>(ag-qf-help)'],
    \
    \ ['nx', '<Leader>Af', '<Plug>(ag-loc)'],
    \ ['nx', '<Leader>Aa', '<Plug>(ag-loc-add)'],
    \ ['nx', '<Leader>Ab', '<Plug>(ag-loc-buffer)'],
    \ ['nx', '<Leader>AF', '<Plug>(ag-loc-file)'],
    \ ['nx', '<Leader>AH', '<Plug>(ag-loc-help)'],
    \
    \ ['nx', '<Leader>ag', '<Plug>(ag-group)'],
    \ ['n',  '<Leader>ra', '<Plug>(ag-repeat)'],
    \
    \ ['nx', '<Leader>ad', '<Plug>(operator-ag-qf)'],
    \ ['nx', '<Leader>Ad', '<Plug>(operator-ag-loc)'],
    \ ['nx', '<Leader>Ag', '<Plug>(operator-ag-grp)'],
    \]
endif


if exists('s:ag_mappings')
  for [modes, lhs, rhs] in s:ag_mappings
    for m in split(modes, '\zs')
      if mapcheck(lhs, m) ==# '' && maparg(rhs, m) !=# '' && !hasmapto(rhs, m)
        exe m.'map <silent>' lhs rhs
      endif
    endfor
  endfor
endif


let g:loaded_ag = 1
let &cpo = s:cpo_save
unlet s:cpo_save
