#!/bin/bash

# Tips:
# use xwininfo can get window info
# use xprop WM_CLASS can get window class
# use xmodemap can chage key map
# use xev can get keyboard info
# use xdotool can control window
# use wmctrl can contrl window too
#
# Warn:
#   alias contain variable or function, the best way is use single quote ' to  wrap
#   Example: alais xxx='_f(){ echo $1 $2 $3; }; _f'

# => lead bug: these codes will echo ascii when command exec finish in zsh
# ------------ but zsh work well in tmux.
# export TERM="xterm-256color"
if [ "$TERM" = "xterm" ]; then
    export TERM=xterm-256color
fi
if [ "$TERM" = "screen" -o "$TERM" = "screen-256color" ]; then
    export TERM=screen-256color
    unset TERMCAP
fi

# => ctrl + s will be trigger vim dead, so do this.
# => vim-multiple-cursors must do this for doing well.
stty ixany
stty ixoff -ixon

export PYENV_VIRTUALENV_DISABLE_PROMPT=1
export PYENV_VERSION='system'
export PATH="$HOME/.pyenv/bin:$PATH"
eval "$(pyenv init -)"
eval "$(pyenv virtualenv-init -)"

# eval $(thefuck --alias)

# pyenv pycurl need it from lammp, bad idea: ipython will not work
# fixed: cp system pycurl.so to pyenv version, like below:
#
# sudo -u hanson cp /usr/lib/python2.7/dist-packages/pycurl.so 
# /home/hanson/.pyenv/versions/2.7.11/envs/default/lib/python2.7/site-packages/pycurl.so
#
# export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/opt/LD_LIBRARY_PATH/pycurl

export DEV_ENV=local
export VAGRANT_HOME=~/.vagrant.d
export APP_HOME=/usr/share/applications
export ICONS_HOME=/usr/share/icons
export CHROME_BIN=/usr/bin/google-chrome
export MIMEPATH=~/.local/share/applications/mimeapps.list
export SANDBOX_BINARY=/home/hanson/mysql
export JAVA_HOME=/usr/lib/jvm/java-8-oracle
export JRE_HOME=${JAVA_HOME}/jre
export CLASSPATH=.:${JAVA_HOME}/lib:${JRE_HOME}/lib
export NODE_PATH=/usr/local/lib/node_modules
export PYTHONPATH=/usr/local/lib/python2.7/site-packages/py/
export ZOOKEEPER_HOME=/opt/zookeeper
export STORM_HOME=/opt/storm
export MONGODB_HOME=/opt/mongodb
export LAMPP_HOME=/opt/lampp
export COMPOSER_PATH=/home/hanson/.composer/vendor/bin
export GOPATH=$HOME/.go
export PATH=$GOPATH/bin:$JAVA_HOME/bin:$STORM_HOME/bin:$ZOOKEEPER_HOME/bin:$MONGODB_HOME/bin:$COMPOSER_PATH:$PATH
export PATH=.:$HOME/CodeHub/SHELL:$PATH
# export PHP_EXTENSION_PATH=$(php -i | grep ^extension_dir | awk -F ' => ' '{print $2}')
export PHP_EXTENSION_PATH=/opt/lampp/lib/php/extensions/no-debug-non-zts-20151012
export DOCSWEB=/home/hanson/Data/docs-web
export XDG_CONFIG_HOME=~/.config
export EDITOR=vim

export LANGUAGE=en_US.UTF-8 git vi vim gvim

## sample:
# - list all symbols links in /usr/bin: ll /usr/bin/*(@)
# - list all symbols links in current dir: ll .*(@)
# - list all symbols links in current dir's subdirs: ll .*/**(@)
alias ls='ls --color=auto'
alias llu="ls -tlrh"
alias llf='_f(){ pwd=$(pwd); cd ${1:-.}; ls | fullpath; cd $pwd; }; _f'
alias lls="ll .*(@)"
alias fullpath="xargs -n 1 readlink -f"
alias cls="clear"
alias clsa='printf "\033c"'
alias grep='grep --color'
alias ubuntu="lsb_release -a"
alias mcf="vim ~/.bash_aliases"
alias mcfn="source ~/.bash_aliases && echo alias files has been updated."
alias mcfv='cat ~/.bash_aliases | grep -P "(alias [a-z-]{3,}=\")|(export )" | sed -r "s/^\s+//" | less'
alias update="sudo apt update"
alias upgrade="sudo apt upgrade"
alias updateall="sudo apt update && sudo apt upgrade"
alias aptsearch="sudo apt search"
alias aptgoagent="sudo apt -o Dir::Etc::sourcelist='-' -o Acquire::http::proxy='http://127.0.0.1:8087/' -o Acquire::https::dl.google.com::Verify-Peer='false' update"
alias aptshow="sudo apt show"
alias aptinstall="sudo apt install"
alias aptremove="sudo apt remove"
alias aptpurge="sudo aptitude purge"
alias aptautoremove="sudo apt autoremove"
alias aptfix="sudo apt -f install"
alias gpgkeyfix='sudo apt-key adv --recv-keys --keyserver keyserver.ubuntu.com $1'
alias poweroff="sudo poweroff"
alias reboot="sudo reboot"
alias testnet="ping 163.com"
alias vm="ssh vagrant@127.0.0.1 -p 2222"
alias unpack="/usr/bin/dtrx"
alias disk="df -lTh -x aufs"
alias psaux="ps aux | grep -v grep | grep"
alias zhuxiao="gnome-session-quit --logout --no-prompt"
alias mysqlconf="sudo vim /opt/lampp/etc/my.cnf"
alias showmaster="mysql -uroot --password='' -e 'show master status;'"
alias redisconf="cat /etc/redis.conf | grep -v ^# | grep -v ^$"
alias uvn='uname -r | awk -F "-" "{print \$1\"-\"\$2}"'
alias neihe-old='sudo dpkg --get-selections | grep -P "linux-(headers|image)-([0-9.-]+|extra-[0-9])" | grep -v `uvn`| awk "{print \$1}"'
alias hostconf="sudo vi /etc/hosts"
alias hostview="less /etc/hosts"
alias icons="nautilus ~/.local/share/icons/"
alias desktop-top="nautilus ~/.local/share/applications/"
alias uuids="sudo blkid"
alias gateway="route -n"
alias phpconf="sudo vi + /opt/lampp/etc/php.ini"
alias dush="du -sh"
alias syslog="tail -f /var/log/syslog -n 100"
alias autoeng="sudo vi +$ /usr/share/fcitx/data/AutoEng.dat"
alias proxy='_f(){ export HTTP_PROXY=${1:-127.0.0.1:8087} && export HTTPS_PROXY=${1:-127.0.0.1:8087} && echo "use ${1:-127.0.0.1:8087} proxy sucessed."; }; _f'
alias proxydisable="export HTTP_PROXY= && export HTTPS_PROXY= && echo 'cancel proxy sucessed.'"
alias cdjekyll="cd ~/Data/Latest/jekyll/dark.github.io/"
alias sjekyll="cdjekyll && jekyll s && cd - && cls"
# => google-chrome apps custom start
alias gqq="google-chrome --app='http://web.qq.com' &>/dev/null"
alias gnote="google-chrome --app='http://www.maxiang.info' &>/dev/null"
alias gmusic="google-chrome --app='http://music.163.com/#/my/m/music/playlist?id=37040212' &>/dev/null"
# setting width and height for app.
# alias gbaidu="google-chrome --user-data-dir=/tmp/163 --window-size=1000,600 --window-position=380,240 --app="http://www.baidu.com/" &>/dev/null &"
# => google-chrome apps custom ending
# close notebook screen via command, and recover it via keyboard <Fn+F4>
alias closescreen="xrandr | grep primary | awks 1 | xargs -i xrandr --output {} --off"
alias networkrestart="sudo ifdown eth0 && sudo ifup eth0"
# alias hs="homestead"
alias de="docker"
alias dm="docker-compose"
alias dl="docker ps -l -q"
alias dls="docker ps -a"
alias dis="docker images"
alias laradock="docker-compose up -d nginx mysql redis"
alias vmdock="docker-compose exec workspace bash"
alias docweb="start-stop-daemon --start --background --name=docweb --exec /home/hanson/CodeHub/MISC/local-host-bind.py \
    && xdg-open http://localhost:8888/index/docs-html/ &>/dev/null"
alias cscope-update="find . -name '*.php' -type f > cscope.files && cscope -bq"
# copy file content to clipboard: cfc [filename]
alias cfc="xsel -b -i <"
alias cptoclip=cfc
alias trash="sudo trash"
alias trash-put="sudo trash"
alias trash-list="sudo trash-list"
alias gdriver="skicka"
alias baiduyun="pcs"
alias randomchars='python -c "import random,string;print \"\".join(random.sample(string.ascii_letters+string.digits, 16)).lower()"'
alias temphostname="sudo hostname android-obylyw02ziobm8fr"
alias china-weather-restart='psaux indicator-china-weather | grep -v color | awk "{print \$2}" | xargs kill -9 && start-stop-daemon --exec /usr/bin/indicator-china-weather --start --background'
alias t="tmux"
# good for session deattach from <keyprefix>d
alias tt="tmux attach -t"
alias td="tmux attach -d"
alias m="tmuxinator"
alias ms="tmuxinator start $1 &>/dev/null" # use single quote got no completion -_-
alias msd="tmuxinator start default &>/dev/null"
alias ToggleTouchpad='_f(){ eval `synclient | grep TouchpadOff | tr -d " "`; [[ $TouchpadOff == 1 ]] && V=0 || V=1;synclient TouchpadOff=$V }; _f'
alias nv="nvim"
alias fv="vifm"
alias fr="ranger"
alias scd="smartcd"
alias squidreload="docker kill -s HUP squid"
alias squidlogin='docker exec -i -t $(docker ps | grep squid | awk "{print \$1}") bash'
alias vsload='_f(){ vi -c "FSLoad $1"; }; _f'
alias nvsload='_f(){ nv -c "FSLoad $1"; }; _f'
# alias imgresize='_f(){ ffmpeg -i $3 -vf scale=$1:$2 $4 -y &>/dev/null; }; _f'
alias imgresize='_f(){ convert -resize $1x$2\! $3 $4; }; _f'

