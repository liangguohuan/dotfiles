# vim: fdm=marker ts=2 sw=2 sts=2 expandtab
#=======================================================================================================================
#=> function helper
#=======================================================================================================================
# => extend oh-my-zsh plugins from github repos
zplug () {
  local repo="$1"
  local name=$(basename "$repo")
  local uri="https://github.com/$1"
  local dir=$(printf "%s/custom/plugins/%s" "$ZSH" "$name")
  [[ ! -e "$dir" ]] && {
    git clone --recursive --depth 1 "$uri" "$dir"
    [[ ! -e "$dir/$name.plugin.zsh" ]] && find "$dir" -maxdepth 1 -name "*.plugin.zsh" | xargs -i ln -rs {} "$dir/$name.plugin.zsh"  
  }
  [[ -n "$2" ]] && [[ -s "$dir/$2" ]] && [[ ! -e "$dir/$name.plugin.zsh" ]] && ln -rsf "$dir/$2" "$dir/$name.plugin.zsh"
  plugins+=("$name")
}

#=======================================================================================================================
#=> oh-my-zsh: https://github.com/robbyrussell/oh-my-zsh
#=======================================================================================================================
# Path to your oh-my-zsh installation.
export ZSH=~/.oh-my-zsh
[[ ! -e "$ZSH" ]] && git clone --depth 1 https://github.com/robbyrussell/oh-my-zsh "$ZSH"

# Set name of the theme to load.
MYZSHTHEME="$ZSH/themes/pretty.zsh-theme"
[[ ! -e "$MYZSHTHEME"  ]] && wget https://github.com/liangguohuan/dotfiles/raw/master/pretty.zsh-theme -O "$MYZSHTHEME" 
ZSH_THEME="pretty"

# Add wisely, as too many plugins slow down shell startup.
# dont use plugin fasd, it will caused 'permission denied: ../..' when alias using function is been executed.
plugins=(zsh_reload fasd git git-extras laravel5 docker docker-compose tmux tmuxinator go gem yarn pip python)
# plugin extends
zplug "zsh-users/zsh-syntax-highlighting"
zplug "Tarrasch/zsh-bd"
zplug "Tarrasch/zsh-autoenv"
zplug "liangguohuan/fzf-extends"
zplug "liangguohuan/fzf-marker"
zplug "liangguohuan/zsh-dircolors-solarized"

# enabled oh-my-zsh
source $ZSH/oh-my-zsh.sh

#=======================================================================================================================
#=> extends base
#=======================================================================================================================
# {{{
#=> alias
source ~/.bash_aliases

#=> zsh-mime-setup
alias -s php=gvim
alias -s deb=gdebi
alias -s png=sxiv
alias -s jpg=sxiv
alias -s jpeg=sxiv
alias -s avi=mpv
alias -s mp4=mpv
alias -s mkv=mpv

#=> zsh keymap
bindkey \^U backward-kill-line

#=> misc setting
compdef vboxmanage=VBoxManage

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
hash -d document=~/Document
hash -d music=~/Music
hash -d download=~/Download
hash -d video=~/Videos
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
#}}}

#=======================================================================================================================
#=> extends misc
#=======================================================================================================================
# {{{
#=> A command-line fuzzy finder written in Go: https://github.com/junegunn/fzf
export FZF_DEFAULT_OPTS="--prompt='> ' --reverse --color=hl:2,hl+:161 --height=60%"
export FZF_DEFAULT_COMMAND="ag --depth 26 -t -g '' 2>/dev/null"
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
[[ -f ~/.fzf.zsh ]] && source ~/.fzf.zsh

#=> docs search via ag and fzf
alias zhelp="fzf-htmldocs-search ~/Data/docs-web/zsh_html $1"
alias mhelp="fzf-htmldocs-search ~/Data/docs-web/mysql_html $1"

#=> repalce man into vman
man() { vman "$@" }

#=> fixed fasd bug
_fasd_preexec_fixed() {
  [[ -n $functions[fasd] ]] && unset -f fasd
}
add-zsh-hook preexec _fasd_preexec_fixed

# Video translate into gif
video2gif() {
  ffmpeg -y -i "${1}" -vf fps=${3:-10},scale=${2:-320}:-1:flags=lanczos,palettegen "${1}.png"
  ffmpeg -i "${1}" -i "${1}.png" -filter_complex "fps=${3:-10},scale=${2:-320}:-1:flags=lanczos[x];[x][1:v]paletteuse" "${1}".gif
  rm "${1}.png"
}
# }}}

#=======================================================================================================================
#=> NOTICE: complete function must enabled bashcompinit
#=======================================================================================================================
# {{{
[[ -z $functions[complete] ]] && autoload -U +X bashcompinit && bashcompinit
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

