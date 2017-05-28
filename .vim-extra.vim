" gv.vim command
cabbrev gv GV
cabbrev sel Select
cabbrev mcf MultipleCursorsFind
cabbrev mle MultiLineExecNmode
nmap coq :RainbowParentheses!!<CR>
nmap coG :GV<CR>

let g:airline#extensions#tmuxline#enabled = 0

" syntastic
let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 0
let g:syntastic_check_on_wq = 0

if has("gui_running")
let g:startify_disable_at_vimenter = 1
endif
let g:startify_custom_header =
            \ map(split(system('/usr/games/fortune | /usr/games/cowsay'), '\n'), '"   ". v:val')

let g:startify_list_order = [
            \ ['   sessions:'],
            \ 'sessions',
            \ ]
" GoldenRatioToggle effect goyo
let g:goyo_width = 100 
" let g:airline_theme="base16_grayscale" 
let g:airline_theme="ravenpower" 
if has('gui_running')
let g:airline_theme="molokai" 
endif
" let g:gruvbox_contrast_dark = 'hard'
" let g:airline_theme="gruvbox" 
" colorscheme gruvbox

" colorscheme setting
autocmd VimEnter,BufWritePost,ColorScheme,SessionLoadPost * call ColorSchemePatch()

" Toggle EasyTags Highlight
"{{{
" nohi by default
let g:easytags#disable#highlight = 1
nnoremap cok :ToggleEasyTagsHighlight<CR>
command! ToggleEasyTagsHighlight call ToggleEasyTagsHighlight()

function! ToggleEasyTagsHighlight() abort
  if exists('g:easytags#disable#highlight')
    unlet g:easytags#disable#highlight 
  else
    let g:easytags#disable#highlight = 1
  endif
  call EasyTagsHighlight()
endfunction

function! EasyTagsHighlight() abort
  if !exists('g:easytags#disable#highlight') 
    exe 'HighlightTags'
  endif
  let hidict = {
        \ 'phpClassesTag'        : {'ctermbg' : 3},
        \ 'phpFunctionsTag'      : {'ctermbg' : 2},
        \ 'pythonFunctionTag'    : {'ctermbg' : 8},
        \ 'pythonMethodTag'      : {'ctermbg' : 2},
        \ 'pythonClassTag'       : {'ctermbg' : 3},
        \ 'vimAutoGroupTag'      : {'ctermbg' : 8},
        \ 'vimCommandTag'        : {'ctermbg' : 3},
        \ 'vimFuncNameTag'       : {'ctermbg' : 2},
        \ 'vimScriptFuncNameTag' : {'ctermbg' : 5},
        \ 'shFunctionTag'        : {'ctermbg' : 8},
        \ }
  for key in keys(hidict)
   for ikey in keys(hidict[key]) 
     let val = exists('g:easytags#disable#highlight') ? 'NONE' : hidict[key][ikey]
     exe printf('hi %s %s=%s', key, ikey, val)
   endfor
  endfor 
endfunction
"}}}

fun! ColorSchemePatch()
  call EasyTagsHighlight()
  hi SignColumn ctermbg=NONE guibg=NONE
  hi FoldColumn ctermbg=NONE guibg=NONE
  hi GitGutterAddDefault ctermbg=NONE guibg=NONE
  hi GitGutterChangeDefault ctermbg=NONE guibg=NONE
  hi GitGutterDeleteDefault ctermbg=NONE guibg=NONE
  hi GitGutterChangeDefault ctermbg=NONE guibg=NONE
endf

let g:gitgutter_sign_added = '+'
let g:gitgutter_sign_modified = '~'
let g:gitgutter_sign_removed = '-'
let g:gitgutter_sign_removed_first_line = '^'
let g:gitgutter_sign_modified_removed = '±'
" let g:gitgutter_sign_added = 'Δ'
" let g:gitgutter_sign_modified = '✓'
" let g:gitgutter_sign_removed = 'Χ'
" let g:gitgutter_sign_removed_first_line = '—'
" let g:gitgutter_sign_modified_removed = '∓'

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => setcolorscheme autoload airlinetheme and set gnome terminal background."{{{
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""}}}
"{{{
"{{{
fun! Get16colorVimBg()
  redir => output
  silent hi Normal
  redir END
  let mlist = matchlist(output, 'ctermbg=\(\d\+\)')
  if empty(mlist)
    let mlist = matchlist(output, 'guibg=#\(\d\+\)')
    let bgcolor = ''
    if !empty(mlist)
      let bgcolor = mlist[1]
    endif
  else
    " must get tool xtermcolor from https://github.com/broadinstitute/xtermcolor
    let soutput = system(printf("xtermcolor list | grep 'ansi=%s;'", mlist[1]))
    let mlist2 = matchlist(soutput, 'rgb=#\(\d\+\)')
    let bgcolor = mlist2[1]
  endif
  if bgcolor != ''
    let bgcolor16 = '#' . repeat(strpart(bgcolor, 0, 2), 2) . repeat(strpart(bgcolor, 2, 2), 2) . repeat(strpart(bgcolor, 4, 2), 2)
  else
    let bgcolor16 = ''
  endif
  return bgcolor16
endf
"}}}
fun! GnomeTerminalBgWithVimBg()
  if !has("gui_running")
    let bgcolor16 = Get16colorVimBg()
    if bgcolor16 != ''
      let cmdstr = printf('gconftool-2 -s -t string /apps/gnome-terminal/profiles/Profile0/background_color "%s"', bgcolor16)
      call system(cmdstr)
      echo 'gnome terminal background color has been reset, color is: ' . bgcolor16
    endif
  endif
endf

fun! GetCurrColorScheme()
  redir => output
  silent colorscheme
  redir END
  let currscheme = substitute(output, '\n', '', 'g')
  return currscheme
endf

fun! AirlineThemeChanged()
  let currscheme = GetCurrColorScheme()
  try
    if match(currscheme, 'monokai') > -1
      exe 'AirlineTheme bubblegum'
    elseif match(currscheme, 'molokai') > -1
      exe 'silent AirlineTheme base16_grayscale'
    else
      exe printf('silent AirlineTheme %s', currscheme)
    endif
  catch 
    donothing  
  endtry
endf

fun! WatchColorScheme()
  let currscheme = GetCurrColorScheme()
  if exists('g:colorschemebefore') && currscheme == g:colorschemebefore
  else
    call AirlineThemeChanged()
    call GnomeTerminalBgWithVimBg()
    hi clear SignColumn
    hi SignColumn ctermbg=NONE guibg=NONE
    let g:colorschemebefore = currscheme
  endif
endf

" au ColorScheme * call WatchColorScheme()

"}}}

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => change foldtext"{{{
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""}}}
"{{{
function! FillLeftChar(str, len, ...) abort
" " too slow via python ...
" python << EOF
" import vim
" str = vim.eval('a:str')
" len = vim.eval('a:len')
" char = ' ' if int(vim.eval('a:0')) == 0 else vim.eval('a:1')
" str = str.rjust(int(len), char)
" vim.command('return "%s"' % str)
" EOF
let char = a:0 == 0 ? ' ' : a:1
let slen = strlen(a:str)
let xlen = a:len < slen ? 0 : a:len - slen
return repeat(char, xlen) . a:str
endfunction

function! MarkerTypeFoldText()
  let ms = '{' . '{{'
  let str = (v:foldend - v:foldstart + 1) . ' lines'
  let str = FillLeftChar(str, 9)
  let str = repeat(v:folddashes, 2) . str . ': '
  if substitute(getline(v:foldstart), ' ', '', 'g') == '"' . ms
    let line = getline(v:foldstart + 1) 
  else
    let line = getline(v:foldstart)
  endif 
  let line = substitute(line, '^"', '', '')
  let line = substitute(line, '^ ', '', '')
  let str = str . line
  let ret = substitute(str, ms, '', '')
  let ret = substitute(ret, '"$', ' ', '')
  return ret
endfunction
" set foldtext=MarkerTypeFoldText()
"}}}

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Search command via xdotool
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
command! -range -nargs=1 Search call SearchInParagraph(<line1>, <line2>, <q-args>)

function! SearchInParagraph(line1, line2, kw)
    if a:line1 == a:line2
        let range = GetRangInParagraph()
        let s:line1 = range[0]
        let s:line2 = range[1]
    else
        let s:line1 = a:line1
        let s:line2 = a:line2
    endif
    call SearchViaXdotool(printf('\\%%>%dl\\%%<%dl%s', s:line1, s:line2, a:kw))
endfunction

function! SearchViaXdotool(kw)
    silent call system(printf('xdotool type "/%s"', a:kw))
    silent call system('xdotool key ctrl+m')
endfunction

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => testing
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Notice: gitcommit will be failed if do this.
" function! GetTmuxWindowName() abort
  " let tw = ''
  " let tmuxlist = system("tmux list-windows")
  " if tmuxlist != ''
    " let tw = matchlist(tmuxlist, '\([^ ]*\)\*')[1]
  " endif
  " return tw
" endfunction
"
" Tips: <Esc> key in macro is illegal
let @k = "$F.hvF-hd"
let @j = "pvF-S]lvf d"


" vim: fdm=marker ts=4 sw=4 sts=4 expandtab
