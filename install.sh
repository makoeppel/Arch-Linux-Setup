#!/usr/bin/env bash
#
# Bootstrap an i3 desktop and link the dotfiles of this repository.
# Supported: Arch Linux (and derivatives) and Fedora (and derivatives).
#
#   ./install.sh                 packages (core,desktop,fonts,shell) + dotfiles
#   ./install.sh --help          all options
#
set -Eeuo pipefail

DOTFILES=$(dirname -- "$(readlink -f -- "${BASH_SOURCE[0]}")")
readonly DOTFILES
BACKUP_DIR="$HOME/.dotfiles-backup/$(date +%Y%m%d-%H%M%S)"
OS_RELEASE=${OS_RELEASE:-/etc/os-release}

# ---------------------------------------------------------------- defaults ----
DO_PACKAGES=1
DO_DOTFILES=1
DO_OHMYZSH=0
DO_VIM=0
DO_CHSH=0
DO_XINITRC=0
DM=""
GROUPS_DEFAULT="core,desktop,fonts,shell"
GROUPS_SEL=""
ASSUME_YES=0
DRY_RUN=0
DISTRO=""

# Files/directories to link:  "<path in repo>:<path relative to $HOME>"
LINKS=(
    ".bashrc:.bashrc"
    ".zshrc:.zshrc"
    ".tmux.conf:.tmux.conf"
    ".Xresources:.Xresources"
    ".xsettingsd:.xsettingsd"
    ".wallpaper.png:.wallpaper.png"
    ".config/i3:.config/i3"
    ".config/i3status:.config/i3status"
    ".config/picom:.config/picom"
    ".config/dunst:.config/dunst"
    ".config/rofi:.config/rofi"
    ".config/rofi-web-search:.config/rofi-web-search"
    ".config/ranger:.config/ranger"
    ".config/conky:.config/conky"
    ".config/rofi/fonts:.local/share/fonts/dotfiles-rofi"
    ".fonts/icomoon:.local/share/fonts/dotfiles-icomoon"
)

# ------------------------------------------------------------------ output ----
if [ -t 1 ]; then C_B=$'\e[1m' C_G=$'\e[32m' C_Y=$'\e[33m' C_R=$'\e[31m' C_0=$'\e[0m'
else C_B="" C_G="" C_Y="" C_R="" C_0=""; fi
step() { printf '\n%s==> %s%s\n' "$C_B" "$*" "$C_0"; }
info() { printf '%s  ->%s %s\n' "$C_G" "$C_0" "$*"; }
warn() { printf '%s  !!%s %s\n' "$C_Y" "$C_0" "$*" >&2; }
die()  { printf '%sERROR:%s %s\n' "$C_R" "$C_0" "$*" >&2; exit 1; }
trap 'die "command failed (line $LINENO): $BASH_COMMAND"' ERR

# run a command, or only print it in --dry-run mode
run() {
    if (( DRY_RUN )); then printf '     [dry-run] %s\n' "$*"; else "$@"; fi
}

usage() {
    cat <<USAGE
Usage: $0 [options]

Steps (default: --packages --dotfiles):
  --no-packages        do not install system packages
  --no-dotfiles        do not link dotfiles
  --only-packages      same as --no-dotfiles
  --only-dotfiles      same as --no-packages
  --oh-my-zsh          clone oh-my-zsh to ~/.oh-my-zsh (loaded by .zshrc if present)
  --vim                install the amix/vimrc runtime (.vim_runtime submodule)
  --chsh               make zsh the login shell
  --xinitrc            write ~/.xinitrc ("exec i3") for starting i3 with startx
  --dm lightdm         install + enable LightDM (replaces the current display manager)

Package selection:
  -g, --groups LIST    comma-separated groups from packages.tsv
                       (default: $GROUPS_DEFAULT; others: apps, dev, dm)
  --add-groups LIST    install the default groups plus LIST (e.g. --add-groups apps,dev)

General:
  --distro arch|fedora override auto-detection from $OS_RELEASE
  -y, --yes            non-interactive; existing files are moved to a backup dir
  -n, --dry-run        print what would be done, change nothing
  -h, --help           show this help
USAGE
}

# ---------------------------------------------------------------- argparse ----
while (( $# )); do
    case "$1" in
        --no-packages|--only-dotfiles) DO_PACKAGES=0 ;;
        --no-dotfiles|--only-packages) DO_DOTFILES=0 ;;
        --oh-my-zsh)  DO_OHMYZSH=1 ;;
        --vim)        DO_VIM=1 ;;
        --chsh)       DO_CHSH=1 ;;
        --xinitrc)    DO_XINITRC=1 ;;
        --dm)         DM=${2:?--dm needs an argument}; shift ;;
        -g|--groups)  GROUPS_SEL=${2:?--groups needs an argument}; shift ;;
        --add-groups) GROUPS_SEL="$GROUPS_DEFAULT,${2:?--add-groups needs an argument}"; shift ;;
        --distro)     DISTRO=${2:?--distro needs an argument}; shift ;;
        -y|--yes)     ASSUME_YES=1 ;;
        -n|--dry-run) DRY_RUN=1 ;;
        -h|--help)    usage; exit 0 ;;
        *) usage >&2; die "unknown option '$1'" ;;
    esac
    shift
done
GROUPS_SEL=${GROUPS_SEL:-$GROUPS_DEFAULT}
if [ -n "$DM" ]; then GROUPS_SEL="$GROUPS_SEL,dm"; fi
[[ -z "$DM" || "$DM" == lightdm ]] || die "--dm: only 'lightdm' is supported"

(( EUID != 0 )) || die "run as your normal user (sudo is called where needed)"

# ----------------------------------------------------------- distro detect ----
detect_distro() {
    if [ -n "$DISTRO" ]; then return 0; fi
    [ -r "$OS_RELEASE" ] || die "cannot read $OS_RELEASE; use --distro"
    local ID="" ID_LIKE=""
    # shellcheck disable=SC1090
    . "$OS_RELEASE"
    case " $ID $ID_LIKE " in
        *" arch "*|*" archlinux "*)               DISTRO=arch ;;
        *" fedora "*|*" rhel "*|*" centos "*)    DISTRO=fedora ;;
        *) die "unsupported distribution '$ID' (ID_LIKE='$ID_LIKE'); use --distro" ;;
    esac
}

# ---------------------------------------------------------------- packages ----
# print the package names (column for $DISTRO) of the selected groups
manifest() {
    local col
    case "$DISTRO" in arch) col=2 ;; fedora) col=3 ;; esac
    awk -v col="$col" -v groups=",$GROUPS_SEL," '
        /^[[:space:]]*(#|$)/ { next }
        index(groups, "," $1 ",") && $col != "-" { print $col }
    ' "$DOTFILES/packages.tsv"
}

aur_helper() {
    local h
    for h in paru yay trizen; do
        if command -v "$h" >/dev/null; then echo "$h"; return 0; fi
    done
    return 1
}

install_packages() {
    step "Installing packages for $DISTRO (groups: $GROUPS_SEL)"
    local -a repo=() aur=() flat=() missing=()
    local p
    # shellcheck disable=SC2218  # false positive (shellcheck 0.11): manifest is defined above
    while read -r p; do
        case "$p" in
            aur:*)     aur+=("${p#aur:}") ;;
            flatpak:*) flat+=("${p#flatpak:}") ;;
            *)         repo+=("$p") ;;
        esac
    done < <(manifest)

    case "$DISTRO" in
    arch)
        local -a confirm=(); if (( ASSUME_YES )); then confirm=(--noconfirm); fi
        # never "pacman -Sy" alone (partial upgrade); sync + upgrade first
        run sudo pacman -Syu "${confirm[@]}"
        # drop names unknown to the sync databases instead of aborting the transaction
        local -a ok=()
        for p in "${repo[@]}"; do
            if pacman -Si -- "$p" >/dev/null 2>&1 || pacman -Sg -- "$p" >/dev/null 2>&1; then
                ok+=("$p")
            else
                missing+=("$p")
            fi
        done
        if (( ${#ok[@]} )); then run sudo pacman -S --needed "${confirm[@]}" "${ok[@]}"; fi
        if (( ${#aur[@]} )); then
            local h; h=$(aur_helper || true)
            if [ -n "$h" ]; then run "$h" -S --needed "${confirm[@]}" "${aur[@]}"
            else warn "no AUR helper (paru/yay/trizen) found, skipping: ${aur[*]}"; fi
        fi
        ;;
    fedora)
        local -a dnf_opts=()
        if (( ASSUME_YES )); then dnf_opts+=(-y); fi
        # dnf5 (Fedora >= 41) and dnf4 spell "ignore unknown package names" differently
        if dnf --version 2>/dev/null | grep -q '^dnf5'; then dnf_opts+=(--skip-unavailable)
        else dnf_opts+=(--setopt=strict=0); fi
        if (( ${#repo[@]} )); then run sudo dnf install "${dnf_opts[@]}" "${repo[@]}"; fi
        if (( ${#flat[@]} )); then
            if command -v flatpak >/dev/null; then
                run flatpak remote-add --user --if-not-exists flathub \
                    https://dl.flathub.org/repo/flathub.flatpakrepo
                run flatpak install --user --noninteractive flathub "${flat[@]}"
            else
                warn "flatpak not installed, skipping: ${flat[*]}"
            fi
        fi
        ;;
    esac
    (( ${#missing[@]} == 0 )) || warn "not found in the repositories, skipped: ${missing[*]}"
}

setup_dm() {
    if [ -z "$DM" ]; then return 0; fi
    step "Display manager: $DM"
    local conf=/etc/lightdm/lightdm.conf.d/50-dotfiles-greeter.conf
    run sudo mkdir -p /etc/lightdm/lightdm.conf.d
    if (( DRY_RUN )); then
        info "[dry-run] would write $conf (greeter-session=lightdm-gtk-greeter)"
    else
        printf '[Seat:*]\ngreeter-session=lightdm-gtk-greeter\n' | sudo tee "$conf" >/dev/null
    fi
    # --force replaces the existing display-manager.service alias (gdm, sddm, ...)
    run sudo systemctl enable --force lightdm.service
    info "LightDM takes over at the next boot. Pick the 'i3' session in the greeter."
}

# ---------------------------------------------------------------- dotfiles ----
# ask what to do with an existing path; prints one of: backup skip overwrite quit
ask_existing() {
    if (( ASSUME_YES )); then echo backup; return 0; fi
    local sel
    while true; do
        read -r -p "  '$1' exists. [b]ackup (default), [s]kip, [o]verwrite, [q]uit: " sel </dev/tty
        case "${sel:-b}" in
            b|B) echo backup;    return 0 ;;
            s|S) echo skip;      return 0 ;;
            o|O) echo overwrite; return 0 ;;
            q|Q) echo quit;      return 0 ;;
        esac
    done
}

# make sure $HOME/$1 can be created; returns 1 if the user chose to skip it
make_room() {
    local rel=$1 dst="$HOME/$1" action
    if [ ! -e "$dst" ] && [ ! -L "$dst" ]; then return 0; fi
    action=$(ask_existing "$dst")
    case "$action" in
        quit)      exit 1 ;;
        skip)      info "skipped ~/$rel"; return 1 ;;
        overwrite) run rm -rf -- "$dst" ;;
        backup)    run mkdir -p -- "$(dirname -- "$BACKUP_DIR/$rel")"
                   run mv -- "$dst" "$BACKUP_DIR/$rel"
                   info "backup  ~/$rel -> ${BACKUP_DIR/#$HOME/\~}/$rel" ;;
    esac
    return 0
}

link_one() {
    local src="$DOTFILES/$1" dst="$HOME/$2"
    if [ ! -e "$src" ]; then warn "missing in repo, skipped: $1"; return 0; fi
    if [ -L "$dst" ] && [ "$(readlink -f -- "$dst")" = "$(readlink -f -- "$src")" ]; then
        info "ok      ~/$2"
        return 0
    fi
    make_room "$2" || return 0
    run mkdir -p -- "$(dirname -- "$dst")"
    run ln -s -- "$src" "$dst"
    info "linked  ~/$2"
}

link_dotfiles() {
    step "Linking dotfiles from $DOTFILES"
    if [ -d "$DOTFILES/.git" ] || [ -f "$DOTFILES/.git" ]; then
        run git -C "$DOTFILES" submodule update --init --recursive \
            || warn "submodule update failed (offline?); continuing"
    fi
    local entry
    for entry in "${LINKS[@]}"; do link_one "${entry%%:*}" "${entry#*:}"; done

    run mkdir -p -- "$HOME/.local/bin" "$HOME/.local/share" "$HOME/Pictures/screenshots"
    if command -v xdg-user-dirs-update >/dev/null; then run xdg-user-dirs-update; fi
    if command -v fc-cache >/dev/null; then run fc-cache -f "$HOME/.local/share/fonts"; fi
}

install_ohmyzsh() {
    step "oh-my-zsh"
    local dir="${ZSH:-$HOME/.oh-my-zsh}"
    if [ -d "$dir/.git" ]; then run git -C "$dir" pull --ff-only
    else run git clone --depth 1 https://github.com/ohmyzsh/ohmyzsh.git "$dir"; fi
}

install_vim() {
    step "vim (amix/vimrc)"
    if [ ! -f "$DOTFILES/.vim_runtime/install_awesome_vimrc.sh" ]; then
        warn ".vim_runtime submodule is empty; run 'git submodule update --init'"
        return 0
    fi
    link_one ".vim_runtime" ".vim_runtime"
    make_room ".vimrc" || return 0
    # the amix installer writes ~/.vimrc, which sources ~/.vim_runtime
    (cd "$HOME" && run sh "$HOME/.vim_runtime/install_awesome_vimrc.sh")
}

set_login_shell() {
    # shellcheck disable=SC2218  # false positive (shellcheck 0.11): step is defined above
    step "Login shell"
    local zsh; zsh=$(command -v zsh) || { warn "zsh not installed"; return; }
    if [ "$(getent passwd "$USER" | cut -d: -f7)" = "$zsh" ]; then info "already $zsh"; return 0; fi
    run chsh -s "$zsh"
}

write_xinitrc() {
    step "$HOME/.xinitrc"
    if [ -e "$HOME/.xinitrc" ]; then warn "$HOME/.xinitrc exists, left unchanged"; return 0; fi
    if (( DRY_RUN )); then info "[dry-run] would write $HOME/.xinitrc"; return 0; fi
    printf '%s\n' '#!/bin/sh' '[ -f ~/.Xresources ] && xrdb -merge ~/.Xresources' 'exec i3' \
        > "$HOME/.xinitrc"
    info "start i3 from a text console with: startx"
}

# -------------------------------------------------------------------- main ----
detect_distro
dry_note=""; if (( DRY_RUN )); then dry_note="(dry run)"; fi
step "Distribution: $DISTRO   dotfiles: $DOTFILES   $dry_note"

if (( DO_PACKAGES )); then install_packages; fi
setup_dm
if (( DO_DOTFILES )); then link_dotfiles;    fi
if (( DO_OHMYZSH ));  then install_ohmyzsh;  fi
if (( DO_VIM ));      then install_vim;      fi
if (( DO_CHSH ));     then set_login_shell;  fi
if (( DO_XINITRC ));  then write_xinitrc;    fi

step "Done"
if [ "$DISTRO" = fedora ] && [ -z "$DM" ] && systemctl is-enabled gdm.service >/dev/null 2>&1; then
    warn "GDM is your login manager. Whether GDM can still start X11 sessions such as i3"
    warn "depends on the Fedora release. If 'i3' is missing at login, re-run with --dm lightdm"
    warn "or use --xinitrc and start i3 with 'startx' from a text console."
fi
info "Log out and choose the 'i3' session. Reload i3 in place with Super+Shift+r."
