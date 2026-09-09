# Install yay-git
```bash
git clone https://aur.archlinux.org/yay-git.git
cd yay
makepkg -si

sudo pacman -S --needed base-devel git
```

# Install Google chrome????

# Install LockScreen to Gnome
```bash
sudo pacman -S gdm
sudo systemctl enable gdm.service
sudo systemctl status  gdm.service
```

# Install Unikey
```bash
paru -S ibus-bamboo
ibus-daemon -drx
```

Edit file `\etc\environment`: change variables to ibus.

# Stow 

```bash
yay -S stow
```


