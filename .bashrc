#!/bin/bash


# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
alias l='ls -la'
alias findbig='find . -xdev -type f -size +100M -print | xargs ls -lh | sort -k5,5 -h -r'
alias ducks='find * -type f -printf "%k KB \t%p\n" | sort -nr | head -10'

PS1='[\u@\h \W]\$ '

export QSYS_ROOTDIR="/home/makoeppel/altera/intelFPGA/18.0/quartus"
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

# geant4
for MY_GEANT4_SH in \
    "/usr/local/bin/geant4.sh" \
    "$HOME/.local/bin/geant4.sh" \
    "$HOME/.local/geant4.cern.ch/bin/geant4.sh" \
; do
    if [ -f "$MY_GEANT4_SH" ] && cd "$(dirname -- "$MY_GEANT4_SH")" ; then
        . "$(readlink -f -- "$MY_GEANT4_SH")"
        cd - > /dev/null
        break
    fi
done

unset -v MY_GEANT4_SH

# clion
export PATH="$PATH:/home/makoeppel/compiled_software/clion-2021.1.3/bin"
