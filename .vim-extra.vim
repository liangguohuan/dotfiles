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
  silent call system(printf('cliclick "t:/%s"', a:kw))
  silent call system('cliclick "kp:return"')
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

