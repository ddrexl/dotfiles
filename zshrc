export LANG=en_US.UTF-8
export EDITOR='vim'

# aliases
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'
alias ......='cd ../../../../..'
alias 1='cd -'
alias 2='cd -2'
alias 3='cd -3'
alias 4='cd -4'
alias 5='cd -5'
alias 6='cd -6'
alias 7='cd -7'
alias 8='cd -8'
alias 9='cd -9'
alias grep='rg'
alias gr='rg'
alias l='ls -lah'
alias la='ls -lAh'
alias ll='ls -lh'
alias ls='ls --color=tty'
alias lsa='ls -lah'
alias md='mkdir -p'
alias t='tmux attach -t 0 || tmux new'
alias tt='tmux attach -t 0-1 || tmux new -t 0'
alias which-command=whence

# vi mode
bindkey -v
zle -N edit-command-line
autoload -Uz edit-command-line
bindkey -M vicmd 'V' edit-command-line
bindkey "^R" history-incremental-search-backward
bindkey "^N" history-beginning-search-forward
bindkey "^P" history-beginning-search-backward
bindkey "^[OA" history-beginning-search-backward
bindkey "^[OB" history-beginning-search-forward
bindkey "^[OC" vi-forward-char
bindkey "^[OD" vi-backward-char
bindkey "^[OF" vi-end-of-line
bindkey "^[OH" vi-beginning-of-line
bindkey "^[[200~" bracketed-paste
bindkey "^[[2~" overwrite-mode
bindkey "^[[3~" vi-delete-char
bindkey "" backward-delete-char


# completion
zstyle ':completion:*' menu select
fpath+=~/.zsh/completions
autoload -U compinit; compinit
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path ~/.zsh/cache

# prompt
fpath+=~/.zsh/pure
autoload -U promptinit; promptinit
zstyle :prompt:pure:user color 'green'
zstyle :prompt:pure:host color 'green'
zstyle :prompt:pure:user:root color 'red'
zstyle :prompt:pure:prompt:success color 'blue'
zstyle :prompt:pure:git:branch color '172' # orange
zstyle :prompt:pure:virtualenv color 'cyan'
prompt pure

# history
[ -z "$HISTFILE" ] && HISTFILE="$HOME/.zsh_history"
HISTSIZE=10000
SAVEHIST=10000
setopt extended_history       # record timestamp of command in HISTFILE
setopt hist_expire_dups_first # delete duplicates first when HISTFILE size exceeds HISTSIZE
setopt hist_ignore_dups       # ignore duplicated commands history list
setopt hist_ignore_space      # ignore commands that start with space
setopt hist_verify            # show command with history expansion to user before running it
setopt inc_append_history     # add commands to HISTFILE in order of execution
setopt share_history          # share command history data

# colors
eval `dircolors ~/.zsh/dircolors/dircolors.ansi-dark`

# direnv
eval "$(direnv hook zsh)"

# auto cd
setopt auto_cd

# caps as additional escape
# to work at startup, put it in ~/.profile
setxkbmap -option caps:escape

# source local zsh
[ -f ~/.zshrc.local ] && source ~/.zshrc.local

# disable scroll lock
stty -ixon

path+=~/.local/bin
export PATH

# vim:set et sw=4 ts=4 fdm=expr fde=getline(v\:lnum)=~'^#'?'>1'\:'=' fdl=0 :
