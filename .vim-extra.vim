" Extra file, option codes for vim
" vim: fdm=marker ts=2 sw=2 sts=2 expandtab

nmap cof :set foldenable!<CR>

cabbrev mcf MultipleCursorsFind
cabbrev mle MultiLineExecNmode

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
      \ map(split(system('/usr/games/fortune -s | /usr/games/cowsay -W 60'), '\n'), '"   ". v:val')

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
if g:colors_name != "molokai"
  let g:easytags#disable#highlight = 1
endif

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
        \ 'phpClassesTag'        : {'ctermfg' : 208},
        \ 'phpFunctionsTag'      : {'ctermfg' : 118},
        \ 'pythonFunctionTag'    : {'ctermfg' : 118},
        \ 'pythonMethodTag'      : {'ctermfg' : 118},
        \ 'pythonClassTag'       : {'ctermfg' : 208},
        \ 'vimAutoGroupTag'      : {'ctermfg' : 118},
        \ 'vimCommandTag'        : {'ctermfg' : 208},
        \ 'vimFuncNameTag'       : {'ctermfg' : 118},
        \ 'vimScriptFuncNameTag' : {'ctermfg' : 118},
        \ 'shFunctionTag'        : {'ctermfg' : 118},
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

fun! GetColorFromBackground()
  redir => output
  silent hi Normal
  redir END
  let mlist = matchlist(output, 'ctermbg=\(\d\+\)')
  if empty(mlist)
    let mlist = matchlist(output, 'guibg=#\(\w\+\)')
    let bgcolor = ''
    if !empty(mlist)
      let bgcolor = mlist[1]
    endif
  else
    " must get tool xtermcolor from https://github.com/broadinstitute/xtermcolor
    let soutput = system(printf("xtermcolor list | grep 'ansi=%s;'", mlist[1]))
    let mlist2 = matchlist(soutput, 'rgb=#\(\w\+\)')
    let bgcolor = mlist2[1]
  endif
  if bgcolor == '' | let bgcolor = '121212' | endif
  return bgcolor
endf

fun! Color2RGB(bgcolor)
  let s:r = eval(printf('0x%s', strpart(a:bgcolor, 0, 2)))
  let s:g = eval(printf('0x%s', strpart(a:bgcolor, 2, 2)))
  let s:b = eval(printf('0x%s', strpart(a:bgcolor, 4, 2)))
  return printf('%d,%d,%d', s:r, s:g, s:b)
endfun

fun! GnomeTerminalBgWithVimBg()
  if !has("gui_running")
    let bgcolor = GetColorFromBackground()
    if bgcolor != ''
      let rgb = printf("'rgb(%s)'", Color2RGB(bgcolor))
      let profile_path = '/org/gnome/terminal/legacy/profiles:'
      let cmdstr = printf('dconf write %s/:`dconf read %s/default | tr -d %s`/background-color "%s"', profile_path, profile_path, "\"'\"", rgb)
      " echom cmdstr
      call system(cmdstr)
      echo 'gnome terminal background color has been reset, color is: %s' . rgb
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

autocmd ColorScheme * call WatchColorScheme()

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
" => Language Helper
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => clang helper
autocmd FileType c nmap <buffer> K :silent call system("tmux splitw -p 100 'exec vman <C-r>=expand('<cword>')<CR>' \; tmux resize -Z")<CR>

" => PHP helper
command! PHPFuncHelper call PHPFuncHelper()
function! PHPFuncHelper()
  let s:method = substitute(expand('<cword>'), '_', '-', 'g')
  let s:uri = substitute($PHPFUNCTEMPLATE, '{{method}}', s:method, '')
  let s:file = get(matchlist(s:uri, ':\/\/\(.*html\)'), 1)
  if !filereadable(s:file)
    echo 'php doc request failed'
    return
  endif
  let s:cmd = printf('xdg-open %s', s:uri)
  silent call system(s:cmd)
endfunction

" go helper
autocmd FileType go nnoremap <buffer> K :call GoApiDocHelper()<CR>
function! GoApiDocHelper()
  call ApiDocHelper($GOAPITEMPLATE)
endfunction

" javascript helper
autocmd FileType javascript nnoremap <buffer> K :call NodeApiDocHelper()<CR>
function! NodeApiDocHelper()
  call ApiDocHelper($NODEAPITEMPLATE)
endfunction

" template format: file:///home/hanson/Data/docs-web/nodejs.org/api/%s.html#%s
function! GetApiRealPkg(pkg)
  let s:matchparts = []
  " golang
  call add(s:matchparts, printf('\s\+%s\s\+[\''"]\(.*\)[\''"]', a:pkg))
  call add(s:matchparts, printf('\s\+[\''"]\(.*%s\)[\''"]', a:pkg))
  " nodejs
  call add(s:matchparts, printf('\s\+%s\s\+[^.]*[\''"]\(.*\)[\''"]', a:pkg))

  let s:lines = getline(1, line('.'))
  for s:line in s:lines
    for s:matchpart in s:matchparts 
      if match(s:line, s:matchpart) > -1
        return get(matchlist(s:line, s:matchpart), 1)
      endif
    endfor
  endfor
  return a:pkg
endfunction

function! ApiDocHelper(template)
  " parse api on curline
  let s:line = getline('.')
  let s:matchlist = matchlist(s:line, printf('\(\w\+\)\.\(\(\w\+\.\)*%s\)', expand('<cword>')))
  let s:pkg = get(s:matchlist, 1)
  let s:method = get(s:matchlist, 2)
  " find really pkg
  let s:pkg = GetApiRealPkg(s:pkg)
  " handle uri
  let s:uri = substitute(a:template, '{{pkg}}', s:pkg, 'g')
  let s:uri = substitute(s:uri, '{{method}}', s:method, 'g')
  " check file exists
  let s:file = get(matchlist(s:uri, ':\/\/\(.*html\)'), 1)
  if !filereadable(s:file)
    echo 'Api doc request failed'
    return
  endif
  " find fragment
  let s:fragment = strpart(s:uri, stridx(s:uri, '#'))
  let s:cmd = printf('grep -ioP "%s[\w]*" %s | head -1', s:fragment, s:file)
  let s:rfragment = system(s:cmd)
  if s:rfragment != ''
    let s:uri = substitute(s:uri, s:fragment, s:rfragment, '')
  endif
  " open uri with browse
  if $is_tmux
    let s:uri = substitute(s:uri, '#', '##', '')
    let s:cmd = printf('tmux run ''tmux splitw "lynx -vikeys %s" \; resizep -Z''', s:uri)
  else
    let s:cmd = printf('xdg-open %s', s:uri)
  endif
  echom s:cmd
  silent call system(s:cmd)
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
let @j = "$F.hvF-hd"
let @k = "pvF-S]lvf d"
let @a = "@j02f h@k"
let @t = "02lva]ld2f p"

