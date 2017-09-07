This is my vim, zsh, tmux, etc. files.
===
All dotfiles can be installed or recovered via Makefile commands simplely. See helps below.
> WARN: the dotfiles must in user home, depth 1

## install
```
cd ~
git clone https://github.com/liangguohuan/dotfiles
cd dotfiles
make all
```

## Makefile commands
* `publish` (default command)  
    publish dotfiles to system
* `push`  
    push system updated files to dotfiles folder
* `ivim-depends`  
    install vim depends
* `ivim`  
    install vim
* `install`  
    exec all Makefile commands
* `all`  
    same as command `install`

## vim install (only)
vim-conf base on [amix/vimrc](https://github.com/amix/vimrc). But use [ junegunn/vim-plug ](https://github.com/junegunn/vim-plug) to manage vim plugins,
and so many things to be changed, just get some helps from `amix/vimrc` and read the sources from files `.vim-basic.vim` & `.vim-plugins`

* ### install

  - Step 1: clone the files and install.
    > Notice: it will overwrite the files '.vimrc', '.vim-basic', '.vim-plugins' if they exists in home folder `~`
  
          git clone https://github.com/liangguohuan/dotfiles
          cd dotfiles
          make ivim
  
  - Step 3: Test it, it might need something other program like (ack, ag, install-markdown-d).
  
      ag: https://github.com/ggreer/the_silver_searcher#linux  
      install-markdown-d: https://github.com/suan/vim-instant-markdown#installation

* ### Notices:
  - It works well on platform ubuntu, and works well in windows too if you do something change.
  - muticursor plugins need something other to do. If muticursor plugin works bad, just put these codes below to `~/.bashrc` or `~/.zshrc`(if you use zsh)

        # => vim-multiple-cursors must do this for doing well.
        stty ixany
        stty ixoff -ixon


* ### Preview
<div align="center">
<img alt="" src="https://raw.githubusercontent.com/liangguohuan/vim-zsh-tmux-conf/master/preview.png" />
<br><br>
</div>
