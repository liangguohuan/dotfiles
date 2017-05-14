#!/bin/bash

# install depends
sudo apt install curl git-core cmake python-dev

# pyenv install and virtualenv
curl -L https://raw.githubusercontent.com/pyenv/pyenv-installer/master/bin/pyenv-installer | bash
pyenv install 2.7.12
pyenv virtualenv 2.7.12 neovim2
pyenv install 3.6.1
pyenv virtualenv 3.6.1 neovim3

# install vim-plug
curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

mkdir -p ~/.vim/temp_dirs/undodir/
cp -f .vimrc ~/
cp -f .vim-basic.vim ~/
cp -f .vim-plugin.vim ~/
vim +PlugInstall +qall
