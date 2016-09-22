#!/bin/bash

git --version &>/dev/null

if [[ $? == 0 ]]; then
    mkdir -p ~/.vim/temp_dirs/undodir/
    git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
    cp -f .vimrc ~/
    cp -f .vim-basic.vim ~/
    cp -f .vim-plugin.vim ~/
    vim +VundleInstall +qall
fi
