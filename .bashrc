#!/bin/bash

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
alias l='ls -la'
alias findbig='find . -xdev -type f -size +100M -print | xargs ls -lh | sort -k5,5 -h -r'
alias ducks='find * -type f -printf "%k KB \t%p\n" | sort -nr | head -10'
command -v bat >/dev/null 2>&1 && alias less='bat'
alias online='cd ~/mu3e/online/build'
alias ana='cd ~/mu3e/analyzer/build'
alias set_env='source ~/mu3e/online/build/set_env.sh'
alias midas='cd ~/mu3e/midas/build'
alias mu3e='cd ~/mu3e/mu3e'
alias clean='source ~/mu3e/online/online/clean.sh'
alias set_odb='source ~/mu3e/online/build/setup_odb.sh'
# NOTE: compiled_software/Makefile builds ROOT inside this repo, check this path
alias thisroot="source ~/compile_software/root/cmake-build/bin/thisroot.sh"
alias modelsim="/opt/intelFPGA/20.1/modelsim_ase/bin/vsim"

# Quartus / Nios II (only if installed; previously a missing Quartus made the
# whole rest of this file -- locale, MIDAS, Geant4 -- be skipped via `return`)
export QSYS_ROOTDIR="$HOME/altera/intelFPGA/18.0/quartus"
export QUARTUS_ROOTDIR="$HOME/altera/intelFPGA/18.0/quartus"
if [ -d "$QUARTUS_ROOTDIR" ] ; then
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
fi

# German locale (Fedora: needs glibc-langpack-de, installed by install.sh)
export LC_CTYPE="de_DE.UTF-8"
export LC_ALL="de_DE.UTF-8"

# Midas
export MIDASSYS="$HOME/mu3e/midas"
export MIDAS_EXPTAB="$HOME/mu3e/online/online/exptab"
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
export PATH="$PATH:$HOME/compiled_software/clion-2021.1.3/bin"

export PATH="$PATH:$HOME/.local/bin"
