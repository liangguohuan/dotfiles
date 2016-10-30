""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Unite"{{{
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""}}}
" {{{
" The prefix key.
nnoremap    [unite]   <Nop>
nmap      ; [unite]

cabbrev uba UniteBookmarkAdd
" Unite -vertical -start-insert -winwidth=30 -direction=botright outline

nnoremap <silent> [unite]x :<C-u>Unite output/shellcmd<CR>
nnoremap <silent> [unite]s :<C-u>Unite grep<CR>
nnoremap <silent> [unite]r :<C-u>Unite register -unique<CR>
nnoremap <silent> [unite]c :<C-u>UniteWithCurrentDir file -start-insert -prompt=> -buffer-name=files<CR>
nnoremap <silent> [unite]; :<C-u>Unite source  -prompt=> -start-insert<CR>
nnoremap <silent> [unite]o :<C-u>Unite outline -prompt=> -start-insert<CR>
nnoremap <silent> [unite]b :<C-u>Unite buffer  -prompt=> -start-insert<CR>
nnoremap <silent> [unite]j :<C-u>Unite jump    -prompt=> -start-insert<CR>
nnoremap <silent> [unite]f :<C-u>Unite buffer file -buffer-name=mixed -prompt=> -start-insert<CR>
nnoremap <silent> [unite]a :<C-u>call UniteSearchRecCall()<CR>
nnoremap <silent> [unite]l :<C-u>Unite file_mru -buffer-name=files_mru -prompt=> -start-insert <CR>

fun! UniteSearchRecCall()
    let cmd = 'file_rec/async'
    " b:git_dir is from plugin vim-fugitive
    if exists('b:git_dir') 
        let cmd = 'file_rec/git'
    endif
    exe printf('Unite %s  -buffer-name=files -prompt=> -start-insert -unique -ignorecase', cmd)
endf


autocmd FileType unite call s:unite_nice_settings()

function! s:unite_nice_settings()
    " Overwrite settings.
    imap <buffer> jj        <Plug>(unite_insert_leave)
    imap <buffer> <C-c>     <Plug>(unite_exit)
    nmap <buffer> <C-c>     <Plug>(unite_exit)

    imap <buffer><expr> j unite#smart_map('j', '')
    imap <buffer> <TAB>     <Plug>(unite_select_next_line)
    imap <buffer> <C-w>     <Plug>(unite_delete_backward_path)
    imap <buffer> '         <Plug>(unite_quick_match_default_action)
    nmap <buffer> '         <Plug>(unite_quick_match_default_action)
    imap <buffer><expr> x unite#smart_map('x', "\<Plug>(unite_quick_match_choose_action)")
    nmap <buffer> x         <Plug>(unite_quick_match_choose_action)
    nmap <buffer> <C-z>     <Plug>(unite_toggle_transpose_window)
    imap <buffer> <C-z>     <Plug>(unite_toggle_transpose_window)
    imap <buffer> <C-y>     <Plug>(unite_narrowing_path)
    nmap <buffer> <C-y>     <Plug>(unite_narrowing_path)
    imap <buffer> <C-r>     <Plug>(unite_narrowing_input_history)
    nmap <buffer> <C-r>     <Plug>(unite_narrowing_input_history)

    nmap <buffer> <C-t>     <Plug>(unite_toggle_auto_preview)
    nmap <buffer> <C-q>     <Plug>(unite_print_candidate)
    nmap <buffer> <C-X>     <Plug>(unite_redraw)
    
    nnoremap <silent><buffer><expr> l
                \ unite#smart_map('l', unite#do_action('default'))

    let unite = unite#get_current_unite()
    if unite.profile_name ==# 'search'
        nnoremap <silent><buffer><expr> r     unite#do_action('replace')
    else
        nnoremap <silent><buffer><expr> r     unite#do_action('rename')
    endif

    nnoremap <silent><buffer><expr> cd     unite#do_action('lcd')
    nnoremap <buffer><expr> S      unite#mappings#set_current_filters(
                \ empty(unite#mappings#get_current_filters()) ?
                \ ['sorter_reverse'] : [])

    " Runs "split" action by <C-s>.
    imap <silent><buffer><expr> <C-s>     unite#do_action('split')
endfunction

" custom menu for unite
let g:unite_source_menu_menus = {}
let g:unite_source_menu_menus.git = {
    \ 'description' : '            gestionar repositorios git
        \                            ⌘ [espacio]g',
    \}
let logwatchadded = 'exe "Git! log --follow --diff-filter=A --find-renames=40\\% " input("path:", ".")'
function! MenuGitGremoveConfirm() abort
    let sel = confirm("Do You Really Want To RM This File ?",  "&y\n&n", 1)
    if sel == 1
        exe "Gremove"
    endif
endfunction
let g:unite_source_menu_menus.git.command_candidates = [
    \['▷ tig preview     (Tig)                           ⌘ ,gt  ', 'exe "Unite tig -no-split -auto-preview"'],
    \['▷ gitv browser    (Gitv Browser mode)             ⌘ ,gv  ', 'exe "Gitv"'],
    \['▷ gitv browser    (Gitv File mode)                ⌘ ,ge  ', 'exe "Gitv!"'],
    \['▷ git status                                      ⌘ ,gs  ', 'Gstatus'],
    \['▷ git diff                                        ⌘ ,gd  ', 'Gdiff'],
    \['▷ git commit                                      ⌘ ,gc  ', 'Gcommit'],
    \['▷ git log                                         ⌘ ,gl  ', 'exe "silent Glog \| Unite -no-empty -no-tab quickfix"'],
    \['▷ git blame                                       ⌘ ,gb  ', 'Gblame'],
    \['▷ git stage                                       ⌘ ,gw  ', 'Gwrite'],
    \['▷ git checkout                                    ⌘ ,go  ', 'Gread'],
    \['▷ git rm                                          ⌘ ,gr  ', 'exe "call MenuGitGremoveConfirm()"'],
    \['▷ git mv                                          ⌘ ,gm  ', 'exe "Gmove " input("DESTINO: ")'],
    \['▷ git push                                        ⌘ ,gp  ', 'Git! push'],
    \['▷ git pull                                        ⌘ ,gf  ', 'Git! fetch'],
    \['▷ git pull                                        ⌘ ,gx  ', 'Git! pull'],
    \['▷ git prompt                                      ⌘ ,gi  ', 'exe "Git! " input("COMANDO GIT: ")'],
    \['▷ git cd                                          ⌘ ,gj  ', 'Gcd'],
    \['▷ git () add and commmit                          ⌘ ,gg  ', 'exe "Gcommit %"'],
    \['▷ git () change last commit message               ⌘ ,ga  ', 'Gcommit --amend'],
    \['▷ git () log show last commit                     ⌘ ,gll ', 'Git! log -p -1'],
    \['▷ git () log show two days commits                ⌘ ,glo ', 'Git! log --pretty=oneline --since="2 days ago"'],
    \['▷ git () log show what added                      ⌘ ,glf ', logwatchadded],
    \['▷ git () log show current file all commit                ', 'Git! log -p -- %'],
    \['▷ git () show the repositorios info                      ', 'Git! remote -v'],
    \['▷ git () show remote url                                 ', 'Git! config --get remote.origin.url'],
    \['▷ git () last commit                                     ', 'Git! show %'],
    \['▷ git () new change                                      ', 'Git! diff HEAD %'],
    \['▷ git () recover from remote                             ', 'Git! checkout -- %'],
    \['▷ git () revert commit                                   ', 'Git  revert HEAD'],
    \['▷ git () reset commit (soft)                             ', 'Git! reset --soft HEAD~1'],
    \['▷ git () reset commit (hard)                             ', 'Git! reset --hard HEAD~1'],
    \['▷ git () reset commit (hard) and (clean) cache           ', 'Git! reset --hard HEAD~1 && git clean -fd'],
    \['▷ git () stash dirty working directory                   ', 'Git! stash'],
    \['▷ git () remove and apply a single stashed state         ', 'Git! stash pop'],
    \['▷ git () show stash list                                 ', 'Git! stash list'],
    \]


nnoremap <silent>[unite]g :Unite -prompt=> -silent -start-insert menu:git<CR>
for item in g:unite_source_menu_menus.git.command_candidates
    if stridx(item[0], ',') > -1
        let _key = split(item[0], ',')[-1]
        let _val = item[1]
        exe 'nnoremap <leader>' . _key . ' :' . _val . '<CR>'
    endif
endfor

" For ag.
if executable('ag')
  let g:unite_source_grep_command = 'ag'
  let g:unite_source_grep_default_opts = '-i --nocolor --follow --nogroup --hidden'
  let g:unite_source_grep_recursive_opt = ''
endif 

let g:unite_source_rec_async_command = ['ag', '--follow', '--nocolor', '--nogroup', '--hidden', '-g', '']

" neovim file_rec
call unite#custom#source('file_rec/neovim', 'matchers', ['converter_relative_word', 'matcher_fuzzy'])
call unite#custom#source('file_rec/neovim', 'sorters', 'sorter_rank')


" wildignore
call unite#custom#source('file,file_rec,file/async,file_rec/neovim,directory,directory_mru,directory_rec,directory_rec/async',
            \ 'ignore_pattern',
            \ 'fugitive\|.idea\|.phpcomplete')

" keymap change
augroup unite_aug
    autocmd!
    autocmd FileType unite nmap  <buffer>  s      <Plug>(unite_toggle_mark_current_candidate)
    autocmd FileType unite vmap  <buffer>  s      <Plug>(unite_toggle_mark_selected_candidates)
    autocmd FileType unite nmap  <buffer>  <Space> /
    autocmd FileType unite nmap  <buffer>  <C-b>  <Plug>(unite_delete_backward_path)
    autocmd FileType unite nmap  <buffer>  <C-y>  <Plug>(unite_redraw)
augroup END
"}}}

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => vimfiler"{{{
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""}}}
"{{{
" let g:vimfiler_as_default_explorer = 1
let g:vimfiler_safe_mode_by_default=0
nnoremap <silent> [unite]v    :<C-u>VimFiler<CR>
nnoremap <silent> <leader>vc  :<C-u>VimFilerCurrentDir<CR>
nnoremap <silent> <leader>vb  :<C-u>VimFilerBufferDir<CR>
nnoremap <silent> <leader>vd  :<C-u>VimFilerDouble<CR>
nnoremap <silent> <leader>ve  :<C-u>VimFilerExplorer<CR>
augroup vimfiler_aug
    autocmd!
    autocmd FileType vimfiler setlocal cursorline
    autocmd FileType vimfiler nmap  <buffer> <Tab> <Plug>(vimfiler_hide)
    autocmd FileType vimfiler nmap  <buffer> <C-N> <Plug>(vimfiler_switch_to_another_vimfiler)
    autocmd FileType vimfiler nmap  <buffer> s <Plug>(vimfiler_toggle_mark_current_line)
    autocmd FileType vimfiler vmap  <buffer> s <Plug>(vimfiler_toggle_mark_selected_lines)
    autocmd FileType vimfiler nmap  <buffer> <Space> /
    autocmd FileType vimfiler nmap  <buffer> <C-b> <Plug>(vimfiler_switch_to_history_directory)
augroup END
let g:vimfiler_ignore_pattern = ['^\.', 'fugitive']
"}}}

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Gitv"{{{
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""}}}
autocmd FileType gitv nmap g? :help gitv<CR>:147<CR>

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => vim-tmux-navigator"{{{
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""}}}
" force everywhere
autocmd BufEnter * nnoremap <silent> <buffer> <C-h> :TmuxNavigateLeft<cr>
autocmd BufEnter * nnoremap <silent> <buffer> <C-j> :TmuxNavigateDown<cr>
autocmd BufEnter * nnoremap <silent> <buffer> <C-k> :TmuxNavigateUp<cr>
autocmd BufEnter * nnoremap <silent> <buffer> <C-l> :TmuxNavigateRight<cr>
autocmd BufEnter * nnoremap <silent> <buffer> <C-\> :TmuxNavigatePrevious<cr>

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => tmux-complete.vim"{{{
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""}}}
let g:tmuxcomplete#trigger = 'omnifunc'

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => YouCompleteMe"{{{
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""}}}
if !has('nvim')
"{{{
" Do not display completion messages
" Patch: https://groups.google.com/forum/#!topic/vim_dev/WeBBjkXE8H8
" set noshowmode
" try
  " set shortmess+=c
" catch /^Vim\%((\a\+)\)\=:E539: Illegal character/
  " autocmd MyAutoCmd VimEnter *
        " \ highlight ModeMsg guifg=bg guibg=bg |
        " \ highlight Question guifg=bg guibg=bg
" endtry
"
let g:ycm_python_binary_path = g:python3_host_prog
let g:ycm_filetype_blacklist = {
            \ 'tagbar'   : 1, 'qf'        : 1, 'notes'   : 1, 'markdown' : 1, 'unite'    : 1,
            \ 'text'     : 1, 'vimwiki'   : 1, 'pandoc'  : 1, 'infolog'  : 1, 'mail'     : 1,
            \ 'vimfiler' : 1, 'gitcommit' : 1, 'leaderf' : 1, 'nerdtree' : 1, 'startify' : 1
            \ }
let g:ycm_auto_trigger = 1
let g:ycm_show_diagnostics_ui = 0
" A bug: <C-Space> map for noting, disable it for temprory, because of it trigger one snips completion will be invalid.
let g:ycm_key_invoke_completion = '<C-Space>'
let g:ycm_autoclose_preview_window_after_insertion = 1
" fixed the <s-tab>
autocmd FileType * inoremap <expr><S-Tab> pumvisible() ? '<Up>' : '<BS>'
" human keymap
inoremap <expr><C-j>  pumvisible() ? "\<Down>" : "\<C-j>"
inoremap <expr><C-k>  pumvisible() ? "\<Up>" : "\<Esc>S"
inoremap <expr><C-h>  pumvisible() ? "\<Esc>a" : "\<C-h>"
"}}}
endif

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => dpoplete.nvim"{{{
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""}}}
if has('nvim')
"{{{
" Use deoplete.
let g:deoplete#enable_at_startup = 1
" Use smartcase.
let g:deoplete#enable_smart_case = 1

" omnifunc setting
augroup omnifuncs
        autocmd!
        autocmd FileType python setlocal omnifunc=pythoncomplete#Complete
augroup end

" <C-h>, <BS>: close popup and delete backword char.
inoremap <expr><C-h> deoplete#smart_close_popup()."\<C-h>"
inoremap <expr><BS>  deoplete#smart_close_popup()."\<C-h>"

" let C-j C-k do the same thing like C-n C-p if pumvisible
inoremap <expr><C-j> pumvisible() ? "\<C-n>" : "\<C-j>"
inoremap <expr><C-k> pumvisible() ? "\<C-p>" : "\<Esc>S"
inoremap <expr><S-Tab> pumvisible() ? '<C-p>' : '<BS>'

" ,<Tab> for regular tab
inoremap <silent><expr> <TAB>
            \ pumvisible() ? "\<C-n>" :
            \ <SID>check_back_space() ? "\<TAB>" :
            \ deoplete#mappings#manual_complete()

function! s:check_back_space() abort "{{{
    let col = col('.') - 1
    return !col || getline('.')[col - 1]  =~ '\s'
endfunction"}}}

" <CR>: close popup and save indent.
inoremap <silent> <CR> <C-r>=<SID>my_cr_function()<CR>

function! s:my_cr_function() abort
    return deoplete#close_popup() . "\<CR>"
endfunction

call deoplete#custom#set('_', 'matchers', ['matcher_full_fuzzy'])

"}}}
endif

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => deoplete-jedi"{{{
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""}}}
let g:deoplete#sources#jedi#python_path = g:python3_host_prog

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => airline"{{{
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""}}}
"{{{
set laststatus=2 
set showtabline=0
set t_Co=256
" let g:airline_powerline_fonts = 1
let g:airline#extensions#tabline#enabled = 0
let g:airline#extensions#buffline#enabled = 1
let g:airline#extensions#tabline#show_tab_type = 1
let g:airline#extensions#tabline#show_splits = 0
let g:airline#extensions#tabline#switch_buffers_and_tabs = 0
let g:airline#extensions#tabline#show_buffers = 0
let g:airline#extensions#tabline#show_tabs = 0
let g:airline#extensions#tabline#buffer_nr_show = 0
let g:airline#extensions#bufferline#overwrite_variables = 1
let g:airline#extensions#branch#use_vcscommand = 0
let g:airline#extensions#branch#enabled = 1
let g:airline#extensions#syntastic#enabled = 1
let g:airline#extensions#capslock#enabled = 1
if !exists('g:airline_symbols')
let g:airline_symbols = {}
endif
let g:airline_symbols.branch    = '⭠'
let g:airline_symbols.readonly = '⭤'
let g:airline_symbols.linenr = '⭡'
let g:airline_left_sep=''
let g:airline_right_sep=''
if exists('g:colorscheme_already_seted') && g:colorscheme_already_seted == 0
    let g:airline_theme="bubblegum" 
endif

let g:airline#extensions#tmuxline#enabled = 1
let g:tmuxline_preset = 'righteous'
let g:tmuxline_separators = {
    \ 'left' : '',
    \ 'left_alt': '',
    \ 'right' : '',
    \ 'right_alt' : '',
    \ 'space' : ' '}

"}}}

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Tagbar"{{{
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""}}}
"{{{
let g:tagbar_width=30 
let g:tagbar_autofocus = 1
nnoremap <silent> cot :TagbarToggle<CR>
"}}}

"""""""""""""""""""""""""""z""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => CtrlSF"{{{
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""}}}
"{{{
let g:ctrlsf_extra_backend_args = {
            \ 'ag': '-i --ignore ".git" --nocolor --follow --nogroup --hidden'
            \ }
nmap     <C-F>f <Plug>CtrlSFPrompt
vmap     <C-F>f <Plug>CtrlSFVwordPath
vmap     <C-F>F <Plug>CtrlSFVwordExec
nmap     <C-F>w <Plug>CtrlSFCwordPath
nmap     <C-F>p <Plug>CtrlSFPwordPath
nnoremap <silent> <C-F>o :CtrlSFOpen<CR>
nnoremap <silent> <C-F>t :CtrlSFToggle<CR>
"}}}

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Gundo"{{{
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""}}}
"{{{
let g:gundo_prefer_python3 = 1
nnoremap <silent> cog :GundoToggle<CR>
"}}}

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => EasyMotion"{{{
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""}}}
"{{{
" default map:  
"   <Leader><Leader>w: motion words after cursor
"   <Leader><Leader>s: find words with char
"   <Leader><Leader>f: find words with char after cursor
"   <Leader><Leader>e: motion words with char after cursor
" map  / <Plug>(easymotion-sn)
" omap / <Plug>(easymotion-tn)
" map  n <Plug>(easymotion-next)
" map  N <Plug>(easymotion-prev)
map <Leader>l <Plug>(easymotion-lineforward)
map <Leader>j <Plug>(easymotion-j)
map <Leader>k <Plug>(easymotion-k)
map <Leader>h <Plug>(easymotion-linebackward)
map s <Plug>(easymotion-s)
let g:EasyMotion_startofline = 0 " keep cursor colum when JK motion
let g:EasyMotion_smartcase = 1 " can use '\c' and '\C' after the search keyword to change
function! s:incsearch_config(...) abort
  if g:virsual_selection_act == 0
      return incsearch#util#deepextend(deepcopy({
      \   'modules': [incsearch#config#easymotion#module({'overwin': 1})],
      \   'keymap': {
      \     "\<CR>": '<Over>(easymotion)'
      \   },
      \   'is_expr': 0
      \ }), get(a:, 1, {}))
  endif
endfunction

" incsearch.vim x fuzzy x vim-easymotion
function! s:config_easyfuzzymotion(...) abort
  return extend(copy({
  \   'converters': [incsearch#config#fuzzy#converter()],
  \   'modules': [incsearch#config#easymotion#module()],
  \   'keymap': {"\<CR>": '<Over>(easymotion)'},
  \   'is_expr': 0,
  \   'is_stay': 1
  \ }), get(a:, 1, {}))
endfunction

noremap <silent><expr> z/ incsearch#go(<SID>config_easyfuzzymotion())
noremap <silent><expr> /  incsearch#go(<SID>incsearch_config())
noremap <silent><expr> ?  incsearch#go(<SID>incsearch_config({'command': '?'}))
noremap <silent><expr> g/ incsearch#go(<SID>incsearch_config({'is_stay': 1})) 
"}}}

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => snipMate (beside <TAB> support <CTRL-j>)"{{{
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""}}}
"{{{
" ino <c-j> <c-r>=snipMate#TriggerSnippet()<cr>
" snor <c-j> <esc>i<right><c-r>=snipMate#TriggerSnippet()<cr>
"}}}

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => ultisnips"{{{
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""}}}
"{{{
" notice: snippets must make sure to be writed right, it will caused to open more then one buffer when you open one file.
" The third part snippets will be autoload as long as VunduleInstall them.
" local snippets can be loaded via g:UltiSnipsSnippetDirectories, and use UltisnipEdit to edit them.
if !has('nvim')
"{{{
let g:UltiSnipsSnippetDirectories=["~/.vim/snippets"]

let g:UltiSnipsJumpForwardTrigger="<Enter>"
let g:UltiSnipsJumpBackwardTrigger="<C-b>"

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" fixed compatible between UltiSnips and YouCompleteMe
" from: http://blog.csdn.net/qq_20336817/article/details/51115411

" help function"{{{
function! g:UltiSnips_Complete()
    call UltiSnips#ExpandSnippet()
    if g:ulti_expand_res == 0
        if pumvisible()
            return "\<C-n>"
        else
            call UltiSnips#JumpForwards()
            if g:ulti_jump_forwards_res == 0
                return "\<TAB>"
            endif
        endif
    endif
    return ""
endfunction

function! g:UltiSnips_Reverse()
    call UltiSnips#JumpBackwards()
    if g:ulti_jump_backwards_res == 0
        return "\<C-P>"
    endif

    return ""
endfunction
"}}}

if !exists("g:UltiSnipsJumpForwardTrigger")
    let g:UltiSnipsJumpForwardTrigger = "<tab>"
endif
if !exists("g:UltiSnipsJumpBackwardTrigger")
    let g:UltiSnipsJumpBackwardTrigger="<s-tab>"
endif

au InsertEnter * exec "inoremap <silent> " . g:UltiSnipsExpandTrigger     . " <C-R>=g:UltiSnips_Complete()<cr>"
au InsertEnter * exec "inoremap <silent> " . g:UltiSnipsJumpBackwardTrigger . " <C-R>=g:UltiSnips_Reverse()<cr>"
"}}}
"}}}
endif

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => neosnippets"{{{
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""}}}
if has('nvim')
"{{{
" Plugin key-mappings.
imap <C-g>     <Plug>(neosnippet_expand_or_jump)
smap <C-g>     <Plug>(neosnippet_expand_or_jump)
xmap <C-g>     <Plug>(neosnippet_expand_target)

" SuperTab like snippets behavior.
imap <expr><TAB> neosnippet#expandable_or_jumpable() ?
\ "\<Plug>(neosnippet_expand_or_jump)"
\: pumvisible() ? "\<C-n>" : "\<TAB>"
smap <expr><TAB> neosnippet#expandable_or_jumpable() ?
\ "\<Plug>(neosnippet_expand_or_jump)"
\: "\<TAB>"

" For snippet_complete marker.
if has('conceal')
  set conceallevel=2 concealcursor=niv
endif

" Enable snipMate compatibility feature.
let g:neosnippet#enable_snipmate_compatibility = 1

" Tell Neosnippet about the other snippets
let g:neosnippet#snippets_directory='~/.vim/bundle/vim-php-snippets/snippets'
let g:neosnippet#snippets_directory='~/.vim/snippets'
"}}}
endif

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => YankRing"{{{
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""}}}
"{{{
" <C-n> next yank history 
" <c-p> prev yank history
if has("win16") || has("win32")
    " Don't do anything
else
    let g:yankring_history_dir = '~/.vim/temp_dirs/'
endif
let g:yankring_window_use_bottom = 0
let g:yankring_window_height = 12

map yrs :<C-U>YRShow<cr>
map yrr :<C-U>YRSearch  
"}}}

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => vim-multiple-cursors"{{{
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""}}}
"{{{
" Key 'i' cannot be replayed at 2 cursor locations: press 'v' first to normal mode 
let g:multi_cursor_prev_key='<C-d>'
let g:multi_cursor_next_key='<C-s>'
let g:multi_cursor_skip_key='<C-x>'
let g:multi_cursor_quit_key='<Esc>'

" slow multiple_cursors in YCM
function! Multiple_cursors_before()
    if exists('g:ycm_auto_trigger') | let g:ycm_auto_trigger = 0 | endif
    if exists('g:deoplete#disable_auto_complete') | let g:deoplete#disable_auto_complete = 1 | endif
endfunction
 
function! Multiple_cursors_after()
    if exists('g:ycm_auto_trigger') | let g:ycm_auto_trigger = 1 | endif
    if exists('g:deoplete#disable_auto_complete') | let g:deoplete#disable_auto_complete = 0 | endif
endfunction
"}}}

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => surround.vim config"{{{
" Annotate strings with gettext http://amix.dk/blog/post/19678
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""}}}
"{{{
vmap Si S(i_<esc>f) 
au FileType mako vmap Si S"i${ _(<esc>2f"a) }<esc>
"}}}

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Syntastic (syntax checker)"{{{
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""}}}
"{{{
let g:syntastic_python_checkers=['pyflakes']
" let g:syntastic_phpcs_conf = "--standard=/home/hanson/.phpcs-ruleset.xml" " the variable had been invalid.
let g:syntastic_php_checkers=['php', 'phpmd']
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*

cabbrev <silent> <buffer> bd lclose\|bdelete

let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0 
"}}}

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => vim-bookmark"{{{
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""}}}
"{{{
highlight BookmarkSign ctermbg=NONE ctermfg=gray 
highlight BookmarkSign guibg=NONE guifg=#A8A8A8
highlight BookmarkAnnotationSign ctermbg=NONE ctermfg=gray
highlight BookmarkAnnotationSign guibg=NONE guifg=#A8A8A8
highlight BookmarkLineDefault ctermfg=NONE ctermbg=237
highlight BookmarkLineDefault guibg=#3c3d37 gui=NONE
highlight BookmarkAnnotationLine ctermbg=237 ctermfg=NONE
highlight BookmarkAnnotationLine guibg=#3c3d37 guifg=NONE
highlight clear SignColumn
let g:bookmark_save_per_working_dir = 1
let g:bookmark_auto_save = 1 
nmap mgj <Plug>BookmarkMoveUp
nmap mgk <Plug>BookmarkMoveDown
" let g:bookmark_highlight_lines = 1
" let g:bookmark_sign = '♥'
" let g:bookmark_annotation_sign = '⚑'
"}}}

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Vimroom"{{{
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""}}}
"{{{
let g:goyo_width = 120 
let g:goyo_margin_top = 2
let g:goyo_margin_bottom = 2
nnoremap <silent> <leader>z :Goyo<cr>
" nnoremap <silent> <leader>z :call GoyoFunc()<cr>

" let g:goyo_toggle_trigger = 0
" function! GoyoFunc()
    " if &filetype == "help"
        " let g:goyo_width = 100
    " endif
    " if g:goyo_toggle_trigger == 0
        " let g:goyo_showtabline = &showtabline
    " endif
    " execute 'Goyo'
    " if g:goyo_toggle_trigger == 1 
        " call SetColorScheme()
        " let g:goyo_toggle_trigger = 0
        " let g:goyo_width = 100
        " exec 'set showtabline=' . g:goyo_showtabline
    " else
        " let g:goyo_toggle_trigger = 1
    " endif
" endfunction 
"}}}

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => gvim-fullscreen"{{{
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""}}}
"{{{
if has("gui_running") 
    nmap <F11> <Plug>(fullscreen-toggle)
endif 
"}}}

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => vimshell"{{{
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""}}}
"{{{
" Use current directory as vimshell prompt. 
cabbrev vsh VimShell
let g:vimshell_prompt_expr = 'escape(fnamemodify(getcwd(), ":~").">", "\\[]()?! ")." "'
let g:vimshell_prompt_pattern = '^\%(\f\|\\.\)\+> '

" let g:vimshell_user_prompt = 'fnamemodify(getcwd(), ":~")'
"let g:vimshell_right_prompt = 'vcs#info("(%s)-[%b]", "(%s)-[%b|%a]")'

" if has('win32') || has('win64')
"   " Display user name on Windows.
"   let g:vimshell_prompt = $USERNAME."% "
" else
"   " Display user name on Linux.
"   let g:vimshell_prompt = $USER."% "
" endif

" Initialize execute file list.
let g:vimshell_execute_file_list = {}
call vimshell#set_execute_file('txt,vim,c,h,cpp,d,xml,java', 'vim')
let g:vimshell_execute_file_list['rb'] = 'ruby'
let g:vimshell_execute_file_list['pl'] = 'perl'
let g:vimshell_execute_file_list['py'] = 'python'
call vimshell#set_execute_file('html,xhtml', 'gexe firefox')

autocmd FileType vimshell
\ call vimshell#altercmd#define('g', 'git')
\| call vimshell#altercmd#define('i', 'iexe')
\| call vimshell#altercmd#define('l', 'll')
\| call vimshell#altercmd#define('ll', 'ls -l')
\| call vimshell#hook#add('chpwd', 'my_chpwd', 'MyChpwd')

function! MyChpwd(args, context)
  call vimshell#execute('ls')
endfunction

autocmd FileType int-* call s:interactive_settings()
function! s:interactive_settings()
endfunction 
"}}}

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Trans"{{{
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""}}}
"{{{
let g:trans_default_api = 'bing'

"}}}

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => IndentLine"{{{
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""}}}
"{{{
map <Leader>ig :<C-U>IndentLinesToggle<CR>
let g:indentLine_enabled = 0
let g:indentLine_color_term = 239
let g:indentLine_color_gui = '#586e75' 
"}}}

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => tasklist.vim"{{{
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""}}}
"{{{
let g:tlTokenList = ["FIXME", "TODO", "HACK", "NOTE", "WARN", "MODIFY", "\" => "] 
nnoremap  <Leader>td :<C-U>TaskList<CR>
"}}}

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => CamelCaseMotion"{{{
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""}}}
"{{{
" map <S-W> <Plug>CamelCaseMotion_w 
" map <S-B> <Plug>CamelCaseMotion_b
" map <S-E> <Plug>CamelCaseMotion_e
" map <silent> w <Plug>CamelCaseMotion_w
" map <silent> b <Plug>CamelCaseMotion_b
" map <silent> e <Plug>CamelCaseMotion_e
" sunmap w
" sunmap b
" sunmap e
" omap <silent> iw <Plug>CamelCaseMotion_iw
" xmap <silent> iw <Plug>CamelCaseMotion_iw
" omap <silent> ib <Plug>CamelCaseMotion_ib
" xmap <silent> ib <Plug>CamelCaseMotion_ib
" omap <silent> ie <Plug>CamelCaseMotion_ie
" xmap <silent> ie <Plug>CamelCaseMotion_ie 
"}}}

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => fugitive"{{{
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""}}}
"{{{
" keymap
autocmd FileType gitcommit inoremap <buffer> <silent> <C-c> <Esc>:x!<CR>
autocmd FileType gitcommit nnoremap <buffer> <silent> <C-c> <Esc>:x!<CR>
autocmd BufWinEnter .git/index nmap <buffer> <silent> C <leader>x:Gcommit<CR>
" autocmd VimLeavePre,BufDelete COMMIT_EDITMSG execute 'sleep 1|bnew|bw'
" How to use it:
" 1. input the short cut and hit the key 'Enter'
" 2. input the short cut and hit the key 'Space'
cabbrev gcm   Gcommit -m
cabbrev gcma  Gcommit -a -m
cabbrev gcam  Gcommit --amend -m
cabbrev gg    Git!
cabbrev gs    Gstatus
cabbrev ga    Git! add
cabbrev gaa   Git! add --all
cabbrev gco   Git! checkout
cabbrev gbr   Git! branch
cabbrev gdl   Git! pull origin master
cabbrev gul   Git! push -u origin master
"}}}

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Gitgutter"{{{
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""}}}
"{{{
let g:gitgutter_max_signs = 1024 
autocmd FileType snippets let g:gitgutter_enabled = 0
" autocmd FileType snippets set foldenable! 
nmap ms <Plug>GitGutterStageHunk
nmap mr <Plug>GitGutterUndoHunk
nmap mv <Plug>GitGutterPreviewHunk
nmap <silent> mk :call feedkeys("\<Plug>GitGutterPrevHunkzv")<CR>
nmap <silent> mj :call feedkeys("\<Plug>GitGutterNextHunkzv")<CR>
"}}}

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => NERDCommenter"{{{
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""}}}
"{{{
let NERDSpaceDelims = 1 
nmap <Leader>cp vip<plug>NERDCommenterSexy 
"}}}

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Easy-Align"{{{
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""}}}
"{{{
vmap ea <Plug>(EasyAlign) 
" Start interactive EasyAlign in visual mode (e.g. vipga)
xmap ga <Plug>(EasyAlign)
" Start interactive EasyAlign for a motion/text object (e.g. gaip)
nmap ga <Plug>(EasyAlign) 
"}}}

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => toggle.vim"{{{
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""}}}
"{{{
imap <silent><C-T> <Plug>ToggleI 
nmap <silent><C-T> <Plug>ToggleN
vmap <silent><C-T> <Plug>ToggleV
let g:toggle_pairs = {
  \'and':'or',
  \'or':'and',
  \'if':'unless',
  \'unless':'if',
  \'elsif':'else',
  \'else':'elsif',
  \'it':'specify',
  \'specify':'it',
  \'describe':"context",
  \'context':"describe",
  \'true':'false',
  \'false':'true',
  \'yes':'no',
  \'no':'yes',
  \'on':'off',
  \'off':'on',
  \'public':'protected',
  \'protected':'private',
  \'private':'public',
  \'&&':'||',
  \'||':'&&'
\} 
"}}}

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => vim-shell-executor"{{{
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""}}}
"{{{
let g:executor_output_win_height = 12 
nmap <Leader><Leader>r vip:ExecuteSelection<CR>
nmap <Leader><Leader>rd :bd executor_output<CR>
vmap <Leader><Leader>r :ExecuteSelection<CR>
"}}}

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => vim-instant-markdown"{{{
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""}}}
"{{{
let g:instant_markdown_autostart = 0 
let g:instant_markdown_slow = 0
autocmd BufNewFile,BufReadPost *.md set filetype=markdown 
"}}}

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => vim-instant-markdown"{{{
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""}}}
"{{{
" set conceallevel=2 
let g:vim_markdown_conceal = 1 
"}}}

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => vimviki"{{{
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""}}}
"{{{
let g:vimwiki_list = [ {"path": "~/.vim/.vimwiki/", "path_html": "~/.vim/.vimwikihtml/", "syntax": "markdown", "auto_export": 0} ]
"}}}

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => phpcomplete.vim"{{{
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""}}}

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => phpcomplete-extended"{{{
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""}}}
"{{{
let g:phpcomplete_index_composer_command='/usr/local/bin/composer'
"}}}

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => cscope"{{{
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""}}}
"{{{
function! LoadCscopeDB() abort 
    if has("cscope")
        set csto=1
        set cst
        set nocsverb
        if filereadable("cscope.out")
            cs add cscope.out
        endif
        set csverb
        set cscopeverbose
    endif
endfunction

call LoadCscopeDB()
command! LoadCscopeDB call LoadCscopeDB() 

nmap <C-c>s :cs find s <C-R>=expand("<cword>")<CR><CR>
nmap <C-c>g :cs find g <C-R>=expand("<cword>")<CR><CR>
nmap <C-c>c :cs find c <C-R>=expand("<cword>")<CR><CR>
nmap <C-c>t :cs find t <C-R>=expand("<cword>")<CR><CR>
nmap <C-c>e :cs find e <C-R>=expand("<cword>")<CR><CR>
nmap <C-c>f :cs find f <C-R>=expand("<cfile>")<CR><CR>
nmap <C-c>i :cs find i ^<C-R>=expand("<cfile>")<CR>$<CR>
nmap <C-c>d :cs find d <C-R>=expand("<cword>")<CR><CR>
"}}}

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => phpcs"{{{
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""}}}
"{{{
let g:php_cs_fixer_level = "psr2"                 " which level ? 
let g:php_cs_fixer_config = "default"             " configuration
let g:php_cs_fixer_php_path = "php"               " Path to PHP
let g:php_cs_fixer_enable_default_mapping = 0     " Enable the mapping by default (<leader>pcd)
let g:php_cs_fixer_dry_run = 0                    " Call command with dry-run option
let g:php_cs_fixer_verbose = 0                    " Return the output of command if 1, else an inline information. 
"}}}

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Emmet"{{{
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""}}}
"{{{
let g:user_emmet_install_global = 0 
let g:user_emmet_leader_key='<C-Z>'
autocmd FileType html,css EmmetInstall
autocmd FileType html,css imap <C-Y> <C-Z><Leader>
autocmd FileType html,css vmap <C-Y> <C-Z><Leader>
autocmd FileType html,css imap <C-X> <C-Z>k
autocmd FileType html,css nmap <C-X> <C-Z>k 
"}}}

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => vim-superman"{{{
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""}}}
"{{{
autocmd VimEnter,FileType *.~ call s:ManViewHandle() 
function! s:ManViewHandle() abort
    set nonumber
    set showtabline=0
    set laststatus=0
endfunction 
"}}}

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => vim-watchforchanges"{{{
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""}}}
" autocmd VimEnter * WatchForChangesAllFile! 

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => vim-markdown"{{{
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""}}}
"{{{
nnoremap coe :ToggleMarkdowExpand<CR>
command! ToggleMarkdowExpand ToggleConceal
"}}}

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => vim-startify"{{{
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""}}}
"{{{
" set sessionoptions-=buffers
set sessionoptions-=options
let g:session_default_to_last = 1
let g:session_command_aliases = 1
let g:session_autosave_silent = 1
let g:session_verbose_messages = 0
let g:session_autosave = 'yes'
let g:session_autoload = 'no'
let g:startify_session_dir = '~/.vim/sessions'
let g:startify_session_persistence = 1
let g:startify_session_delete_buffers = 1

let g:startify_list_order = [
            \ ['   sessions:'],
            \ 'sessions',
            \ ['   MRU files'],
            \ 'files',
            \ ['   bookmarks:'],
            \ 'bookmarks',
            \ ['   commands:'],
            \ 'commands',
            \ ]

let g:startify_skiplist = [
    \ 'COMMIT_EDITMSG',
    \ '\.git',
    \ '/tmp/',
    \ '\.\(jpg\|png\|jpeg\|txt\)',
    \ escape(fnamemodify(resolve($VIMRUNTIME), ':p'), '\') .'doc',
    \ 'bundle/.*/doc',
    \ ]
"}}}

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => vim-expand-region"{{{
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""}}}
"{{{
map E <Plug>(expand_region_expand)
"}}}

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => golden-ratio"{{{
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""}}}
"{{{
nnoremap <C-w>g :GoldenRatioToggle<CR>
"}}}

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => vim-toggle-abbrevs"{{{
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""}}}
"{{{
cnoremap <C-g> :<C-u>ToggleAbbrevs<CR>:
"}}}

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => vim-quickrun"{{{
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""}}}
function! ToggleQKOutputType() abort
    if g:quickrun_config['_']['outputter'] == 'message'
        let g:quickrun_config['_']['outputter'] = 'buffer'
    else
        let g:quickrun_config['_']['outputter'] = 'message'
    endif
endfunction
command! ToggleQKOutputType call ToggleQKOutputType()
let g:quickrun_config = {
\   "_" : {
\       "outputter" : "message",
\   },
\}
let g:quickrun_config.node = {
          \ 'command': 'node',
          \ 'outputter': 'message'
          \ }
let g:quickrun_no_default_key_mappings = 1
nmap <F5> :QuickRun<CR>

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => vim-devicons"{{{
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""}}}
"{{{
" loading the plugin 
let g:webdevicons_enable = 1
" adding the flags to NERDTree 
let g:webdevicons_enable_nerdtree = 0
" adding the custom source to unite 
let g:webdevicons_enable_unite = 1
" adding the column to vimfiler 
let g:webdevicons_enable_vimfiler = 1
"}}}

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => fzf"{{{
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""}}}
" Default fzf layout
" - down / up / left / right
let g:fzf_layout = { 'up': '~60%' }
nmap <Leader>f :FZF --reverse --inline-info<CR>
" In Neovim, you can set up fzf window using a Vim command
" let g:fzf_layout = { 'window': 'enew' }

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => vim-autoformat"{{{
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""}}}
let g:formatdef_php_cs_fixer = '"/home/hanson/CodeHub/SHELL/phpcspatch"'
let g:formatters_php = ['php_cs_fixer']

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => vim-easytags"{{{
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""}}}
" BUG: if set this, will cause error.
let g:easytags_file = '/tmp/.vim/tags'



" vim: fdm=marker ts=4 sw=4 sts=4 expandtab
