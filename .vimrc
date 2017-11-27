" vim: fdm=marker ts=2 sw=2 sts=2 expandtab
"
" nvim python virtual environments.
let g:python_host_prog  = printf('%s/.pyenv/versions/neovim2/bin/python', $HOME)
let g:python3_host_prog = printf('%s/.pyenv/versions/neovim3/bin/python', $HOME)

set nocompatible              " be iMproved, required
filetype off                  " required

" vim-plug start
call plug#begin('~/.vim/bundle')

" base editor plugins {{{
if has('nvim')
  Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
  " frozen this plugin, it always get screen stuck in when do update.
  Plug 'zchee/deoplete-jedi', { 'for': 'python', 'frozen': 1 },
  Plug 'Shougo/neosnippet'
  Plug 'Shougo/neosnippet-snippets'
else
  " tips: 1.ycm need install cmake python-dev first. 2.it's better close all apps before compiling.
  Plug 'https://github.com/Valloric/YouCompleteMe.git', { 'do': './install.py --clang-completer', 'frozen':1 }
  Plug 'https://github.com/SirVer/ultisnips.git'
  Plug 'https://github.com/honza/vim-snippets.git'
endif

Plug 'https://github.com/fatih/vim-go.git'            , { 'for': 'go' }

Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all', 'frozen':1 }
" Plug 'junegunn/fzf.vim'

Plug 'https://github.com/sheerun/vim-polyglot.git'
Plug 'https://github.com/morhetz/gruvbox.git'
Plug 'https://github.com/tomasr/molokai.git'
Plug 'https://github.com/nanotech/jellybeans.vim.git'
if has("gui_running")
Plug 'https://github.com/lambdalisue/vim-fullscreen.git'
endif
Plug 'https://github.com/bling/vim-airline.git'
Plug 'https://github.com/vim-airline/vim-airline-themes.git'
if !has("gui_running")
Plug 'https://github.com/edkolev/tmuxline.vim.git'
Plug 'https://github.com/tmux-plugins/vim-tmux-focus-events.git'
endif
" Plug 'https://github.com/scrooloose/syntastic.git'
Plug 'https://github.com/w0rp/ale.git'
" Plug 'https://github.com/yonchu/accelerated-smooth-scroll.git'
Plug 'https://github.com/scrooloose/nerdcommenter.git'
Plug 'https://github.com/Yggdroot/indentLine.git'
Plug 'https://github.com/plasticboy/vim-markdown.git'            , { 'for': 'markdown' }
" }}}
" extended {{{
Plug 'https://github.com/tpope/vim-dispatch.git'
Plug 'https://github.com/tpope/vim-surround.git'
Plug 'https://github.com/tpope/vim-eunuch.git'
Plug 'https://github.com/tpope/vim-repeat.git'
Plug 'https://github.com/tpope/vim-abolish.git'
Plug 'https://github.com/tpope/vim-unimpaired.git'
Plug 'https://github.com/tpope/vim-endwise.git'
" Plug 'https://github.com/kopischke/vim-stay'
Plug 'https://github.com/duggiefresh/vim-easydir.git'
Plug 'https://github.com/terryma/vim-multiple-cursors.git'
Plug 'https://github.com/vim-scripts/YankRing.vim.git'
Plug 'https://github.com/junegunn/goyo.vim.git'                  , { 'on': 'Goyo' }
" Plug 'https://github.com/roman/golden-ratio.git'
Plug 'https://github.com/jiangmiao/auto-pairs.git'
if !has('nvim')
Plug 'https://github.com/vim-utils/vim-alt-mappings.git'
endif
Plug 'https://github.com/taku-o/vim-toggle.git'
Plug 'https://github.com/thinca/vim-qfreplace.git'
Plug 'https://github.com/mhinz/vim-startify.git'
Plug 'https://github.com/Chiel92/vim-autoformat.git'             , { 'on': 'Autoformat' }
Plug 'https://github.com/osyo-manga/vim-over.git'                , { 'on': 'OverCommandLine' }
Plug 'https://github.com/brooth/far.vim.git'                     , { 'on': ['Far', 'F'] }
Plug 'https://github.com/junegunn/rainbow_parentheses.vim.git'   , { 'on': 'RainbowParentheses' }
Plug 'https://github.com/vifm/vifm.vim.git'                      , { 'on': ['EditVifm', 'SplitVifm', 'VsplitVifm', 'DiffVifm'] }
" }}}
" Shougo Serise {{{
Plug 'https://github.com/Shougo/unite.vim.git'
Plug 'https://github.com/Shougo/neomru.vim.git'
Plug 'https://github.com/Shougo/vimfiler.vim.git'
Plug 'https://github.com/Shougo/vimproc.vim.git'                 , { 'do': 'make' }
Plug 'https://github.com/Shougo/vimshell.git'                    , { 'on': 'VimShell' }
Plug 'https://github.com/Shougo/tabpagebuffer.vim.git'
Plug 'https://github.com/Shougo/unite-outline.git'
Plug 'https://github.com/chemzqm/unite-location.git'
" }}}
" development tools {{{
Plug 'https://github.com/tpope/vim-fugitive.git'
Plug 'https://github.com/junegunn/gv.vim.git'                    , { 'on': 'GV' }
Plug 'https://github.com/tpope/vim-rhubarb.git'                  , { 'on': [ 'Gbrowse' , 'GV' ] }
Plug 'https://github.com/gregsexton/gitv.git'                    , { 'on': 'Gitv' }
Plug 'https://github.com/airblade/vim-gitgutter.git'
" Plug 'https://github.com/vim-scripts/vcscommand.vim.git'
" }}}
" sidebar tools {{{
Plug 'https://github.com/majutsushi/tagbar.git'
Plug 'https://github.com/dyng/ctrlsf.vim.git'
" Plug 'https://github.com/rking/ag.vim.git'
Plug 'https://github.com/sjl/gundo.vim.git'                      , { 'on': 'GundoToggle' }
Plug 'https://github.com/MattesGroeger/vim-bookmarks.git'       
Plug 'https://github.com/vim-scripts/TaskList.vim.git'           , { 'on': 'TaskList' }
" }}}
" vim motions {{{
Plug 'https://github.com/godlygeek/tabular.git'                  , { 'on': 'Tabularize' }
Plug 'https://github.com/junegunn/vim-easy-align.git'            , { 'on': 'EasyAlign' }
Plug 'https://github.com/Lokaltog/vim-easymotion.git'
Plug 'https://github.com/haya14busa/incsearch.vim.git'
Plug 'https://github.com/haya14busa/incsearch-easymotion.vim.git'
Plug 'https://github.com/haya14busa/incsearch-fuzzy.vim.git'
Plug 'https://github.com/terryma/vim-expand-region.git'
Plug 'https://github.com/tommcdo/vim-exchange.git'
Plug 'https://github.com/vim-scripts/argtextobj.vim.git'
Plug 'https://github.com/vim-scripts/ReplaceWithRegister.git'
Plug 'https://github.com/mattn/emmet-vim'                        , { 'for': ['html', 'css'] }
" Plug 'https://github.com/bkad/CamelCaseMotion.git'
" }}}
" my custom {{{
Plug 'https://github.com/liangguohuan/vim-php-snippets'          , { 'for': 'php' }
Plug 'https://github.com/liangguohuan/vim-monokai.git'
Plug 'https://github.com/liangguohuan/vim-shell-executor.git'    , { 'on': 'ExecuteSelection' }
Plug 'https://github.com/liangguohuan/vim-control-window.git'    , { 'on': 'ControlWindow' }
Plug 'https://github.com/liangguohuan/vim-toggle-abbrevs.git'    , { 'on': 'ToggleAbbrevs' }
Plug 'https://github.com/liangguohuan/vim-templates.git'
Plug 'https://github.com/liangguohuan/vim-layout.git'
" }}}
" php plugins {{{
Plug 'https://github.com/alvan/vim-php-manual.git'               , { 'for': 'php' }
Plug 'https://github.com/adoy/vim-php-refactoring-toolbox.git'   , { 'for': 'php' }
Plug 'https://github.com/stephpy/vim-php-cs-fixer.git'           , { 'for': 'php' }
" }}}
" javascript plugins"{{{
Plug 'marijnh/tern_for_vim',                  { 'do': 'npm install', 'for': 'javascript' }
Plug 'https://github.com/pangloss/vim-javascript.git'            , { 'for': 'javascript' }
Plug 'https://github.com/jamescarr/snipmate-nodejs.git'          , { 'for': 'javascript' }
"}}}
" lua moonscript"{{{
Plug 'https://github.com/leafo/moonscript-vim.git'               , { 'for': 'moon' }
"}}}
" tools {{{
Plug 'https://github.com/xolox/vim-misc.git'
Plug 'https://github.com/xolox/vim-easytags.git'
Plug 'https://github.com/christoomey/vim-tmux-navigator.git'
Plug 'https://github.com/tmux-plugins/vim-tmux-focus-events.git'
Plug 'https://github.com/wellle/tmux-complete.vim.git'
Plug 'https://github.com/suan/vim-instant-markdown.git'          , { 'for': 'markdown' }
" Plug 'https://github.com/vimwiki/vimwiki'
Plug 'https://github.com/seyDoggy/vim-watchforchanges.git', 
            \ { 'on': [ 'WatchForChanges', 'WatchForChangesAllFile', 'WatchForChangesWhileInThisBuffer' ] }
Plug 'https://github.com/thinca/vim-quickrun.git'                , { 'on': 'QuickRun' }
" }}}
"
" the last
Plug 'https://github.com/ryanoasis/vim-devicons.git'

" All of your Plugs must be added before the following line
call plug#end()
filetype plugin indent on    " required

" extend config
source ~/.vim-basic.vim
source ~/.vim-plugin.vim

" extra config not necessarily required
try
source ~/.vim-extra.vim
catch
endtry

