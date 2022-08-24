## Linux dotfiles

```
cp .config/i3/config ~/.config/i3/
cp .config/i3status ~/.config/i3status/
cp -r .config/dunst ~/.config/
cp .config/compton.conf ~/.config/compton.conf
cp -r .config/ranger ~/.config/
cp -r .fonts ~/
cd fonts
git submodule init
cp -r .vim_runtime ~/.vim_runtime
cd ~ && sh ~/.vim_runtime/install_awesome_vimrc.sh && cd -
mkdir ../screenshots/
./install.sh
```
Copy all into ~/.

## i3
modified from [i3-starterpack](https://github.com/addy-dclxvi/i3-starterpack.git)
```
sudo pacman -S i3 i3-wm dunst i3lock i3status 
sudo pacman -S compton hsetroot rxvt-unicode xsel rofi xsettingsd lxappearance scrot viewnior
trizen fonts-noto
trizen fonts-mplus
sudo pacman -S py3status
sudo pacman -S conky
sudo pacman -S bat
```

## terminal
```
sudo pacman -S zsh zsh-completions
```

# Vim
Vim setup taken from [vimrc](https://github.com/amix/vimrc)

## ranger
```
sudo pacman -S ranger w3m
```

## restic
Restic setup is taken from [restic-cron](https://github.com/marconett/restic-cron)

## Pacman Updates
sudo pacman -S archlinux-keyring && sudo pacman -Syu

## TODO
- setup .git stuff
- auto setup i3 / i3status
- handle gitmoduls in opt
