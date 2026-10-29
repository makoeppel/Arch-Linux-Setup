## Linux dotfiles: i3 on Arch Linux and Fedora

One script installs the packages and links the configs on **Arch Linux** (and
derivatives such as EndeavourOS/Manjaro) and on **Fedora** (Workstation, the i3
Spin, or a minimal install). The distribution is detected from `/etc/os-release`.

```sh
git clone --recursive https://github.com/makoeppel/Arch-Linux-Setup.git ~/.dotfiles
cd ~/.dotfiles
./install.sh --dry-run          # show what would happen
./install.sh                    # packages (core,desktop,fonts,shell) + dotfiles
```

Then log out and select the **i3** session at the login screen.

### Options

| option | effect |
|---|---|
| `--add-groups apps,dev` | also install the GUI apps started by `autostart.sh` / build tools |
| `-g core,desktop` | install only these package groups |
| `--only-dotfiles` / `--only-packages` | run a single step |
| `--oh-my-zsh` | clone oh-my-zsh (loaded by `.zshrc` if present) |
| `--vim` | install the amix/vimrc runtime from the `.vim_runtime` submodule |
| `--chsh` | make zsh the login shell |
| `--dm lightdm` | install and enable LightDM (replaces GDM/SDDM) |
| `--xinitrc` | write `~/.xinitrc` so i3 can be started with `startx` |
| `-y` | non-interactive; existing files are moved to `~/.dotfiles-backup/<date>/` |

Existing files are never deleted silently: for each one you choose backup
(default), skip, or overwrite.

### Packages

All package names live in [`packages.tsv`](packages.tsv), one row per program with
an Arch and a Fedora column (`-` = not needed, `aur:` = AUR, `flatpak:` = Flathub).
Names that the package manager does not know are skipped with a warning instead
of aborting the run.

### Fedora notes

* i3 is an X11 window manager. Fedora's GNOME login screen (GDM) has repeatedly
  changed whether it can start X11 sessions. If **i3** does not appear in the
  session menu, run `./install.sh --dm lightdm` (LightDM is what the Fedora i3 Spin
  uses), or `./install.sh --xinitrc` and start i3 with `startx` from a text console.
* Signal, Discord and Mattermost are not in the Fedora repositories and are
  installed from Flathub when you use `--add-groups apps`.
* `.bashrc` sets `LC_ALL=de_DE.UTF-8`; on Fedora this needs `glibc-langpack-de`
  (part of the `shell` group).

### What gets linked

`~/.bashrc ~/.zshrc ~/.tmux.conf ~/.Xresources ~/.xsettingsd ~/.wallpaper.png`
and `~/.config/{i3,i3status,picom,dunst,rofi,rofi-web-search,ranger,conky}`.
The bundled rofi/icomoon fonts are linked into `~/.local/share/fonts/`.

### Key bindings (Super = Windows key)

| keys | action |
|---|---|
| `Super+Return` | terminal (gnome-terminal) |
| `Super+d` / `Super+Shift+d` | rofi launcher / dmenu |
| `Super+q` | power menu (lock, suspend, logout, reboot, shutdown) |
| `Super+l` | lock screen |
| `Print` / `Shift+Print` | screenshot / area to clipboard (`~/Pictures/screenshots`) |
| `Super+c` | close window |
| `Super+Shift+c` / `Super+Shift+r` | reload / restart i3 |
| `Super+z` / `Super+x` | keyboard layout de / us |

Programs started at login are listed in `~/.config/i3/autostart.sh`; entries that
are not installed are skipped.

## Credits

* i3: modified from [i3-starterpack](https://github.com/addy-dclxvi/i3-starterpack)
* rofi: styles from [adi1090x/rofi](https://github.com/adi1090x/rofi)
* vim: [amix/vimrc](https://github.com/amix/vimrc)
* tmux: [gpakosz/.tmux](https://github.com/gpakosz/.tmux)
* restic: [restic-cron](https://github.com/marconett/restic-cron), see `restic/README.md`

## Notes

### Arch: updates
`sudo pacman -S archlinux-keyring && sudo pacman -Syu`

### Arch: kernel lost
Boot an Arch live USB, mount the root partition, `arch-chroot` into it,
`pacman -S linux-lts`, reboot.

### conky
* i3 setup: https://faq.i3wm.org/question/3829/conky-on-desktop.1.html
* add `own_window yes`, `own_window_class Conky`, `own_window_type override`
* example: `conky -c ~/.config/conky/Gotham/Gotham &`
* Lua/cairo themes from the `Conky-themes` submodule: copy
  `Conky-themes/Conky-Revisited-2/Conky_Revisited_2/Conky_Circle_Vertical/{settings.lua,start_conky_General_VERTICAL_circle}`
  to `~/.config/conky/` and set `lua_load = 'settings.lua'`

### Pinebook Pro
Tap-to-click: `exec xinput set-prop "Pine64 Pinebook Pro Touchpad" "Synaptics Tap Action" 1, 1, 1, 1, 1, 1, 1`
