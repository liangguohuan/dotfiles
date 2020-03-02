# vim: fdm=marker ts=2 sw=2 sts=2 expandtab
#=======================================================================================================================
#=> function helper
#=======================================================================================================================
# => extend oh-my-zsh plugins from github repos
zplug () {
  # update all extend plugins
  if [[ "$1" == "update" ]]; then
    local rootdir=$(printf "%s/custom/plugins" "$ZSH")
    local -a pdirs=($(ls $rootdir))
    for name in $pdirs; do
      local pdir=$(printf "%s/custom/plugins/%s" "$ZSH" "$name")
      cd $pdir
      if ls .git &>/dev/null; then
        echo "\x1b[38;5;3m" "update extend plugin: ++++++ " "\x1b[48;235;3m" $name "\x1b[0m" "\x1b[38;5;3m" "++++++" "\x1b[0m"
        git pull
      fi
    done
    return
  fi
  # check | install plugins
  local repo="$1"
  local name=$(basename "$repo")
  local uri="https://github.com/$1"
  local dir=$(printf "%s/custom/plugins/%s" "$ZSH" "$name")
  [[ ! -e "$dir" ]] && {
    git clone --recursive --depth 1 "$uri" "$dir"
    [[ ! -e "$dir/$name.plugin.zsh" ]] && find "$dir" -maxdepth 1 -name "*.plugin.zsh" | xargs -J % ln -sf % "$dir/$name.plugin.zsh"  
  }
  [[ -n "$2" ]] && [[ -s "$dir/$2" ]] && [[ ! -e "$dir/$name.plugin.zsh" ]] && ln -sf "$dir/$2" "$dir/$name.plugin.zsh"
  plugins+=("$name")
}

#=======================================================================================================================
#=> oh-my-zsh: https://github.com/robbyrussell/oh-my-zsh
#=======================================================================================================================
# Path to your oh-my-zsh installation.
export ZSH=~/.oh-my-zsh
[[ ! -e "$ZSH" ]] && git clone --depth 1 https://github.com/robbyrussell/oh-my-zsh "$ZSH"

# Set name of the theme to load.
ZSH_THEME="pretty"

# Add wisely, as too many plugins slow down shell startup.
# dont use plugin fasd, it will caused 'permission denied: ../..' when alias using function is been executed.
plugins=(zsh_reload fasd git git-extras laravel5 docker docker-compose tmux tmuxinator go gem yarn pip python composer)
# plugin extends
zplug "zsh-users/zsh-syntax-highlighting"
# zplug "Tarrasch/zsh-bd"
zplug "Tarrasch/zsh-autoenv"
# zplug "zsh-users/zsh-completions"
zplug "liangguohuan/fzf-extends"
zplug "liangguohuan/fzf-marker"
#zplug "liangguohuan/zsh-dircolors-solarized"
zplug "shyiko/commacd" commacd.sh

# enabled oh-my-zsh
source $ZSH/oh-my-zsh.sh

#=======================================================================================================================
#=> extends base
#=======================================================================================================================
# {{{
#=> alias
source ~/.bash_aliases

#=> zsh-mime-setup
alias -s png=sxiv
alias -s jpg=sxiv
alias -s jpeg=sxiv
alias -s avi=mpv
alias -s mp4=mpv
alias -s mkv=mpv

#=> zsh keymap
bindkey \^U backward-kill-line

#=> misc setting
#compdef vboxmanage=VBoxManage

#=> autocomplete
zstyle ':completion:*:ping:*' hosts 163.com twitter.com facebook.com
my_accounts=(
{hanson,vagrant,root}@{192.168.1.1,192.168.0.1,202.96.128.100}
vagrant@localhost
)
zstyle ':completion:*:my-accounts' users-hosts $my_accounts

#=> try to disable zsh output someting bad when cmd finish.
DISABLE_AUTO_TITLE="true"

#=> dir hash
hash -d document=~/Documents
hash -d music=~/Music
hash -d download=~/Downloads
hash -d movies=~/Movies
hash -d picture=~/Pictures

#=> help nicely
alias run-help >&/dev/null && unalias run-help
autoload run-help

#=> sudo prefix
sudo-command-line() {
  [[ -z $BUFFER ]] && zle up-history
  [[ $BUFFER != sudo\ * ]] && BUFFER="sudo $BUFFER"
  zle end-of-line
}
zle -N sudo-command-line
bindkey "\e\e" sudo-command-line

#=> auto add sudo prefix
export SUDOCOMMANDS=(pfctl killall mount)
_accept_line_patch () {
  cmd=$(echo $BUFFER | awk '{print $1}')
  if [[ ${SUDOCOMMANDS[(i)$cmd]} -le ${#SUDOCOMMANDS} ]]; then
    BUFFER="sudo ${BUFFER}"
  fi
  zle .accept-line
}
zle -N accept-line _accept_line_patch

#=> fixed fasd bug
_fasd_preexec_fixed() {
  [[ -n $functions[fasd] ]] && unset -f fasd
}
add-zsh-hook preexec _fasd_preexec_fixed
#}}}

#=======================================================================================================================
#=> extends misc
#=======================================================================================================================
# {{{
#=> A command-line fuzzy finder written in Go: https://github.com/junegunn/fzf
export FZF_DEFAULT_OPTS="--prompt='> ' --reverse --color=hl:2,hl+:161 --height=60%"
export FZF_DEFAULT_COMMAND="ag --depth 26 -t -g '' 2>/dev/null"
[[ -f ~/.fzf.zsh ]] && source ~/.fzf.zsh
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"

#=> docs search via ag and fzf
alias zhelp="fzf-htmldocs-search ~/Data/docs-web/zsh_html $1"
alias mhelp="fzf-htmldocs-search ~/Data/docs-web/mysql_html $1"

#=> repalce man into vman
# man() { vman "$@" }

# Video translate into gif
video2gif() {
  ffmpeg -y -i "${1}" -vf fps=${3:-10},scale=${2:-320}:-1:flags=lanczos,palettegen "${1}.png"
  ffmpeg -i "${1}" -i "${1}.png" -filter_complex "fps=${3:-10},scale=${2:-320}:-1:flags=lanczos[x];[x][1:v]paletteuse" "${1}".gif
  rm "${1}.png"
}

# Image resize
imgresize() {
  local w=$1; h=$2; i=$3; o=$4
  if [ "$#" -eq 2 ]; then
    h=$w; i=$2; o=$i
  elif [ "$#" -eq 3 ]; then
    if [ -z "${2##[0-9]*}" ]; then
      o=$i
    else
      h=$w; i=$2; o=$3
    fi
  fi
  # ffmpeg -i $i -vf scale=$w:$h $o -y &>/dev/null
  convert -resize ${w}x${h}\! $i $o
}

# Mkdir and goto there
mkcd() {
  local MKPATH=$1
  mkdir -p $MKPATH
  cd $MKPATH
}

#=> add file to fasd
fasdadd() {
  time=$(date '+%s')
  file="$1"
  filefasd="${HOME}/.fasd"
  if [[ -f "$file" ]]; then
    grep -o "$file|" -q "$filefasd"
    if [[ $? > 0 ]]; then
      printf "%s|%s|%s" "$file" "1" "$time" >> "$filefasd"
    fi
  fi
}

#=> remove record from fasd log
fasdremove() {
  lineregx="$1"
  [[ -z "$1" ]] && lineregx=`pwd`| 
  lineregx=$(printf $lineregx | sed 's#/#\\/#g')
  filefasd=~/.fasd
  if [[ -f "$filefasd" ]]; then
    sed -i $(printf '/%s/d' $lineregx) "$filefasd"
    cd ~ # need this, otherwise a new item pwd will be added.
  fi
}

suniq() {
# Usage: suniq $PATH :
python - "$@" <<EOF
import sys
rpath = []
string = sys.argv[1]
sep = sys.argv[2]
apath = string.split(sep)
for path in apath:
  if path not in rpath:
    rpath.append(path)
print(sep.join(rpath))
EOF
}

falias() {
  zsh -ixc : 2>&1 | grep $1
}

# }}}

#=======================================================================================================================
#=> NOTICE: complete function must enabled bashcompinit
#=======================================================================================================================
# {{{
[[ -z $functions[complete] ]] && autoload -U +X bashcompinit && bashcompinit
#=> completion for command vsload and nvsload
_vsloadcompletelist() { ls ~/.vim/sessions | grep -v __LAST__ }
complete -F _vsloadcompletelist vsload
complete -F _vsloadcompletelist nvsload
#=> completion for command bulk
_bulkcompletelist() { bulk help edit | egrep -o '\-\-[a-z]+'; echo -e 'help\nedit' }
complete -F _bulkcompletelist bulk
#=> smartcd
_smartcdcompletelist() { smartcd -h | egrep -o '[a-z]+[||)]' | egrep -o '[a-z]+'; echo -e 'enter\nleave' }
complete -F _smartcdcompletelist smartcd
#=> npm
npmcmds=$(cat << EOF
access adduser bin bugs c cache completion config
ddp dedupe deprecate dist-tag docs edit explore get
help help-search i init install install-test it link
list ln login logout ls outdated owner pack ping
prefix prune publish rb rebuild repo restart root
run run-script s se search set shrinkwrap star
stars start stop t tag team test tst un uninstall
unpublish unstar up update v version view whoami
EOF
)
_npmcompletelist() { sed -r -e 's/\s+/\n/g' <<< $npmcmds }
complete -F _npmcompletelist npm
#=> dropbox
# _dropboxcompletelist() { dropbox help | grep -Z -P -o '^\s[\w]+' | tr " " "\n" }
# complete -F _dropboxcompletelist dropbox
# }}}

#=> testing
[[ -s "$HOME/.zshtest" ]] && source "$HOME/.zshtest"
