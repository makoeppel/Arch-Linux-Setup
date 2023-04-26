## Linux dotfiles

```
cp .config/i3/config ~/.config/i3/
cp .config/i3status ~/.config/i3status/
cp -r .config/dunst ~/.config/
cp .config/compton.conf ~/.config/compton.conf
cp -r .config/ranger ~/.config/
cp -r .config/conky ~/.config/
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
gnome-terminal has the run a custom command instead of my shell field in the profile editor
```
sudo pacman -S zsh zsh-completions
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
cat .zshrc >> ~/.zshrc
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

## Kernel lost
- use USB with Arch live
- mount root partition
- arch-chroot on the partition
- pacman -S linux-lts
- reboot

## conky
- setup for i3 https://faq.i3wm.org/question/3829/conky-on-desktop.1.html
- edit the config file and add: own_window yes own_window_class Conky own_window_type override
- example: conky -c "~/.config/conky/Gotham/Gotham" &
- trizen conky-cairo (for using lua cairo)
- change lua_load = 'settings.lua' in start_conky_General_VERTICAL_circle to use local one
- cp Conky-themes/Conky-Revisited-2/Conky_Revisited_2/Conky_Circle_Vertical/settings.lua ~/.config/conky/
- cp Conky-themes/Conky-Revisited-2/Conky_Revisited_2/Conky_Circle_Vertical/start_conky_General_VERTICAL_circle ~/.config/conky/

## TODO
- setup .git stuff
- auto setup i3 / i3status
- handle gitmoduls in opt
