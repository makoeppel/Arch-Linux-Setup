#!/usr/bin/env bash

## Author : Aditya Shakya (adi1090x)
## Github : @adi1090x
#
## Rofi   : Launcher (Modi Drun, Run, File Browser, Window)
#
## Available Styles
#
## style-1     style-2     style-3     style-4     style-5
## style-6     style-7     style-8     style-9     style-10
## style-11    style-12    style-13    style-14    style-15

dir="$HOME/.config/rofi"
theme='style-8'

# user-local plugins (install.sh builds rofi-calc into ~/.local/lib/rofi on Fedora)
export ROFI_PLUGIN_PATH="$HOME/.local/lib/rofi${ROFI_PLUGIN_PATH:+:$ROFI_PLUGIN_PATH}"

# rofi aborts with "Mode calc is not found" if a listed mode is missing,
# so add the optional modes only when they are available
modi="drun,ssh,filebrowser"
if rofi -no-config -help 2>/dev/null | grep -qE '^[[:space:]]*• \+?calc$'; then
    modi="$modi,calc"
fi
web_search="$HOME/.config/rofi-web-search/rofi-web-search.py"
if [ -x "$web_search" ]; then
    modi="$modi,search:$web_search"
fi

## Run
rofi \
    -modi "$modi" \
    -show drun \
    -theme "${dir}/${theme}.rasi"
