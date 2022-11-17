#!/bin/bash


# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
alias l='ls -la'
alias findbig='find . -xdev -type f -size +100M -print | xargs ls -lh | sort -k5,5 -h -r'
alias ducks='find * -type f -printf "%k KB \t%p\n" | sort -nr | head -10'
alias less='bat'
alias online='cd ~/mu3e/online/build'
alias ana='cd ~/mu3e/analyzer/build'
alias set_env='source ~/mu3e/online/build/set_env.sh'
alias midas='cd ~/mu3e/midas/build'
alias mu3e='cd ~/mu3e/mu3e'
alias clean='source ~/mu3e/online/online/clean.sh'
alias set_odb='source ~/mu3e/online/build/setup_odb.sh'
alias thisroot="source ~/compile_software/root/cmake-build/bin/thisroot.sh"
alias modelsim="/opt/intelFPGA/20.1/modelsim_ase/bin/vsim"

PS1='[\u@\h \W]\$ '

export QSYS_ROOTDIR="~/altera/intelFPGA/18.0/quartus"
export QUARTUS_ROOTDIR="~/altera/intelFPGA/18.0/quartus"
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
export PATH="$PATH:$QUARTUS_ROOTDIR/../hls/bin"

export LC_CTYPE="de_DE.UTF-8"
export LC_ALL="de_DE.UTF-8"

# Midas
export MIDASSYS="~/mu3e/midas"
export MIDAS_EXPTAB="~/mu3e/online/online/exptab"
export MIDAS_EXPT_NAME="Mu3e"
unset MIDAS_DIR

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
