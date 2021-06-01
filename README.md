## Linux dotfiles

```
cp .config/i3/config ~/.config/i3/
cp .config/i3status/config ~/.config/i3status/
cp -r .config/dunstrc ~/.config/
cp .config/compton.conf ~/.config/compton.conf
cp -r .config/ranger ~/.config/
cp -r .fonts ~/
cd fonts
./install.sh
```
Compy all into ./config

## i3
modified from [i3-starterpack](https://github.com/addy-dclxvi/i3-starterpack.git)
```
sudo pacman -S i3 i3-wm dunst i3lock i3status 
sudo pacman -S compton hsetroot rxvt-unicode xsel rofi xsettingsd lxappearance scrot viewnior
trizen fonts-noto
trizen fonts-mplus
```

## terminal
```
sudo pacman -S zsh zsh-completions
```

## ranger
```
sudo pacman -S ranger w3m
```
