#------------------------------------------------ 
# Makefile for dotfile
#------------------------------------------------ 
#=> install or recover all dotfile to system
define publish
	rsync -av \
		--exclude 'vim-install.sh'\
		--exclude 'preview.png'\
		--exclude '.gitignore'\
		--exclude '.git'\
		--exclude 'fugitive:'\
		--exclude 'README.md'\
		--exclude 'LICENSE'\
		--exclude 'Makefile'\
		./ ../
endef

#=> install vim dependens
define installvim
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

.PHONY: publish
publish:
	echo "sync dotfiles folder to home folder"
	@$(publish)

all: ivim publish

.PHONY: ivim
ivim:
	echo "install vim dependens"
	$(installvim)

