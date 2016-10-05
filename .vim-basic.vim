""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Map Helper
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"{{{
" Map Partial
" C:Ctrl, M:Alt, S:shift,DOWN:down,UP:up,LEFT:left,RIGHT:right

" Notes
" 1. Ctrl-b and Ctrl-B are synonymous, so Ctrl+Shit+.. can't work
" 2. ctrl+f: show command history normal
" 3. bottom blank white line fixed
"    # filepath: ~/.gtkrc-2.0
"    # desc: let gvim white board invisible. 
"    style "vimfix" {
"      bg[NORMAL] = "#272822" # this matches my gvim theme 'Normal' bg color.
"    }
"    widget "vim-main-window.*GtkForm" style "vimfix"
" 4. 
"}}}
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Helper functions
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"{{{
function! GetBufLists(info) abort 
    redir => bufoutput
    if a:info == 1
        silent buffers
    else
        silent buffers!
    endif
    redir END
    return bufoutput
endfunction

function! GetBufListedNr() abort
    let s:bufoutput = GetBufLists(1)
    let s:count = 0
    for buf in split(s:bufoutput, '\n')
        let s:count += 1
        " let s:bits = split(buf, '"')
        " if s:bits[0] !~ "u"
            " let s:count += 1
        " endif
    endfor
    return s:count
endfunction

function! GetBufNr(nr) abort
    let s:bufoutput = GetBufLists(1)
    let s:count = 1
    for buf in split(s:bufoutput, '\n')
        let s:bits = split(buf, ' ')
        if s:count == a:nr
            return str2nr(s:bits[0])
        endif
        let s:count +=1
    endfor
    return 0
endfunction

function! GetBufListsNu() abort
    let s:bufoutput = GetBufLists(1)
    let s:arrlist = []
    for buf in split(s:bufoutput, '\n')
        let s:bits = split(buf, ' ')
        call add(s:arrlist, str2nr(s:bits[0]))
    endfor
    return s:arrlist
endfunction

func! DeleteTillSlash()
    let g:cmd = getcmdline()

    if has("win16") || has("win32")
        let g:cmd_edited = substitute(g:cmd, "\\(.*\[\\\\]\\).*", "\\1", "")
    else
        let g:cmd_edited = substitute(g:cmd, "\\(.*\[/\]\\).*", "\\1", "")
    endif

    if g:cmd == g:cmd_edited
        if has("win16") || has("win32")
            let g:cmd_edited = substitute(g:cmd, "\\(.*\[\\\\\]\\).*\[\\\\\]", "\\1", "")
        else
            let g:cmd_edited = substitute(g:cmd, "\\(.*\[/\]\\).*/", "\\1", "")
        endif
    endif   

    return g:cmd_edited
endfunc

func! CurrentFileDir(cmd)
    return a:cmd . " " . expand("%:p:h") . "/"
endfunc 
"}}}

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Settings
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"{{{
set termencoding=utf-8 
set encoding=utf8
set fileencodings=utf8,ucs-bom,gbk,cp936,gb2312,gb18030 
set previewheight=20
au BufWinEnter * set splitbelow
au BufWinEnter * set splitright


" disable Background Color Erase (BCE) so that color schemes
" render properly when inside 256-color tmux and GNU screen.
" see also http://snk.tuxfamily.org/log/vim-256color-bce.html
if &term =~ '256color'
  set t_ut=
  au VimEnter * if $is_tmux != '' | call ToggleLabelBar() | endif
endif
"}}}

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Folding Save And View
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"{{{
set foldlevelstart=99
au BufWinEnter * set foldmethod=marker 
" set viewdir=$HOME/.vim/.vim_view/
" au BufWritePost,BufLeave,WinLeave ?* mkview " for tabs
" au BufWinEnter ?* silent loadview 
"}}}

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => General
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"{{{
" Sets how many lines of history VIM has to remember 
set history=700

" Enable filetype plugins
filetype plugin on
filetype indent on

" Set to auto read when a file is changed from the outside
set autoread

" With a map leader it's possible to do extra key combinations
" like <leader>w saves the current file
let mapleader = ","
let g:mapleader = ","

" Fast saving
nmap <silent> <leader>w :w!<cr>
nmap <silent> <leader>wa :wa!<cr>

" :W sudo saves the file 
" (useful for handling the permission-denied error)
" command W silent w !sudo tee % > /dev/null 
"}}}

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => VIM user interface
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"{{{
" Set 7 lines to the cursor - when moving vertically using j/k 
set so=7

" Turn on the WiLd menu
set wildmenu

" Ignore compiled files
set wildignore=*.o,*~,*.pyc
if has("win16") || has("win32")
    set wildignore+=*/.git/*,*/.hg/*,*/.svn/*,*/.DS_Store
else
    set wildignore+=.git\*,.hg\*,.svn\*
endif

"Always show current position
set ruler

" Height of the command bar
set cmdheight=1

" A buffer becomes hidden when it is abandoned
set hid

" Configure backspace so it acts as it should act
set backspace=eol,start,indent
set whichwrap+=<,>,h,l

" In many terminal emulators the mouse works just fine, thus enable it.
if has('mouse')
  set mouse=a
endif

" Ignore case when searching
set ignorecase

" When searching try to be smart about cases 
set smartcase

" Highlight search results
set hlsearch

" Makes search act like search in modern browsers
set incsearch 

" Don't redraw while executing macros (good performance config)
set lazyredraw 

" For regular expressions turn magic on
set magic

" Show matching brackets when text indicator is over them
set showmatch 
" How many tenths of a second to blink when matching brackets
set mat=2

" No annoying sound on errors
set noerrorbells
set novisualbell
set t_vb=
set tm=500

" Add a bit extra margin to the left
set foldcolumn=1 
"}}}

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Colors and Fonts
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"{{{
" Enable syntax highlighting 
" syntax enable 

" try
"     colorscheme desert
" catch
" endtry

" set background=dark

" " the most left color set
" hi FoldColumn      guifg=#465457 guibg=#000000
" hi Folded          guifg=#465457 guibg=#000000
" hi LineNr          ctermfg=250 ctermbg=236
" hi CursorLineNr guifg=#7C8F8B ctermfg=245
" autocmd BufEnter * hi CursorLineNr guifg=#7C8F8B ctermfg=245

" NOTICE : 'set background=dark' must before 'colorscheme sublime'
"{{{
function! SetColorScheme()
    syntax enable
    set background=dark
    colorscheme monokai
    " let g:solarized_degrade=1
    " let g:solarized_termcolors=256
    " colorscheme solarized
endfunction
" Goyo Plugin Must call for well
call SetColorScheme()
"}}}

" Set extra options when running in GUI mode
"{{{
if has("gui_running")
    set guioptions-=T
    set guioptions-=e
    set t_Co=256
    set guitablabel=%M\ %t
    set guifont=Source\ Code\ Pro\ Medium\ 11
    set guioptions-=m        " hide menus
    set guioptions-=T        " hide tools
    set guioptions-=L        " hide scroll left
    set guioptions-=r        " hide scroll right
    set guioptions-=b        " hide scroll bottom
    set showtabline=0        " hide tabline
    command! Grb winpos 119 117  " window go to right below
    command! Gtl winpos 49  24   " window go to top left
    command! Gmd winpos 86  60   " window go to middle
    " autocmd BufEnter * winpos 119 117
    " set columns=173 lines=46 
    set columns=145 lines=35 
endif
"}}}
" Set utf8 as standard encoding and en_US as the standard language
set encoding=utf8

" Use Unix as the standard file type
set ffs=unix,dos,mac 
"}}}

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Files, backups and undo
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Turn backup off, since most stuff is in SVN, git et.c anyway... 
"{{{
set nobackup
set nowb
set noswapfile 
"}}}

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Text, tab and indent related
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"{{{
" Use spaces instead of tabs 
set expandtab

" Be smart when using tabs ;)
set smarttab

" 1 tab == 4 spaces
set shiftwidth=4
set tabstop=4

" Linebreak on 500 characters
set lbr
set tw=500

set ai "Auto indent
set si "Smart indent
set wrap "Wrap lines 
"}}}

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Visual mode related
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"{{{
" Visual mode pressing * or # searches for the current selection 
" Super useful! From an idea by Michael Naumann
vnoremap <silent> * :call VisualSelection('f', '')<CR>
vnoremap <silent> # :call VisualSelection('b', '')<CR>
"}}}

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Moving around, tabs, windows and buffers
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"{{{
" Treat long lines as break lines (useful when moving around in them) 
map j gj
map k gk

" Map <Space> to / (search) and Ctrl-<Space> to ? (backwards search)
map <space> /

" Disable highlight when <leader><cr> is pressed
map <silent> <leader><cr> :noh<cr>

" Smart way to move between windows
cabbrev vba vert ba
" window rezoom
" map <C-W><C-Left>   <C-W><C-=>
" map <C-W><C-Right>  <C-W><C-\|>
" map <C-W><C-Up>     <C-W><C-_>
" map <C-W><C-Down>   <C-W><C-=>
" Zoom / Restore window.
"{{{
function! s:ZoomToggle() abort
    if exists('t:zoomed') && t:zoomed
        execute t:zoom_winrestcmd
        let t:zoomed = 0
    else
        let t:zoom_winrestcmd = winrestcmd()
        resize
        vertical resize
        let t:zoomed = 1
    endif
endfunction
"}}}
command! ZoomToggle call s:ZoomToggle()
nnoremap <silent> <C-W>z :ZoomToggle<CR>

" map like terminal
inoremap <C-E> <End>
inoremap <C-A> <Home>

" Make sure all the deleted buffers will unload when session start next. 
" autocmd VimLeavePre * 1,1000argd

" Close the current buffer
map <leader>bd :Bclose<cr>

" Close all the buffers
map <leader>ba :%bd!<cr>

map <Leader>br :call BufferRightAllDelete()<cr>
map <Leader>bl :call BufferLeftAllDelete()<cr>
map <Leader>bo :call BufferOtherAllDelete()<cr>
" bug with function bufexists() , so use 'try ... catch ... end'
"{{{
function! BufferOtherAllDelete() abort
    silent call BufferLeftAllDelete()
    silent call BufferRightAllDelete()
    echo "** Delete All Other Buffer"
endfunction

function! BufferLeftAllDelete() abort
    let s:arrlist = GetBufListsNu()
    let s:bufnums = bufnr('%')
    try
        silent exe s:arrlist[0] . ',' . s:bufnums . '-bd!'
    catch
    endtry
    echo "** Delete All Buffer At Current Left."
endfunction

function! BufferRightAllDelete() abort
    let s:arrlist = GetBufListsNu()
    let s:bufnums = bufnr('%')
    let i = index(s:arrlist, s:bufnums)
    try
        silent exe s:arrlist[i+1] . ',$bd!'
    catch
    endtry
    echo "** Delete All Buffer At Current Right."
endfunction
"}}}
" Useful mappings for managing tabs
map <leader>tn :tabnew<cr>
map <leader>to :tabonly<cr>
map <leader>tc :tabclose<cr>:call BufferRightAllDelete()<cr>
map <leader>tm :tabmove 
map <leader>t<leader> :tabnext 

" Let 'tl' toggle between this and the last accessed tab
let g:lasttab = 1
nmap <Leader>tl :exe "tabn ".g:lasttab<CR>
au TabLeave * let g:lasttab = tabpagenr()


" Open a new tab with the current buffer's path
" Super useful when editing files in the same directory
map <leader>te :tabedit <c-r>=expand("%:p:h")<cr>/

" Switch CWD to the directory of the open buffer
map <leader>cd :cd %:p:h<cr>:pwd<cr>

" Specify the behavior when switching between buffers 
try
  set switchbuf=useopen,usetab,newtab
  set stal=2
catch
endtry

" Return to last edit position when opening files (You want this!)
autocmd BufReadPost *
     \ if line("'\"") > 0 && line("'\"") <= line("$") |
     \   exe "normal! g`\"" |
     \ endif
" Remember info about open buffers on close
set viminfo^=% 
"}}}

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Status line
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"{{{
" Always show the status line 
set laststatus=2

" Format the status line
set statusline=\ %{HasPaste()}%F%m%r%h\ %w\ \ CWD:\ %r%{getcwd()}%h\ \ \ Line:\ %l 
"}}}

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Editing mappings
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"{{{
" Remap VIM 0 to first non-blank character 
map 0 ^

" Move a line of text using ALT+[jk] or Comamnd+[jk] on mac
nmap <M-j> mz:m+<cr>`z
nmap <M-k> mz:m-2<cr>`z
vmap <M-j> :m'>+<cr>`<my`>mzgv`yo`z
vmap <M-k> :m'<-2<cr>`>my`<mzgv`yo`z

nmap <C-S-DOWN> mz:m+<cr>`z
nmap <C-S-UP> mz:m-2<cr>`z
vmap <C-S-DOWN> :m'>+<cr>`<my`>mzgv`yo`z
vmap <C-S-UP> :m'<-2<cr>`>my`<mzgv`yo`z

if has("mac") || has("macunix")
  nmap <D-j> <M-j>
  nmap <D-k> <M-k>
  vmap <D-j> <M-j>
  vmap <D-k> <M-k>
endif

" Delete trailing white space on save, useful for Python and CoffeeScript ;)
func! DeleteTrailingWS()
  exe "normal mz"
  %s/\s\+$//ge
  exe "normal `z"
endfunc
autocmd BufWrite *.py :call DeleteTrailingWS()
autocmd BufWrite *.coffee :call DeleteTrailingWS() 
"}}}

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Ack searching and cope displaying
"    requires ack.vim - it's much better than vimgrep/grep
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"{{{
" When you press gv you Ack after the selected text 
vnoremap <silent> gv :call VisualSelection('gv', '')<CR>

" Open Ack and put the cursor in the right position
" map <leader>g :CtrlSF 

" When you press <leader>r you can search and replace the selected text
vnoremap <silent> <leader>r :call VisualSelection('replace', '')<CR>

" Do :help cope if you are unsure what cope is. It's super useful!
"
" When you search with Ack, display your results in cope by doing:
"   <leader>cc
"
" To go to the next search result do:
"   <leader>n
"
" To go to the previous search results do:
"   <leader>p
"
map <leader>cc :botright cope<cr>
map <leader>co ggVGy:tabnew<cr>:set syntax=qf<cr>pgg
map <leader>n :cn<cr>
map <leader>p :cp<cr>
"}}}

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Spell checking
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"{{{
" Pressing ,ss will toggle and untoggle spell checking 
map <leader>ss :setlocal spell!<cr>

" Shortcuts using <leader>
map <leader>sn ]s
map <leader>sp [s
map <leader>sa zg
map <leader>s? z= 
"}}}

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Misc
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"{{{
" Remove the Windows ^M - when the encodings gets messed up 
noremap dwm mmHmt:%s/<C-V><cr>//ge<cr>'tzt'm

" Smart quit in windows and buffers
map <silent> <leader>q :<C-U>call SmartQuit()<cr>
function! SmartQuit() abort
    let s:winnums = winnr('$')
    let s:bufnums = GetBufListedNr()
    let s:syntaxerr =  exists('*SyntasticStatuslineFlag') ? SyntasticStatuslineFlag() : ''

    if &filetype == 'help'
        exe 'q'
    elseif s:syntaxerr != ''
        exe 'Bclose'
    elseif buflisted(bufnr('%')) == 0 && s:winnums > 1
        exe 'q'
    elseif s:winnums == 1 || s:winnums == 2 && s:bufnums < 2
        exe 'Bclose'
    else
        exe 'q'
    endif
endfunction

" Toggle paste mode on and off
map <leader>pp :setlocal paste!<cr>
"}}}

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Helper functions
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"{{{
function! CmdLine(str) 
    exe "menu Foo.Bar :" . a:str
    emenu Foo.Bar
    unmenu Foo
endfunction 

let g:virsual_selection_act = 0
function! VisualSelection(direction, extra_filter) range
    let g:virsual_selection_act = 1
    let l:saved_reg = @"
    execute "normal! vgvy"

    let l:pattern = escape(@", '\\/.*$^~[]')
    let l:pattern = substitute(l:pattern, "\n$", "", "")

    if a:direction == 'b'
        execute "normal ?" . l:pattern . "^M"
    elseif a:direction == 'gv'
        call CmdLine("CtrlSF \"" . l:pattern . "\" " )
    elseif a:direction == 'replace'
        call CmdLine("%s" . '/'. l:pattern . '/')
    elseif a:direction == 'f'
        execute "normal /" . l:pattern . "^M"
    endif

    let g:virsual_selection_act = 0
    let @/ = l:pattern
    let @" = l:saved_reg
endfunction

" Returns true if paste mode is enabled
function! HasPaste()
    if &paste
        return 'PASTE MODE  '
    en
    return ''
endfunction

" Don't close window, when deleting a buffer
command! Bclose call <SID>BufcloseCloseIt()
function! <SID>BufcloseCloseIt()
   let l:currentBufNum = bufnr("%")
   let l:alternateBufNum = bufnr("#")

   if buflisted(l:alternateBufNum)
     buffer #
   else
     bnext
   endif

   if bufnr("%") == l:currentBufNum
     new
   endif

   if buflisted(l:currentBufNum)
     execute("bdelete! ".l:currentBufNum)
   endif
endfunction 
"}}}

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Fast editing and reloading of vimrc configs
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"{{{
map <leader>e :e! ~/.vimrc<cr>
autocmd! bufwritepost vimrc source ~/.vimrc 
"}}}

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Turn persistent undo on 
"    means that you can undo even when you close a buffer/VIM
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"{{{
try 
    set undodir=~/.vim/temp_dirs/undodir
    set undofile
catch
endtry 

set viminfo='100,n$HOME/.vim/files/info/viminfo
"}}}

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Command mode related
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"{{{
" Smart mappings on the command line 
cno $h e ~/
cno $d e ~/Desktop/
cno $j e ./
cno $c e <C-\>eCurrentFileDir("e")<cr>

" $q is super useful when browsing on the command line
" it deletes everything until the last slash 
cno $q <C-\>eDeleteTillSlash()<cr>

" Bash like keys for the command line
cnoremap <C-A>      <Home>
cnoremap <C-E>      <End>
cnoremap <C-K>      <C-U>

cnoremap <C-N> <Down>

" Map ½ to something useful
map ½ $
cmap ½ $
imap ½ $ 
"}}}

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Parenthesis/bracket
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"{{{
" select text, then Quickly ouput '$1' 
vnoremap $1 <esc>`>a)<esc>`<i(<esc>
vnoremap $2 <esc>`>a]<esc>`<i[<esc>
vnoremap $3 <esc>`>a}<esc>`<i{<esc>
vnoremap $$ <esc>`>a"<esc>`<i"<esc>
vnoremap $q <esc>`>a'<esc>`<i'<esc>
vnoremap $e <esc>`>a"<esc>`<i"<esc>

" Map auto complete of (, ", ', [
" inoremap $1 ()<esc>i
" inoremap $2 []<esc>i
" inoremap $3 {}<esc>i
" inoremap $4 {<esc>o}<esc>O
" inoremap $q ''<esc>i
" inoremap $e ""<esc>i
" inoremap $t <><esc>i 
"}}}

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => General abbreviations
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"{{{
iab xdate <c-r>=strftime("%d/%m/%y %H:%M:%S")<cr>
"}}}

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Custom Settings
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"{{{
set nonumber 
set nocursorline
set nowrap

" reindent: auto indent
map <c-m-i> =G
imap <c-m-i> <Esc>=G
map <c-k><c-i> gg=G``

" cursorline toggle
cabbrev cls set cursorline!<CR>
command Reload :e!

" fix the redraw problems with slient
" from: http://vim.wikia.com/wiki/Avoiding_the_%22Hit_ENTER_to_continue%22_prompts
command! -nargs=+ Nice   execute 'silent <args>' | redraw!
command! -nargs=+ Silent execute 'silent <args>' | redraw!
if has("gui_running")
    command! -nargs=+ Nice   execute '<args>'
    command! -nargs=+ Silent execute 'silent <args>'
endif

" normal mode keypress 'K' will show help of function.
autocmd BufNewFile,Bufread *.vim set keywordprg="help"

" let QuicklyFix buffer out of list 
autocmd FileType qf,vimfiler,git setlocal nobuflisted
autocmd BufWinEnter * if &previewwindow | setlocal nobuflisted | endif

" System clipboard sharing
if has('clipboard') 
    if has('unnamedplus') 
        set clipboard=unnamedplus 
    else 
        set clipboard=unnamed 
    endif 
endif


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => key map
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"{{{
" let the help buffer map 'q' to quit
autocmd FileType help,git nmap <buffer> q :<C-U>q<CR>

nnoremap <silent> <F4> :<C-u>q<cr>

nnoremap <C-q> :<C-u>call SmartQwindow()<CR>
"{{{
function! SmartQwindow() abort
   if &filetype == 'unite'
       exe "UniteClose"
   else
       exe "q"
   endif
   exe "normal! \<C-w>\<C-o>"
endfunction
"}}}

" show the command line 
nnoremap cm :
nnoremap cme :e 
nnoremap cms :e ~/.storge<cr>
nnoremap cmt :e /tmp/test.php<cr>
nnoremap cmb :e /tmp/buffer<cr>

" split buffer
nnoremap <silent> sp :<C-u>sp<cr>
nnoremap <silent> vsp :<C-u>vsp<cr>

inoremap <C-V> <Esc>pA

" gvim: map break line
nmap <S-Enter> o
imap <S-Enter> <Esc>o
nmap <C-Enter> o
imap <C-Enter> <Esc>o

" file map
nmap new :enew<cr>
nmap <Leader>s :sav 

inoremap <C-BackSpace> <Esc>viwc

" Map to nice work in PHP
" php-manual files are in bundle/vim-help-manual
" <C-Space> cannot work in vim
autocmd BufNewFile,Bufread *.ros,*.inc,*.php set keywordprg="help"
autocmd FileType php inoremap <buffer> <C-l> <End>;<Enter>
autocmd FileType php inoremap <buffer> <C-b> <C-Left>$<Esc>ea
autocmd FileType php inoremap <buffer> <C-k> <End>->
autocmd FileType php inoremap <buffer> <C-t> <C-Left>$<Esc>ea->
if has('gui_running')
    autocmd FileType php inoremap <buffer> <C-Space> <C-Left>$<Esc>ea<Space>= 
else
    autocmd FileType php inoremap <buffer> <C-@> <C-Left>$<Esc>ea<Space>= 
endif
autocmd FileType php smap <buffer> <C-k> <Esc><C-Left><S-Left>viwldea
inoremap <C-u> <Esc>ui

" if has("gui_running")
" noremap <C-Z> <cr>
" endif

" open temp buffer file to paste selection
exec "vnoremap <C-N> y:<C-U>e /tmp/buffer<cr><Esc>O" . repeat('-', 120) . "<cr><Esc>pggO<Esc>"

" Buffer Switch Quickly
map <silent> <M-0> :bl<cr>
for n in [1,2,3,4,5,6,7,8,9]
    exe 'map <silent> <M-' . n . '> :call GoToBuffer('. n . ')<cr>'
endfor
map <silent> <Tab> :call GoToBufferNext('next')<cr>
map <silent> <S-Tab> :call GoToBufferNext('prev')<cr>
"{{{
func! GoToBufferNext(tag)
    let s:commandstr = a:tag == 'next' ? 'bn' : 'bp'
    " let s:arr = ['tagbar', 'nerdtree', 'qf', 'ctrlsf', 'runner']
    " if index(s:arr, &filetype) == -1 
    let s:arrlist = GetBufListsNu()
    if index(s:arrlist, bufnr('%')) > -1 && winnr('$') == 1
        execute s:commandstr
    endif
endfunc
function! GoToBuffer(tag) abort
    let s:nr = GetBufNr(a:tag)
    if s:nr > 0 && buflisted(bufnr('%'))
        exe 'b' . s:nr
        " if buflisted(a:tag)
        " exe 'b' . a:tag
        " elseif a:tag == 1
        " exe 'b' . s:nr
    endif
endfunction 
"}}}
"}}}
"}}}

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => vim-session, Remember opened file when exit
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" MaximizeWindow
"{{{
" The bottom will more one line when vim session is loaded in notebook.
if has('gui_running')
    autocmd SessionLoadPost,GuiEnter * : call Maximize_Window()
endif
"{{{
function Maximize_Window()
    " fixed bug: plugin vim-session command OpenSession blank a bottom line
    silent !wmctrl -r :ACTIVE: -b toggle,maximized_vert,maximized_horz
    " here is the originally main code only
    silent !wmctrl -r :ACTIVE: -b add,maximized_vert,maximized_horz
    " additional code
    lang en_US.utf8
endfunction
"}}}
" Go to last file(s) if invoked without arguments. 
" autocmd VimLeave * nested if (!isdirectory($HOME . "/.vim")) |
" \ call mkdir($HOME . "/.vim") |
" \ endif |
" \ execute "mksession! " . $HOME . "/.vim/Session.vim"

" autocmd VimEnter * nested if argc() == 0 && filereadable($HOME . "/.vim/Session.vim") |
" \ execute "source " . $HOME . "/.vim/Session.vim" 
"}}}

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => markdown preview
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"{{{
" from http://www.jmlog.com/use-pandoc-to-preview-markdown-in-vim/ 
command! PreviewMarkdown call PreviewMarkdown()
"{{{
function! PreviewMarkdown()
    if !executable('pandoc')
        echohl ErrorMsg | echo 'Please install pandoc first.' | echohl None
        return
    endif
    let BROWSER_COMMAND = 'xdg-open'
    let output_file = tempname() . '.html'
    let input_file = tempname() . '.md'
    let css_file = 'file://' . expand('/opt/lampp/htdocs/tools/pandoc/markdown.css', 1)
    " Convert buffer to UTF-8 before running pandoc
    let original_encoding = &fileencoding
    let original_bomb = &bomb
    silent! execute 'set fileencoding=utf-8 nobomb'
    " Generate html file for preview
    let content = getline(1, '$')
    let newContent = []
    for line in content
        let str = matchstr(line, '\(!\[.*\](\)\@<=.\+\.\%(png\|jpe\=g\|gif\)')
        if str != "" && match(str, '^https\=:\/\/') == -1
            let newLine = substitute(line, '\(!\[.*\]\)(' . str . ')',
                        \'\1(file://' . escape(expand("%:p:h", 1), '\') . 
                        \('/') . 
                        \escape(expand(str, 1), '\') . ')', 'g')
        else
            let newLine = line
        endif
        call add(newContent, newLine)
    endfor
    call writefile(newContent, input_file)
    silent! execute '!pandoc -f markdown_github -t html -s -S -c "' . css_file . '" -o "' . output_file .'" "' . input_file . '"'
    call delete(input_file)
    " Change encoding back
    silent! execute 'set fileencoding=' . original_encoding . ' ' . original_bomb
    " Preview 
    silent! execute '!' . BROWSER_COMMAND . ' "' . output_file . '" &>/dev/null'
    execute input('Press ENTER to continue...')
    echo
    call delete(output_file)
    exec "redraw!"
endfunction
"}}}
"}}}


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => open url under cursor with browser, replace default command 'gx'
"    default commands 'gf' can open file under cursor, 'gd' can highlight word
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"{{{
" k
" 
nnoremap gx :call HandleURL()<cr>
"{{{
function! HandleURL()
    " notcie: if use 'xdg-open', it won't work in gvim.
    let BROWSER_COMMAND = 'google-chrome'
    let s:uri = matchstr(getline("."), "[a-z]*:\/\/[^ 　>,;'\"]*")
    echo s:uri
    if s:uri != ""
        exec "Silent !" . BROWSER_COMMAND . " \"".s:uri."\" &>/dev/null"
    else
        echo "No URI found in line."
    endif
endfunction 
"}}}
"}}}

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => autoload file when changed by other editor.
" insert mode will trigger warnning dialog.
" normal mode is doing well.
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Find diff change 
"{{{
"{{{
function! DiffOrig()
    if &diff
        wincmd p | bdel | diffoff
    else
        vert new | set bt=nofile | r # | 0d_ | diffthis | wincmd p | diffthis
    endif
endfunction
"}}}
map <leader>do :call DiffOrig()<cr>
set autoread
set autowriteall 
"}}}

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => make the code right
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"{{{
command Coderight call MakeTheCodeRight() 
"{{{
function! MakeTheCodeRight() abort
    try
        silent exe "%s/  / /g"
        silent exe "%s/；/;/g"
        silent exe "%s/＂/\"/g"
        silent exe "%s/（/(/g"
        silent exe "%s/）/)/g"
        silent exe "%s/｛/{/g"
        silent exe "%s/｝/}/g"
        silent exe "%s/ / /g"
    catch
    endtry
    echo "codes had been maked right."
endfunction 
"}}}
"}}}

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => copy filename
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"{{{
command Filename call CopyFilePath('t') 
command Filepath call CopyFilePath('p')
nmap <C-C>f :Filename<CR>
nmap <C-C>c :Filepath<CR>
"{{{
function! CopyFilePath(type) abort
    let s:filename = expand('%:' . a:type)
    exe 'Silent !echo "' . s:filename . '" | xsel --input -b'
    exe 'echo "copy file: ' . s:filename . '"'
endfunction
"}}}

nmap <silent> <C-k><C-b> :call ToggleLabelBar()<CR>
"{{{
function! ToggleLabelBar() abort
    exe 'set showtabline=' . (&showtabline==0 ? 2 : 0)
    exe 'set laststatus=' . (&laststatus==0 ? 2 : 0)
endfunction 
"}}}
"}}}

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => hope to auto effect bash_aliases file, but it doesn't ok.
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"{{{
" autocmd VimLeave * :call AutoSourceFiles() 
" function! AutoSourceFiles() abort
" let s:filename = expand('%:P')
" if match(s:filename, "bash\_alias")
" exe "!source " . s:filename
" endif
" endfunction
" For snippet_complete marker.
if has('conceal')
    set conceallevel=2 concealcursor=i
endif 
"}}}

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Comamnd 'ban' like 'ba' and 'vert ba', but be more nautual.
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"{{{
cabbrev ban LayoutBuffer
command! -nargs=* LayoutBuffer call s:Layout_buffer_allinone(<f-args>)
"{{{
function! s:Layout_buffer_allinone(col)
    " let expr = printf('%d/%d.0', a:row, a:col)
    " let trow = eval(expr)

    " set split window rule
    let l:sb = &splitbelow
    let l:sr = &splitright
    set splitbelow
    set splitright

    let l:arrlist = GetBufListsNu()

    exec 'only'

    let index = 0
    while index < len(l:arrlist)
        let item = l:arrlist[index]
        " execute input('DEBUG: Press ENTER to continue... ' . bufname(item))
        if index == 0
            exec 'vsp ' . bufname(item)
            exe "normal \<c-w>\<c-w>"
            exe 'q'
        elseif index < a:col 
            exec 'vsp ' . bufname(item)
        else
            if index % a:col == 0
                exe "normal " . (a:col - 1) . "\<c-w>h"
            else
                exe "normal \<c-w>l"
            endif
            exec 'sp ' . bufname(item)
        endif
        let index = index + 1
    endwhile

    " reset split window rule
    if l:sb == 0
        set splitbelow!
    endif
    if l:sr == 0
        set splitright!
    endif

endfunction
"}}}
"}}}
