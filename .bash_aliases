#!/bin/bash

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

# pyenv config
export PYENV_VIRTUALENV_DISABLE_PROMPT=1
export PYENV_VERSION='system'
export PATH="/usr/local/bin/php:$HOME/.pyenv/bin:$PATH"
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

# brew config
export HOMEBREW_NO_AUTO_UPDATE=true

export DEV_ENV=local
export JAVA_HOME=/usr/lib/jvm/java-8-oracle
export NODE_PATH=/usr/local/lib/node_modules
export PYTHONPATH=/usr/local/lib/python2.7/site-packages/py/
export EDITOR=vim
export LANGUAGE=en_US.UTF-8 git vi vim gvim

export PATH=.:$HOME/CodeHub/SHELL:$PATH
# uniq path, suniq function is in file .zshrc
# export PATH=$(suniq $PATH :)

## sample:
# - list all symbols links in /usr/bin: ll /usr/bin/*(@)
# - list all symbols links in current dir: ll .*(@)
# - list all symbols links in current dir's subdirs: ll .*/**(@)
# alias ls='ls --color=auto'
alias llu="ls -tlrh"
alias llf='_f(){ pwd=$(pwd); cd ${1:-.}; ls | fullpath; cd $pwd; }; _f'
alias lls="ll .*(@)"
alias fullpath="xargs -n 1 readlink -f"
alias cls="clear"
alias clsa='printf "\033[2J\033[3J\033[1;1H"'
alias grep='grep --color'
alias mcf="vim ~/.bash_aliases"
alias mcfn="source ~/.bash_aliases && echo alias files has been updated."
alias mcfv='cat ~/.bash_aliases | grep -P "(alias [a-z-]{3,}=\")|(export )" | sed -r "s/^\s+//" | less'
alias testnet="ping 163.com"
alias unpack="/usr/bin/dtrx"
alias disk="df -lH"
alias psaux="ps aux | grep -v grep | grep"
alias hostconf="vi /etc/hosts"
alias hostview="less /etc/hosts"
alias gateway="route -n"
alias dush="du -sh"
alias syslog="tail -n 100 -f /var/log/system.log"
alias proxy='_f(){ export HTTP_PROXY=${1:-127.0.0.1:1087} && export HTTPS_PROXY=${1:-127.0.0.1:1087} && echo "use ${1:-127.0.0.1:1087} proxy sucessed."; }; _f'
alias proxydisable="export HTTP_PROXY= && export HTTPS_PROXY= && echo 'cancel proxy sucessed.'"
# => google-chrome apps custom start
alias google-chrome="/Applications/Google\ Chrome.app/Contents/MacOS/Google\ Chrome"
alias gqq="google-chrome --app='http://web.qq.com' &>/dev/null"
alias gnote="google-chrome --app='http://www.maxiang.info' &>/dev/null"
alias gmusic="google-chrome --app='https://music.163.com/#/user/home?id=16235032' &>/dev/null"
# alias hs="homestead"
alias de="docker"
alias dm="docker-compose"
alias dl="docker ps -l -q"
alias dls="docker ps -a"
alias dis="docker images"
alias randomchars='python -c "import random,string;print \"\".join(random.sample(string.ascii_letters+string.digits, 16)).lower()"'
# good for session deattach from <keyprefix>d
alias t="tmux"
alias tt="tmux attach -t"
alias td="tmux attach -d"
alias m="tmuxinator"
alias ms="tmuxinator start $1 &>/dev/null" # use single quote got no completion -_-
alias msd="tmuxinator start default &>/dev/null"
alias nv="nvim"
alias fv="vifm"
alias fr="ranger"
alias scd="smartcd"
alias squidreload="docker kill -s HUP squid"
alias squidlogin='docker exec -i -t $(docker ps | grep squid | awk "{print \$1}") bash'
alias c="composer"
# macos new
alias bi="brew install"
alias bs="brew info"
alias phpstan='docker run -v $PWD:/app --rm phpstan/phpstan'
