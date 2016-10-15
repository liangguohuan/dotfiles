if has('nvim')
"{{{
let g:python_host_prog  = '/home/hanson/.pyenv/versions/neovim2/bin/python'
let g:python3_host_prog = '/home/hanson/.pyenv/versions/neovim3/bin/python'
"}}}
endif

set nocompatible              " be iMproved, required
filetype off                  " required

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
" alternatively, pass a path where Vundle should install plugins
" call vundle#begin('~/some/path/here')

" let Vundle manage Vundle, required
Plugin 'gmarik/Vundle.vim'

if has('nvim')
"{{{
Plugin 'https://github.com/Valloric/YouCompleteMe.git'
Plugin 'https://github.com/SirVer/ultisnips.git'
Plugin 'https://github.com/honza/vim-snippets.git'
"}}}
else
"{{{
" https://github.com/Shougo/neocomplete.vim.git
Plugin 'Shougo/neocomplete'
Plugin 'Shougo/neosnippet'
Plugin 'Shougo/neosnippet-snippets'
"}}}
endif

" vim-session
" Plugin 'https://github.com/xolox/vim-misc.git'
" Plugin 'https://github.com/xolox/vim-session.git'

" base editor plugins {{{
Plugin 'https://github.com/altercation/vim-colors-solarized.git'
Plugin 'https://github.com/ryanoasis/vim-devicons.git'
Plugin 'https://github.com/lambdalisue/vim-fullscreen.git'
Plugin 'https://github.com/bling/vim-airline.git'
Plugin 'https://github.com/vim-airline/vim-airline-themes.git'
Plugin 'https://github.com/edkolev/tmuxline.vim.git'
Plugin 'https://github.com/scrooloose/syntastic.git'
Plugin 'https://github.com/yonchu/accelerated-smooth-scroll.git'
Plugin 'https://github.com/scrooloose/nerdcommenter.git'
Plugin 'https://github.com/Yggdroot/indentLine.git'
Plugin 'https://github.com/plasticboy/vim-markdown.git'
" }}}
" extended {{{
Plugin 'https://github.com/tpope/vim-dispatch.git'
Plugin 'https://github.com/tpope/vim-surround.git'
Plugin 'https://github.com/tpope/vim-eunuch.git'
Plugin 'https://github.com/tpope/vim-repeat.git'
Plugin 'https://github.com/tpope/vim-abolish.git'
Plugin 'https://github.com/duggiefresh/vim-easydir.git'
Plugin 'https://github.com/terryma/vim-multiple-cursors.git'
Plugin 'https://github.com/vim-scripts/YankRing.vim.git'
Plugin 'https://github.com/junegunn/goyo.vim.git'
Plugin 'https://github.com/roman/golden-ratio.git'
Plugin 'https://github.com/jiangmiao/auto-pairs.git'
if !has('nvim')
Plugin 'https://github.com/bruno-/vim-alt-mappings.git'
endif
Plugin 'https://github.com/taku-o/vim-toggle.git'
Plugin 'https://github.com/thinca/vim-qfreplace.git'
Plugin 'https://github.com/Konfekt/FastFold.git'
Plugin 'https://github.com/kopischke/vim-stay.git'
Plugin 'https://github.com/mhinz/vim-startify.git'
" }}}
" snipmate {{{
" Plugin 'tomtom/tlib_vim'
" Plugin 'MarcWeber/vim-addon-mw-utils'
" Plugin 'https://github.com/garbas/vim-snipmate'
" Plugin 'https://github.com/honza/vim-snippets.git'
" }}}
" Shougo Serise {{{
Plugin 'https://github.com/Shougo/unite.vim.git'
Plugin 'https://github.com/Shougo/neomru.vim.git'
Plugin 'https://github.com/Shougo/vimfiler.vim.git'
Plugin 'https://github.com/Shougo/vimproc.vim.git'
Plugin 'https://github.com/Shougo/vimshell.git'
Plugin 'https://github.com/Shougo/tabpagebuffer.vim.git'
Plugin 'https://github.com/Shougo/unite-outline.git'
Plugin 'https://github.com/chemzqm/unite-location.git'
Plugin 'https://github.com/Kocha/vim-unite-tig.git'
" }}}
" development tools {{{
Plugin 'https://github.com/tpope/vim-fugitive.git'
Plugin 'https://github.com/gregsexton/gitv.git'
Plugin 'https://github.com/airblade/vim-gitgutter.git'
" Plugin 'https://github.com/vim-scripts/vcscommand.vim.git'
" }}}
" sidebar tools {{{
Plugin 'https://github.com/scrooloose/nerdtree.git'
Plugin 'https://github.com/majutsushi/tagbar.git'
if !has('nvim')
Plugin 'https://github.com/Yggdroot/LeaderF.git'
endif
Plugin 'https://github.com/dyng/ctrlsf.vim.git'
Plugin 'https://github.com/rking/ag.vim.git'
Plugin 'https://github.com/sjl/gundo.vim.git'
Plugin 'https://github.com/MattesGroeger/vim-bookmarks.git'
Plugin 'https://github.com/vim-scripts/TaskList.vim.git'
" }}}
" vim motions {{{
Plugin 'https://github.com/godlygeek/tabular.git'
Plugin 'https://github.com/junegunn/vim-easy-align.git'
Plugin 'https://github.com/Lokaltog/vim-easymotion.git'
Plugin 'https://github.com/haya14busa/incsearch.vim.git'
Plugin 'https://github.com/haya14busa/incsearch-easymotion.vim.git'
Plugin 'https://github.com/terryma/vim-expand-region.git'
Plugin 'https://github.com/tommcdo/vim-exchange.git'
Plugin 'https://github.com/vim-scripts/argtextobj.vim.git'
Plugin 'https://github.com/mattn/emmet-vim'
" Plugin 'https://github.com/bkad/CamelCaseMotion.git'
" }}}
" my custom {{{
Plugin 'https://github.com/liangguohuan/vim-php-snippets'
Plugin 'https://github.com/liangguohuan/vim-monokai.git'
Plugin 'https://github.com/liangguohuan/vim-script-runner'
Plugin 'https://github.com/liangguohuan/vim-shell-executor.git'
Plugin 'https://github.com/liangguohuan/vim-control-window.git'
Plugin 'https://github.com/liangguohuan/vim-toggle-abbrevs.git'
Plugin 'https://github.com/liangguohuan/vim-templates.git'
" }}}
" php plugins {{{
Plugin 'https://github.com/alvan/vim-php-manual.git'
Plugin 'https://github.com/shawncplus/phpcomplete.vim'
Plugin 'https://github.com/m2mdas/phpcomplete-extended'
" Plugin 'https://github.com/m2mdas/phpcomplete-extended-laravel'
Plugin 'https://github.com/vim-php/vim-php-refactoring.git'
Plugin 'https://github.com/stephpy/vim-php-cs-fixer.git'
" }}}
" Plugin 'https://github.com/ervandew/supertab'
" tools {{{
Plugin 'https://github.com/szw/vim-tags'
Plugin 'https://github.com/christoomey/vim-tmux-navigator.git'
Plugin 'https://github.com/tmux-plugins/vim-tmux-focus-events.git'
Plugin 'https://github.com/suan/vim-instant-markdown.git'
Plugin 'https://github.com/vimwiki/vimwiki'
Plugin 'https://github.com/jez/vim-superman.git'
Plugin 'https://github.com/mattn/webapi-vim.git'
Plugin 'https://github.com/Rykka/trans.vim.git'
Plugin 'https://github.com/seyDoggy/vim-watchforchanges.git'
" }}}
" All of your Plugins must be added before the following line
call vundle#end()            " required
filetype plugin indent on    " required
" To ignore plugin indent changes, instead use:"{{{
"filetype plugin on
"
" Brief help
" :PluginList       - lists configured plugins
" :PluginInstall    - installs plugins; append `!` to update or just :PluginUpdate
" :PluginSearch foo - searches for foo; append `!` to refresh local cache
" :PluginClean      - confirms removal of unused plugins; append `!` to auto-approve removal
"
" see :h vundle for more details or wiki for FAQ
" Put your non-Plugin stuff after this line"}}}

source ~/.vim-basic.vim
source ~/.vim-plugin.vim




" vim: set fdm=marker ts=4 sw=4 sts=4 expandtab
