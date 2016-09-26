""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => vim-session
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
noremap <leader>seo : <C-U>SessionOpen  
noremap <leader>ses : <C-U>SessionSave 
noremap <leader>sev : <C-U>SessionView<CR>

" Don't save hidden and unloaded buffers in sessions.
" set sessionoptions-=buffers
let g:session_default_to_last = 1
let g:session_command_aliases = 1
let g:session_autosave_silent = 1
let g:session_verbose_messages = 0
let g:session_autosave = 'yes'
if has("gui_running")
    let g:session_autoload = 'yes'
else
    let g:session_autoload = 'no'
endif 


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Unite
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" {{{
" The prefix key.
nnoremap    [unite]   <Nop>
nmap      ; [unite]

abbreviate uba UniteBookmarkAdd
" Unite -vertical -start-insert -winwidth=30 -direction=botright outline

nnoremap <silent> [unite]f :<C-u>Unite source<CR>
nnoremap <silent> [unite]o :<C-u>Unite -start-insert outline<CR>
nnoremap <silent> [unite]c :<C-u>UniteWithCurrentDir -buffer-name=files file<CR>
nnoremap <silent> [unite]b :<C-u>Unite -buffer-name=buffer -start-insert -winheight=10 buffer<CR>
nnoremap <silent> [unite]j :<C-u>Unite -buffer-name=jump jump<CR>

autocmd FileType unite call s:unite_nice_settings()
function! s:unite_nice_settings()
  " Overwrite settings.
  imap <buffer> jj        <Plug>(unite_insert_leave)
  imap  <buffer> <C-c>    <Esc>q
  nmap  <buffer> <C-c>    q

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
  nmap <buffer> <C-j>     <Plug>(unite_toggle_auto_preview)
  nmap <buffer> <C-r>     <Plug>(unite_narrowing_input_history)
  imap <buffer> <C-r>     <Plug>(unite_narrowing_input_history)
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
let logwatchadded = 'exe "Nice Git! log --follow --diff-filter=A --find-renames=40\\% " input("comando git:", expand("%:t"))'
let g:unite_source_menu_menus.git.command_candidates = [
    \['▷ tig                                             ⌘ ,gt', 'normal ,gt'],
    \['▷ git status      (Fugitive)                      ⌘ ,gs', 'Gstatus'],
    \['▷ git diff        (Fugitive)                      ⌘ ,gd', 'Gdiff'],
    \['▷ git commit      (Fugitive)                      ⌘ ,gc', 'Gcommit'],
    \['▷ git log         (Fugitive)                      ⌘ ,gl', 'exe "silent Glog | Unite -no-empty -no-tab quickfix"'],
    \['▷ git log oneline (Fugitive)                      ⌘ ,gl', 'exe "Nice Git log --pretty=oneline --since=\"2 days ago\""'],
    \['▷ git log one     (Fugitive)                      ⌘ ,gl', 'exe "Nice Git log -p -1"'],
    \['▷ git log watch   (Fugitive)                      ⌘ ,gl', logwatchadded],
    \['▷ git blame       (Fugitive)                      ⌘ ,gb', 'Gblame'],
    \['▷ git stage       (Fugitive)                      ⌘ ,gw', 'Gwrite'],
    \['▷ git checkout    (Fugitive)                      ⌘ ,go', 'Gread'],
    \['▷ git rm          (Fugitive)                      ⌘ ,gr', 'Gremove'],
    \['▷ git mv          (Fugitive)                      ⌘ ,gm', 'exe "Gmove " input("destino: ")'],
    \['▷ git push        (Fugitive, salida por buffer)   ⌘ ,gp', 'Git! push'],
    \['▷ git pull        (Fugitive, salida por buffer)   ⌘ ,gP', 'Git! pull'],
    \['▷ git prompt      (Fugitive, salida por buffer)   ⌘ ,gi', 'exe "Git! " input("comando git: ")'],
    \['▷ git cd          (Fugitive)', 'Gcd'],
    \]
nnoremap <silent>[unite]g :Unite -silent -start-insert menu:git<CR>

" For ag.
if executable('ag')
  let g:unite_source_grep_command = 'ag'
  let g:unite_source_grep_default_opts = '-i --no-heading --no-color -k -H'
 let g:unite_source_grep_recursive_opt = ''
endif 
"}}}


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => neocomplete
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"{{{
try  
    "Note: This option must set it in .vimrc(_vimrc).  NOT IN .gvimrc(_gvimrc)!
    " Disable AutoComplPop.
    let g:acp_enableAtStartup = 0
    " Use neocomplete.
    let g:neocomplete#enable_at_startup = 1
    " Use smartcase.
    let g:neocomplete#enable_smart_case = 1
    " Set minimum syntax keyword length.
    let g:neocomplete#sources#syntax#min_keyword_length = 3
    let g:neocomplete#lock_buffer_name_pattern = '\*ku\*'

    " Define dictionary.
    let g:neocomplete#sources#dictionary#dictionaries = {
        \ 'default' : '',
        \ 'vimshell' : $HOME.'/.vimshell_hist',
        \ 'scheme' : $HOME.'/.gosh_completions'
            \ }

    " Define keyword.
    if !exists('g:neocomplete#keyword_patterns')
        let g:neocomplete#keyword_patterns = {}
    endif
    let g:neocomplete#keyword_patterns['default'] = '\h\w*'

    " Plugin key-mappings.
    inoremap <expr><C-d>     neocomplete#undo_completion()
    " inoremap <expr><C-l>     neocomplete#complete_common_string()

    " Recommended key-mappings.
    " <CR>: close popup and save indent.
    inoremap <silent> <CR> <C-r>=<SID>my_cr_function()<CR>
    function! s:my_cr_function()
      " return pumvisible() ? "\<c-y>\<Plug>(neosnippet_expand_or_jump)" : "\<CR>"
      " return neocomplete#close_popup() . "\<CR>"
      " For no inserting <CR> key.
      return pumvisible() ? neocomplete#close_popup() : "\<CR>"
    endfunction
    " <TAB>: completion.
    inoremap <expr><TAB>  pumvisible() ? "\<C-n>" : "\<TAB>"
    " <C-h>, <BS>: close popup and delete backword char.
    inoremap <expr><BS> neocomplete#smart_close_popup()."\<C-h>"
    inoremap <expr><C-c>  neocomplete#cancel_popup()
    " Close popup by <Space>.
    "inoremap <expr><Space> pumvisible() ? neocomplete#close_popup() : "\<Space>"

    set completeopt=longest,menu 

    " Enable omni completion.
    " autocmd FileType css setlocal omnifunc=csscomplete#CompleteCSS
    " autocmd FileType html,markdown setlocal omnifunc=htmlcomplete#CompleteTags
    " autocmd FileType javascript setlocal omnifunc=javascriptcomplete#CompleteJS
    " autocmd FileType python setlocal omnifunc=pythoncomplete#Complete
    " autocmd FileType xml setlocal omnifunc=xmlcomplete#CompleteTags
    " autocmd FileType php set omnifunc=phpcomplete#CompletePHP

    " Enable heavy omni completion.
    if !exists('g:neocomplete#sources#omni#input_patterns')
      let g:neocomplete#sources#omni#input_patterns = {}
    endif
    let g:neocomplete#sources#omni#input_patterns.php = '[^. \t)]->\h\w*\|\h\w*::'

catch 
    " donothing
endtry 

" filetype plugin indent on
" let g:SuperTabDefaultCompletionType = '<C-X><C-O>'
" let g:SuperTabRetainCompletionType=2

" --- neosnippet
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
" let g:neosnippet#snippets_directory='~/.vim/snippets'
let g:neosnippet#snippets_directory='~/.vim/bundle/vim-php-snippets/snippets'
"}}}


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => airline
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set laststatus=2 
set t_Co=256
" let g:airline_powerline_fonts = 1
let g:airline#extensions#tabline#enabled = 1
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
let g:airline_symbols = {}
let g:airline_symbols.branch    = '⭠'
let g:airline_symbols.readonly = '⭤'
let g:airline_symbols.linenr = '⭡'
let g:airline_left_sep=''
let g:airline_right_sep=''
" if has("gui_running")
    " let g:airline_theme="molokai"
" else
    " let g:airline_theme="bubblegum"
" endif
let g:airline_theme="bubblegum" 


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => NERDTree
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" HideShowBookmarks can be done by upcase 'B' 
" let NERDTreeShowBookmarks=1 
let NERDTreeQuitOnOpen=1
let NERDTreeAutoDeleteBuffer=1
let NERDTreeChDirMode=2
let NERDTreeQuitOnOpen=1
" let NERDTreeIgnore=['\.*', '\~$']
map <silent> <leader>nn :silent NERDTreeToggle<cr>
map <leader>nb :NERDTreeFromBookmark 
map <silent> <leader>nf :NERDTreeFind<cr>
map <silent> <leader>nc :silent NERDTreeCWD<cr>
map <silent> <leader>ng :silent NERDTreeFocus<cr> 


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Tagbar
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:tagbar_width=30 
let g:tagbar_autofocus = 1
nnoremap <silent> <Leader>t :<C-u>TagbarToggle<CR> 


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => CtrlSF
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
nmap     <C-F>f <Plug>CtrlSFPrompt 
vmap     <C-F>f <Plug>CtrlSFVwordPath
vmap     <C-F>F <Plug>CtrlSFVwordExec
nmap     <C-F>n <Plug>CtrlSFCwordPath
nmap     <C-F>p <Plug>CtrlSFPwordPath
nnoremap <silent> <C-F>o :CtrlSFOpen<CR>
nnoremap <silent> <C-F>t :CtrlSFToggle<CR> 


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Gundo
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
map <silent> <Leader>g :GundoToggle<CR>


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => EasyMotion
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
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
map <Leader><Leader>w <Plug>(easymotion-iskeyword-w)
map <Leader><Leader>b <Plug>(easymotion-iskeyword-b)
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

noremap <silent><expr> /  incsearch#go(<SID>incsearch_config())
noremap <silent><expr> ?  incsearch#go(<SID>incsearch_config({'command': '?'}))
noremap <silent><expr> g/ incsearch#go(<SID>incsearch_config({'is_stay': 1})) 
"}}}


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => LeaderF
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" autocmd FileType LeaderF lmap <C-M> <C-C> 
nnoremap  <leader>m  :<C-u>LeaderfMru<CR>
nnoremap  <leader>f  :<C-u>Leaderf .<CR>
nnoremap  <leader>b  :<C-u>LeaderfBuffer<CR>

let g:Lf_WildIgnore = {
        \ 'dir': ['.svn','.git', 'node_modules'],
        \ 'file': ['*.sw?','~$*','*.bak','*.exe','*.o','*.so','*.py[co]']
        \}


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => snipMate (beside <TAB> support <CTRL-j>)
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" ino <c-j> <c-r>=snipMate#TriggerSnippet()<cr>
" snor <c-j> <esc>i<right><c-r>=snipMate#TriggerSnippet()<cr>


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => YankRing
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
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


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => vim-multiple-cursors
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Key 'i' cannot be replayed at 2 cursor locations: press 'v' first to normal mode 
let g:multi_cursor_prev_key='<C-d>'
let g:multi_cursor_next_key='<C-s>'
let g:multi_cursor_skip_key='<C-x>'
let g:multi_cursor_quit_key='<Esc>'

" Called once right before you start selecting multiple cursors
function! Multiple_cursors_before()
  if exists(':NeoCompleteLock')==2
    exe 'NeoCompleteLock'
  endif
endfunction

" Called once only when the multiple selection is canceled (default <Esc>)
function! Multiple_cursors_after()
  if exists(':NeoCompleteUnlock')==2
    exe 'NeoCompleteUnlock'
  endif
endfunction 


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => surround.vim config
" Annotate strings with gettext http://amix.dk/blog/post/19678
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
vmap Si S(i_<esc>f) 
au FileType mako vmap Si S"i${ _(<esc>2f"a) }<esc>


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Syntastic (syntax checker)
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:syntastic_python_checkers=['pyflakes']
" let g:syntastic_phpcs_conf = "--standard=/home/hanson/.phpcs-ruleset.xml" " the variable had been invalid.
let g:syntastic_php_checkers=['php', 'phpmd']
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*

nnoremap <silent> <Leader>lc :lclose<CR>
cabbrev <silent> <buffer> bd lclose\|bdelete

let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0 


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => vim-bookmark
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" highlight BookmarkSign ctermbg=235 ctermfg=Gray 
" highlight BookmarkSign guibg=#073642 guifg=#B58900
" highlight BookmarkAnnotationSign ctermbg=235 ctermfg=Gray
" highlight BookmarkAnnotationSign guibg=#073642 guifg=#B58900
" highlight clear SignColumn
" let g:bookmark_highlight_lines = 1
" let g:bookmark_sign = '♥'
" let g:bookmark_annotation_sign = '⚑'
let g:bookmark_save_per_working_dir = 1
let g:bookmark_auto_save = 1 


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Vimroom
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:goyo_width = 120 
let g:goyo_margin_top = 2
let g:goyo_margin_bottom = 2
nnoremap <silent> <leader>z :call GoyoFunc()<cr>

let g:goyo_toggle_trigger = 0
function GoyoFunc()
    if &filetype == "help"
        let g:goyo_width = 100
    endif
    if g:goyo_toggle_trigger == 0
        let g:goyo_showtabline = &showtabline
    endif
    execute 'Goyo'
    if g:goyo_toggle_trigger == 1 
        call SetColorScheme()
        let g:goyo_toggle_trigger = 0
        let g:goyo_width = 100
        exec 'set showtabline=' . g:goyo_showtabline
    else
        let g:goyo_toggle_trigger = 1
    endif
endfunction 


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => gvim-fullscreen
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
if has("gui_running") 
    nmap <F11> <Plug>(fullscreen-toggle)
endif 


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => vimshell
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"{{{
" Use current directory as vimshell prompt. 
abbreviate vsh VimShell
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
" => Trans
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:trans_default_api = 'bing'


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => IndentLine
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
map <Leader>ig :<C-U>IndentLinesToggle<CR> 
let g:indentLine_enabled = 0
let g:indentLine_color_term = 239
let g:indentLine_color_gui = '#586e75' 


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => tasklist.vim
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:tlTokenList = ["FIXME", "TODO", "HACK", "NOTE", "WARN", "MODIFY", "\" => "] 
nnoremap  <Leader>td :<C-U>TaskList<CR> 


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => CamelCaseMotion
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
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


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => laravel4-snippets
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" autocmd FileType php set ft=php.laravel


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => script runner
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" " Overwrite the runner default map 
" nnoremap <F6> :call OverwriteRun(&ft)<CR>
" function! OverwriteRun(cmd) abort
"     " autosave before running script
"     silent execute "w!"
"     " make php well
"     let s:real_cmd = substitute(a:cmd, '.laravel', '', '') 
"     call Run(s:real_cmd)
" endfunction 

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => fugitive
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" How to use it:
" 1. input the short cut and hit the key 'Enter'
" 2. input the short cut and hit the key 'Space'
ab gm   Gcommit -m
ab gma  Gcommit -a -m
ab gr   Git remote -v
ab gurl Git config --get remote.origin.url
ab g    Git
ab gs   Gstatus
ab ga   Git add
ab gc   Git checkout
ab gb   Git branch
ab gd   Git pull origin master
ab gu   Git push -u origin master
ab gr   Git reset HEAD
ab gw   Nice Git log --follow --diff-filter=A --find-renames=40\%
ab gl   Nice Git log --pretty=oneline --since="2 days ago"
ab go   Nice Git log -p -1


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Gitgutter
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:gitgutter_max_signs = 1024 
autocmd FileType snippets let g:gitgutter_enabled = 0
" autocmd FileType snippets set foldenable! 


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => NERDCommenter
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let NERDSpaceDelims = 1 
nmap <Leader>cp vip<plug>NERDCommenterSexy 


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Easy-Align
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
vmap <Enter> <Plug>(EasyAlign) 
" Start interactive EasyAlign in visual mode (e.g. vipga)
xmap ga <Plug>(EasyAlign)
" Start interactive EasyAlign for a motion/text object (e.g. gaip)
nmap ga <Plug>(EasyAlign) 


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => sudo.vim
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
cmap <C-S> <C-A><Right><Right>sudo: 
command W silent call SudoFileHandle('write')
command R silent call SudoFileHandle('read')
function! SudoFileHandle(tag) abort
    let s:command = a:tag == 'read' ? 'SudoRead' : 'SudoWrite'
    let s:filename = expand('%:p')
    if a:tag == 'read'
        exe 'Bclose'
        exe 'e sudo:' . s:filename
    elseif a:tag == 'write'
        exe s:command . ' ' . s:filename
        if matchstr(s:filename, '^\(sudo\)\ze:') == 'sudo'
            exe 'echo "nothing"'
        else
            call SudoFileHandle('read')
        endif
    endif
endfunction 


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => toggle.vim
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
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


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => vim-shell-executor
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:executor_output_win_height = 12 
nmap <Leader><Leader>r vip:ExecuteSelection<CR>
nmap <Leader><Leader>rd :bd executor_output<CR>
vmap <Leader><Leader>r :ExecuteSelection<CR> 


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => vim-instant-markdown
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:instant_markdown_autostart = 0 
let g:instant_markdown_slow = 0
autocmd BufNewFile,BufReadPost *.md set filetype=markdown 


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => vim-instant-markdown
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" set conceallevel=2 
let g:vim_markdown_conceal = 1 


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => vimviki
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:vimwiki_list = [ {"path": "~/.vim/.vimwiki/", "path_html": "~/.vim/.vimwikihtml/", "syntax": "markdown", "auto_export": 0} ]


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => phpcomplete.vim
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:phpcomplete_mappings = { 
   \ 'jump_to_def': '<C-]>',
   \ 'jump_to_def_split': '<C-W><C-]>',
   \ 'jump_to_def_vsplit': '<C-W><C-\>',
   \} 


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => phpcomplete-extended
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:phpcomplete_index_composer_command='/usr/local/bin/composer'


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => vim-script-runner
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:script_runner_key = '<C-F5>'


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => cscope
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
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

nmap <C-l>s :cs find s <C-R>=expand("<cword>")<CR><CR>
nmap <C-l>g :cs find g <C-R>=expand("<cword>")<CR><CR>
nmap <C-l>c :cs find c <C-R>=expand("<cword>")<CR><CR>
nmap <C-l>t :cs find t <C-R>=expand("<cword>")<CR><CR>
nmap <C-l>e :cs find e <C-R>=expand("<cword>")<CR><CR>
nmap <C-l>f :cs find f <C-R>=expand("<cfile>")<CR><CR>
nmap <C-l>i :cs find i ^<C-R>=expand("<cfile>")<CR>$<CR>
nmap <C-l>d :cs find d <C-R>=expand("<cword>")<CR><CR> 


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => vim-php-refactoring
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:php_refactor_command='/usr/local/bin/refactor'


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => phpcs
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:php_cs_fixer_level = "psr2"                 " which level ? 
let g:php_cs_fixer_config = "default"             " configuration
let g:php_cs_fixer_php_path = "php"               " Path to PHP
let g:php_cs_fixer_enable_default_mapping = 0     " Enable the mapping by default (<leader>pcd)
let g:php_cs_fixer_dry_run = 0                    " Call command with dry-run option
let g:php_cs_fixer_verbose = 0                    " Return the output of command if 1, else an inline information. 


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Emmet
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:user_emmet_install_global = 0 
autocmd FileType html,css EmmetInstall
let g:user_emmet_leader_key='<C-Z>'
imap <C-Y> <C-Z><Leader>
vmap <C-Y> <C-Z><Leader>
imap <C-K> <C-Z>k
nmap <C-K> <C-Z>k 

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => FastFold, neocomplete nedd it.
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:tex_fold_enabled=1 
let g:vimsyn_folding='af'
let g:xml_syntax_folding = 1
let g:php_folding = 1
let g:perl_fold = 1 


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => vim-superman
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
autocmd VimEnter,FileType *.~ call s:ManViewHandle() 
function! s:ManViewHandle() abort
    set nonumber
    set showtabline=0
    set laststatus=0
endfunction 
