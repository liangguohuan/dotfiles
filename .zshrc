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
zplug "liangguohuan/fzf-marker"
zplug "liangguohuan/zsh-dircolors-solarized"
# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

source $ZSH/oh-my-zsh.sh

#=======================================================================================================================
#=> extends
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

#=> A command-line fuzzy finder written in Go: https://github.com/junegunn/fzf
export FZF_DEFAULT_OPTS="--prompt='> ' --reverse --color=hl:2,hl+:161 --height=60%"
export FZF_DEFAULT_COMMAND="ag --depth 26 -t -g '' 2>/dev/null"
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
[[ -f ~/.fzf.zsh ]] && source ~/.fzf.zsh

# }}}

#=> testing
[[ -s "$HOME/.zshtest" ]] && source "$HOME/.zshtest"

