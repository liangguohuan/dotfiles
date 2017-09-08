#------------------------------------------------ 
# Makefile for dotfile
# 
# WARN: the dotfiles must in user home, depth 1
#------------------------------------------------ 
#=> install dotfiles to system
define publish
	rsync -av --exclude-from exclude.txt ./ ../
endef

#=> push system updated files to dotfiles folder
define push
	rsync -av --existing --exclude-from exclude.txt ../ ./
endef

#=> install vim depends
define ivim-depends
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
	vim +PlugInstall +qall
endef

#=> install vim
define ivim
	cp -f .vimrc ~/
	cp -f .vim-basic.vim ~/
	cp -f .vim-plugin.vim ~/
	vim +PlugInstall +qall
endef

.PHONY: publish
publish:
	@echo "\033[38;5;2m""* sync dotfiles folder to home folder *""\033[0m"
	@$(publish)

.PHONY: push
push:
	@echo "\033[38;5;2m""* sync home folder to dotfiles folder *""\033[0m"
	@$(push)

.PHONY: ivim-depends
ivim-depends:
	@echo "\033[38;5;2m""* install vim depends *""\033[0m"
	$(ivim-depends)

.PHONY: ivim
ivim: ivim-depends
	@echo "\033[38;5;2m""* install vim *""\033[0m"
	$(ivim)

install: publish ivim
all: install

