" nvim python virtual environments.
let g:python_host_prog  = '/home/hanson/.pyenv/versions/neovim2/bin/python'
let g:python3_host_prog = '/home/hanson/.pyenv/versions/neovim3/bin/python'

set nocompatible              " be iMproved, required
filetype off                  " required

" vim-plug start
call plug#begin('~/.vim/bundle')

" base editor plugins {{{
if has('nvim')
    Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
    Plug 'zchee/deoplete-jedi', { 'for': 'python' }
    Plug 'Shougo/neosnippet'
    Plug 'Shougo/neosnippet-snippets'
else
    Plug 'https://github.com/Valloric/YouCompleteMe.git'
    Plug 'https://github.com/SirVer/ultisnips.git'
    Plug 'https://github.com/honza/vim-snippets.git'
endif

Plug 'https://github.com/morhetz/gruvbox.git'
Plug 'https://github.com/tomasr/molokai.git'
Plug 'https://github.com/nanotech/jellybeans.vim.git'
Plug 'https://github.com/ryanoasis/vim-devicons.git'
Plug 'https://github.com/lambdalisue/vim-fullscreen.git'
Plug 'https://github.com/bling/vim-airline.git'
Plug 'https://github.com/vim-airline/vim-airline-themes.git'
Plug 'https://github.com/edkolev/tmuxline.vim.git'
Plug 'https://github.com/scrooloose/syntastic.git'
Plug 'https://github.com/yonchu/accelerated-smooth-scroll.git'
Plug 'https://github.com/scrooloose/nerdcommenter.git'
Plug 'https://github.com/Yggdroot/indentLine.git'
Plug 'https://github.com/plasticboy/vim-markdown.git', { 'for': 'markdown' }
" }}}
" extended {{{
Plug 'https://github.com/tpope/vim-dispatch.git'
Plug 'https://github.com/tpope/vim-surround.git'
Plug 'https://github.com/tpope/vim-eunuch.git'
Plug 'https://github.com/tpope/vim-repeat.git'
Plug 'https://github.com/tpope/vim-abolish.git'
Plug 'https://github.com/duggiefresh/vim-easydir.git'
Plug 'https://github.com/terryma/vim-multiple-cursors.git'
Plug 'https://github.com/vim-scripts/YankRing.vim.git'
Plug 'https://github.com/junegunn/goyo.vim.git'
Plug 'https://github.com/roman/golden-ratio.git'
Plug 'https://github.com/jiangmiao/auto-pairs.git'
if !has('nvim')
Plug 'https://github.com/vim-utils/vim-alt-mappings.git'
endif
Plug 'https://github.com/taku-o/vim-toggle.git'
Plug 'https://github.com/thinca/vim-qfreplace.git'
Plug 'https://github.com/mhinz/vim-startify.git'
" }}}
" Shougo Serise {{{
Plug 'https://github.com/Shougo/unite.vim.git'
Plug 'https://github.com/Shougo/neomru.vim.git'
Plug 'https://github.com/Shougo/vimfiler.vim.git'
Plug 'https://github.com/Shougo/vimproc.vim.git', {'do' : 'make'}
Plug 'https://github.com/Shougo/vimshell.git'
Plug 'https://github.com/Shougo/tabpagebuffer.vim.git'
Plug 'https://github.com/Shougo/unite-outline.git'
Plug 'https://github.com/chemzqm/unite-location.git'
Plug 'https://github.com/Kocha/vim-unite-tig.git'
" }}}
" development tools {{{
Plug 'https://github.com/tpope/vim-fugitive.git'
Plug 'https://github.com/gregsexton/gitv.git'
Plug 'https://github.com/airblade/vim-gitgutter.git'
" Plug 'https://github.com/vim-scripts/vcscommand.vim.git'
" }}}
" sidebar tools {{{
Plug 'https://github.com/majutsushi/tagbar.git'
Plug 'https://github.com/dyng/ctrlsf.vim.git'
Plug 'https://github.com/rking/ag.vim.git'
Plug 'https://github.com/sjl/gundo.vim.git'
Plug 'https://github.com/MattesGroeger/vim-bookmarks.git'
Plug 'https://github.com/vim-scripts/TaskList.vim.git'
" }}}
" vim motions {{{
Plug 'https://github.com/godlygeek/tabular.git'
Plug 'https://github.com/junegunn/vim-easy-align.git'
Plug 'https://github.com/Lokaltog/vim-easymotion.git'
Plug 'https://github.com/haya14busa/incsearch.vim.git'
Plug 'https://github.com/haya14busa/incsearch-easymotion.vim.git'
Plug 'https://github.com/haya14busa/incsearch-fuzzy.vim.git'
Plug 'https://github.com/terryma/vim-expand-region.git'
Plug 'https://github.com/tommcdo/vim-exchange.git'
Plug 'https://github.com/vim-scripts/argtextobj.vim.git'
Plug 'https://github.com/mattn/emmet-vim'
" Plug 'https://github.com/bkad/CamelCaseMotion.git'
" }}}
" my custom {{{
Plug 'https://github.com/liangguohuan/vim-php-snippets', { 'for': 'php' }
Plug 'https://github.com/liangguohuan/vim-monokai.git'
Plug 'https://github.com/liangguohuan/vim-shell-executor.git'
Plug 'https://github.com/liangguohuan/vim-control-window.git'
Plug 'https://github.com/liangguohuan/vim-toggle-abbrevs.git'
Plug 'https://github.com/liangguohuan/vim-templates.git'
" }}}
" php plugins {{{
Plug 'https://github.com/alvan/vim-php-manual.git', { 'for': 'php' }
Plug 'https://github.com/shawncplus/phpcomplete.vim', { 'for': 'php' }
Plug 'https://github.com/m2mdas/phpcomplete-extended', { 'for': 'php' }
Plug 'https://github.com/m2mdas/phpcomplete-extended-laravel', { 'for': 'php' }
Plug 'https://github.com/vim-php/vim-php-refactoring.git', { 'for': 'php' }
Plug 'https://github.com/stephpy/vim-php-cs-fixer.git', { 'for': 'php' }
" }}}
" tools {{{
Plug 'https://github.com/szw/vim-tags'
Plug 'https://github.com/christoomey/vim-tmux-navigator.git'
Plug 'https://github.com/tmux-plugins/vim-tmux-focus-events.git'
Plug 'https://github.com/wellle/tmux-complete.vim.git'
Plug 'https://github.com/suan/vim-instant-markdown.git', { 'for': 'markdown' }
Plug 'https://github.com/vimwiki/vimwiki'
Plug 'https://github.com/jez/vim-superman.git'
Plug 'https://github.com/seyDoggy/vim-watchforchanges.git'
Plug 'https://github.com/thinca/vim-quickrun.git'
" }}}

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


" vim: set fdm=marker ts=4 sw=4 sts=4 expandtab
