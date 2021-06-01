#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
alias l='ls -la'
alias ducks='find * -type f -printf "%k KB \t%p\n" | sort -nr | head -10'
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

export QUARTUS_ROOTDIR="/home/makoeppel/altera/intelFPGA/18.0/quartus"

[ -d "$QUARTUS_ROOTDIR" ] || return

if [ "$(uname -m)" = "x86_64" ] ; then
    QUARTUS_64BIT='1'
else
    QUARTUS_64BIT='0'
fi
export QUARTUS_64BIT

export PATH="$PATH:$QUARTUS_ROOTDIR/bin"
export PATH="$PATH:$QUARTUS_ROOTDIR/sopc_builder/bin"

export SOPC_KIT_NIOS2="$QUARTUS_ROOTDIR/../nios2eds"
export PATH="$PATH:$SOPC_KIT_NIOS2/bin"
export PATH="$PATH:$SOPC_KIT_NIOS2/sdk2/bin"
export PATH="$PATH:$SOPC_KIT_NIOS2/bin/gnu/H-x86_64-pc-linux-gnu/bin"

export LC_CTYPE="de_DE.UTF-8"
export LC_ALL="de_DE.UTF-8"
