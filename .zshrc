# zcomdump filepath
# ZSH_COMPDUMP="/tmp/.zcompdump-${HOST}-${ZSH_VERSION}"

# addtional zsh-completions
# fpath=(/usr/local/share/zsh/zsh-completions/src $fpath)

# Path to your oh-my-zsh installation.
export ZSH=$HOME/.oh-my-zsh

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
# Optionally, if you set this to "random", it'll load a random theme each
# time that oh-my-zsh is loaded.
# ZSH_THEME="robbyrussell"
ZSH_THEME="pretty"

# Uncomment the following line to use case-sensitive completion.# {{{
# CASE_SENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# The optional three formats: "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
#
# Add wisely, as too many plugins slow down shell startup.
# plugins=(git composer docker gem laravel laravel4 mvn node npm nvm perl pip pyenv python rbenv rsync rvm sublime sudo tmux vagrant)# }}}
plugins=(zsh_reload git laravel5 docker docker-compose gem tmuxinator npm pip python tmux zsh-syntax-highlighting autojump)
# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

source $ZSH/oh-my-zsh.sh
source ~/.bash_aliases

# You may need to manually set your language environment# {{{
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# ssh
# export SSH_KEY_PATH="~/.ssh/dsa_id"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"# }}}

########################################################################################################################
# => zsh keymap
########################################################################################################################
# {{{
# [esc+l] to chdir to the parent directory
# bindkey -s '\el' " 2>&1|less^M"
# [alt+u] pipe the current command through less
# bindkey -s '\eu' '^qcd ..; ls^M'
# [esc+enter] menu selection: pick item but stay in the menu
bindkey -M menuselect '\e^M' accept-and-menu-complete 
bindkey \^U backward-kill-line

#=== vim mode =====================================================
# function zle-line-init zle-keymap-select {
    # RPS1="${${KEYMAP/vicmd/-- NORMAL --}/(main|viins)/-- INSERT --}"
    # RPS2=$RPS1
    # zle reset-prompt
# }
# zle -N zle-line-init
# zle -N zle-keymap-select
# # Incremental search is elite!
# bindkey -M vicmd "/" history-incremental-search-backward
# bindkey -M vicmd "?" history-incremental-search-forward

# # Search based on what you typed in already
# bindkey -M vicmd "//" history-beginning-search-backward
# bindkey -M vicmd "??" history-beginning-search-forward

#=== vim mode end  =====================================================
# }}}

########################################################################################################################
# => misc setting
########################################################################################################################
# {{{
# let vboxmanage equal VBoxManage
compdef vboxmanage=VBoxManage

zstyle ':completion:*:ping:*' hosts 163.com twitter.com facebook.com
my_accounts=(
{hanson,osily,john,root}@{192.168.1.1,192.168.0.1,202.96.128.100}
osily@localhost
)
zstyle ':completion:*:my-accounts' users-hosts $my_accounts

# tmux layout autostart except 'guake terminal'
# [[ -z $GIO_LAUNCHED_DESKTOP_FILE ]] && \
# /usr/local/bin/layout-tmux &>/dev/null

# try to disable zsh output someting bad when cmd finish.
DISABLE_AUTO_TITLE="true"

# dir hash
hash -d document=~/Document
hash -d music=~/Music
hash -d download=~/Download
hash -d video=~/Videos
hash -d picture=~/Pictures
# }}}

########################################################################################################################
# => zsh alias
########################################################################################################################
# {{{
# [Esc][h] man
alias run-help >&/dev/null && unalias run-help
autoload run-help

# zsh alias setting
alias '..'='cd ..'
alias -g ...='../..'
alias -g ....='../../..'
alias -g .....='../../../..'
alias -g PR=http_proxy=127.0.0.1:8087

# autoload -U zsh-mime-setup
# zsh-mime-setup
alias -s php=gvim
alias -s deb=gdebi
alias -s png=sxiv
alias -s jpg=sxiv
alias -s jpeg=sxiv
alias -s avi=mpv
alias -s mp4=mpv
alias -s mkv=mpv
# }}}

########################################################################################################################
# => zsh extend plugins
########################################################################################################################
## sudo prefix
# {{{
sudo-command-line() {
[[ -z $BUFFER ]] && zle up-history
[[ $BUFFER != sudo\ * ]] && BUFFER="sudo $BUFFER"
zle end-of-line
}
zle -N sudo-command-line
bindkey "\e\e" sudo-command-line
# }}}

# A command-line fuzzy finder written in Go: https://github.com/junegunn/fzf
export FZF_DEFAULT_COMMAND="ag --depth 26 -t -g '' 2>/dev/null"
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_CTRL_T_OPTS="--color=hl:2,hl+:161"
export FZF_CTRL_R_OPTS="--reverse --color=hl:2,hl+:161"
export FZF_ALT_C_OPTS="--color=hl:2,hl+:161"
[[ -f ~/.fzf.zsh ]] && source ~/.fzf.zsh

# marker: https://github.com/pindexis/marker.git
# template file: ~/.local/share/marker/user_commands.txt
export MARKER_KEY_NEXT_PLACEHOLDER='\C-v'
[[ -s "$HOME/.local/share/marker/marker.sh" ]] && source "$HOME/.local/share/marker/marker.sh"

# percol: https://github.com/mooz/percol
# search shell history easier
# {{{
# function exists { which $1 &> /dev/null }
# if exists percol; then
    # function percol_select_history() {
        # local tac
        # exists gtac && tac="gtac" || { exists tac && tac="tac" || { tac="tail -r" } }
        # BUFFER=$(fc -l -n 1 | eval $tac | percol --query "$LBUFFER")
        # CURSOR=$#BUFFER         # move cursor
        # zle -R -c               # refresh
    # }

    # zle -N percol_select_history
    # bindkey '^R' percol_select_history
# fi
# }}}

# smartcd: https://github.com/cxreg/smartcd
[ -r "$HOME/.smartcd_config" ] && ( [ -n $BASH_VERSION ] || [ -n $ZSH_VERSION ] ) && source ~/.smartcd_config

# dconf overwrite for switcher keys
if [ ! -f "/tmp/yet_switcher_keys_overwirte" ]; then
    xmodmap-toggle dconf default
    xmodmap-toggle dconf swap
    touch /tmp/yet_switcher_keys_overwirte
fi


# vim: fdm=marker ts=4 sw=4 sts=4 expandtab
