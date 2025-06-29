#!/usr/bin/env bash

[[ $- != *i* ]] && return

set -o vi

unset HISTFILE

webscrape() {
	wget -m -k -E -l 7 -t 5 -w 1 -np "$1"
}

export LESSHISTFILE=""
export PAGER=less
export OPENER=xdg-open
export NNN_OPTS=aAeiQ
export VISUAL=nvim
export TERMINAL=footclient
export EDITOR=nvim
export MPD_HOST=~/.local/share/mpd/socket
export MANPAGER='nvim +Man!'

alias ls='ls --color=auto'
alias grep='grep --color=auto'
alias ..='cd ..'
alias tmp='cd $(mktemp -d -p ~/tmp/)'
rc="/usr/bin/git --git-dir='$HOME/.rc/' --work-tree='$HOME'"

alias gdscript="nvim --listen /tmp/nvim.sock"

alias rc="$rc"
alias rc-sync="$rc pull && $rc commit -am $(date +%y%m%d%H%M) && $rc push"

PATH=$HOME/usr/bin:$HOME/usr/lib:$HOME/go/bin:$PATH

BLACK0='\[\033[30m\]'
RED0='\[\033[31m\]'
GREEN0='\[\033[32m\]'
YELLOW0='\[\033[33m\]'
BLUE0='\[\033[34m\]'
MAGENTA0='\[\033[35m\]'
CYAN0='\[\033[36m\]'
WHITE0='\[\033[37m\]'
BLACK1='\[\033[90m\]'
RED1='\[\033[91m\]'
GREEN1='\[\033[92m\]'
YELLOW1='\[\033[93m\]'
BLUE1='\[\033[94m\]'
MAGENTA1='\[\033[95m\]'
CYAN1='\[\033[96m\]'
WHITE1='\[\033[97m\]'
RESET='\[\033[m\]'

PS1="${RED1}\w${RESET}${RED1}${RESET} ${YELLOW1}\$${RESET} "
