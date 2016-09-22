# vim-install
vim-conf base on [amix/vimrc](https://github.com/amix/vimrc). But use [ VundleVim/Vundle.vim ](https://github.com/VundleVim/Vundle.vim) to manage vim plugins,
and so many things to be changed, just get some helps from `amix/vimrc` and read the sources from files `.vim-basic.vim` & `.vim-plugins`

# install

- Step 1: clone the files, and use shell script `install.sh` to autoinsall.
  > Notice: it will overwrite the files '.vimrc', '.vim-basic', '.vim-plugins' if they exists in home fold `~`

        git clone https://github.com/liangguohuan/vim-zsh-tmux-conf
        cd vim-zsh-tmux-conf
        sh ./vim-install.sh

- Step 2: vim plugin [Shougo/vimproc.vim](https://github.com/Shougo/vimproc.vim) has something to be done.

        cd ~/.vim/bundle/vimproc.vim
        make

- Step 3: Test it, it might need something other program like (ack, ag, install-markdown-d).

# Notices:
- It works well on platform ubuntu, and works well in windows too if you do something change.
- muticursor plugins need something other to do. If muticursor plugin works bad, just put these codes below to `~/.bashrc` or `~/.zshrc`(if you use zsh)

        # => ctrl + s will be trigger vim dead, so do this.
        # => vim-multiple-cursors must do this for doing well.
        stty ixany
        stty ixoff -ixon


# Preview
[preview.png]
