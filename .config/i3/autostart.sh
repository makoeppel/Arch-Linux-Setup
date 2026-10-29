#!/usr/bin/env bash
# Started once per login by i3 (see ~/.config/i3/config).
# Each entry is "<workspace> <command...>"; entries whose program is not installed
# are skipped, so the same list works on Arch, Fedora and the office machine.
# Flatpak apps are written as "flatpak:<app-id>".

APPS=(
    "1 firefox"
    "1 gnome-terminal"
    "2 thunderbird"
    "2 keepassxc"
    "2 keepass"
    "2 signal-desktop"
    "2 flatpak:org.signal.Signal"
    "2 mattermost-desktop"
    "2 flatpak:com.mattermost.Desktop"
    "2 discord"
    "2 flatpak:com.discordapp.Discord"
    "2 whatsapp-for-linux"
    "2 ktimetracker"
)
# started last, after a delay (as before)
DELAYED=(
    "qbittorrent"
)

launch() {   # launch <workspace> <cmd...>
    local ws=$1; shift
    local cmd=$1
    if [[ $cmd == flatpak:* ]]; then
        local id=${cmd#flatpak:}
        flatpak info "$id" >/dev/null 2>&1 || return 0
        set -- flatpak run "$id"
    else
        command -v "$cmd" >/dev/null 2>&1 || return 0
    fi
    i3-msg -q "workspace $ws; exec --no-startup-id $*"
    sleep 0.3
}

for entry in "${APPS[@]}"; do
    # shellcheck disable=SC2086  # split "<ws> <cmd...>" on purpose
    launch $entry
done
i3-msg -q "workspace 1"

sleep 10
for cmd in "${DELAYED[@]}"; do
    command -v "$cmd" >/dev/null 2>&1 && "$cmd" >/dev/null 2>&1 &
done
wait
