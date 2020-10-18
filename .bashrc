#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
alias l='ls -la'
PS1='[\u@\h \W]\$ '

HISTFILE=~/.histfile
HISTSIZE=100000
SAVEHIST=1000000
bindkey -e
zstyle :compinstall filename '/home/makoeppel/.zshrc'

autoload -Uz compinit
compinit

# plugins
source ~/.arch_setup/.git.plugin.zsh
source ~/.arch_setup/cool-simple-zsh-theme/cool-simple-zsh-theme.zsh-theme
