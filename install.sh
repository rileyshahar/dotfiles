#!/usr/bin/env bash

## check EFI
# ls /sys/firmware/efi/efivars
#
## check internet
# ping example.org
#
# fdisk -l
# read -p "Choose the appropriate disk: " disk
#
# echo "partitioning disk"
## to create the partitions programatically (rather than manually)
## we're going to simulate the manual input to fdisk
## The sed script strips off all the comments so that we can
## document what we're doing in-line with the actual commands
## Note that a blank line (commented as "defualt" will send a empty
## line terminated with a newline to take the fdisk default.
# sed -e 's/\s*\([\+0-9a-zA-Z]*\).*/\1/' << EOF | fdisk $disk
#   g # gpt partition table
#   n # new partition
#   1 # partition number 1
#     # default - start at beginning of disk
#   +550M # 550M EFI partition
#   n # new partition
#   2 # partion number 2
#     # default, start immediately after preceding partition
#   +2G # 2G of swap
#   n # new partition
#   3 # partion number 2
#     # default, start immediately after preceding partition
#     # default, extend partition to end of disk
#   t # change partition type
#   1 # change for partition 1
#   1 # change to EFI type
#   t # change partition type
#   2 # change for partition 2
#   19 # linux swap type
#   t # change partition type
#   3 # change for partition 3
#   20 # linux filesystem type
#   w # write the partition table
#   q # quit fdisk
# EOF
#
# echo "formatting partitions"
# mkfs.fat -F32 ${disk}1
# mkswap ${disk}2
# mkfs.ext4 ${disk}3
#
# echo "mounting root"
# mount ${disk}3 /mnt
#
# echo "activating swap"
# swapon ${disk}2
#
# echo "installing system packages"
# pacstrap /mnt base linux linux-firmware
#
# echo "generating fstab file"
# genfstab -U /mnt >> /mnt/etc/fstab
#
# echo "changing root"
# arch-chroot /mnt

set -euo pipefail

echo "setting root password"
passwd

echo "adding new user"
read -p "Enter new username: " username
useradd -m "$username"
passwd "$username"
usermod -aG wheel "$username"

echo "synchronizing pacman databases"
pacman -Sy

echo "configuring sudo"
pacman -S sudo --noconfirm --needed > /dev/null
sed -i '/%wheel ALL=(ALL) ALL/s/^# //' /etc/sudoers

echo "updating the system time"
timedatectl set-ntp true

echo "setting the timezone"
ln -sf /usr/share/zoneinfo/America/Los_Angeles /etc/localtime > /dev/null
hwclock --systohc

echo "configuring localization"
sed -i '/en_US\.UTF-8 UTF-8/s/^#//' /etc/locale.gen
locale-gen > /dev/null
echo "LANG=en_US.UTF-8" >> /etc/locale.conf

echo "configuring hostname"
read -p "Enter your desired hostname: " hostname
echo "$hostname" >> /etc/hostname
echo "127.0.0.1\tlocalhost
::1\t\tlocalhost
127.0.1.1\t$hostname.localdomain\t$hostname" >> /etc/hosts

# if nvidia: add `ibt=off` to grub kernel comandline

echo "setting up grub"
fdisk -l
read -p "Choose the EFI partition: " efi
pacman -S grub efibootmgr --noconfirm --needed > /dev/null
mkdir /boot/EFI
mount "$efi" /boot/EFI > /dev/null
grub-install --target=x86_64-efi --efi-directory=/boot/EFI --bootloader-id=GRUB > /dev/null
grub-mkconfig -o /boot/grub/grub.cfg > /dev/null

su "$username" <<'EOSU'
cd

echo "installing packages: git, base-devel"
sudo pacman -S git base-devel --noconfirm --needed > /dev/null

echo "installing rust"
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh

echo "installing paru"
git clone https://aur.archlinux.org/paru.git > /dev/null
cd paru
makepkg -si --noconfirm --needed > /dev/null
cd ..
rm -rf paru

echo "downloading dotfiles"
git clone --recursive https://github.com/rileyshahar/dotfiles > /dev/null

echo "installing packages; this make take a while."
echo "installing aur packages"
paru -S --noconfirm --needed - <$HOME/dotfiles/packages/paclist > /dev/null

echo "installing pip and pip packages"
curl --proto '=https' --tlsv1.2 -sSf https://bootstrap.pypa.io/get-pip.py | python
pip install $(cat $HOME/dotfiles/packages/piplist) -U > /dev/null

echo "installing rustup, rust, and cargo packages"
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- --no-modify-path -y --quiet > /dev/null
cargo install $(cat $HOME/dotfiles/packages/cargolist) > /dev/null

echo "symlinking configs"
DOTFILES_DIR="$HOME/dotfiles"
CONFIG_HOME="$HOME/.config"
DATA_HOME="$HOME/.local/share"

mkdir $CONFIG_HOME

mkdir -p /var/spool/cron
sudo ln -sv "$DOTFILES_DIR/cron/crontab" "/var/spool/cron/$(whoami)"

ln -sv "$DOTFILES_DIR/anacron" "$CONFIG_HOME"
ln -sv "$DOTFILES_DIR/cookiecutter" "$CONFIG_HOME"
ln -sv "$DOTFILES_DIR/dunst" "$CONFIG_HOME"
ln -sv "$DOTFILES_DIR/emacs" "$CONFIG_HOME"
ln -sv "$DOTFILES_DIR/fish" "$CONFIG_HOME"
ln -sv "$DOTFILES_DIR/fontconfig" "$CONFIG_HOME"
ln -sv "$DOTFILES_DIR/foot" "$CONFIG_HOME"
ln -sv "$DOTFILES_DIR/fusuma" "$CONFIG_HOME"
ln -sv "$DOTFILES_DIR/gammastep" "$CONFIG_HOME"
ln -sv "$DOTFILES_DIR/git" "$CONFIG_HOME"
ln -sv "$DOTFILES_DIR/kanshi" "$CONFIG_HOME"
ln -sv "$DOTFILES_DIR/keyd" "/etc"
ln -sv "$DOTFILES_DIR/keynav" "$CONFIG_HOME"
ln -sv "$DOTFILES_DIR/kitty" "$CONFIG_HOME"
ln -sv "$DOTFILES_DIR/mpv" "$CONFIG_HOME"
ln -sv "$DOTFILES_DIR/nvim" "$CONFIG_HOME"
ln -sv "$DOTFILES_DIR/pandoc" "$CONFIG_HOME"
ln -sv "$DOTFILES_DIR/proselint" "$CONFIG_HOME"
ln -sv "$DOTFILES_DIR/qtile" "$CONFIG_HOME"
ln -sv "$DOTFILES_DIR/rofi" "$CONFIG_HOME"
ln -sv "$DOTFILES_DIR/ssh" "$CONFIG_HOME"
ln -sv "$DOTFILES_DIR/systemd" "$CONFIG_HOME"
ln -sv "$DOTFILES_DIR/tarsnap" "$CONFIG_HOME"
ln -sv "$DOTFILES_DIR/task" "$CONFIG_HOME"
ln -sv "$DOTFILES_DIR/tridactyl" "$CONFIG_HOME"
ln -sv "$DOTFILES_DIR/wallpaper.jpg" "$CONFIG_HOME"
ln -sv "$DOTFILES_DIR/11 $CONFIG_HOME"
ln -sv "$DOTFILES_DIR/xdg/mimeapps.list" "$CONFIG_HOME"
ln -sv "$DOTFILES_DIR/xournalpp" "$CONFIG_HOME"
ln -sv "$DOTFILES_DIR/zathura" "$CONFIG_HOME"

echo "enabling networkmanager"
sudo systemctl enable NetworkManager > /dev/null

echo "installing neovim plugins"
git clone --depth=1 https://github.com/savq/paq-nvim.git "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/pack/paqs/start/paq-nvim > /dev/null
nvim --headless +PaqInstall +q > /dev/null

echo "making user bin files executable"
chmod +x $DOTFILES_DIR/bin/*

echo "installing fish plugins"
fish <<EOFS
curl -sL https://git.io/fisher | source && fisher update
EOFS

echo "changing fish to default shell"
sudo chsh -s $(which fish) $(whoami) > /dev/null

echo "setting colorscheme to tokyonight"
$DOTFILES_DIR/bin/cac tokyonight --no-reload > /dev/null

echo "setting up keyd"
sudo usermod -aG input $USER
sudo groupadd uinput
sudo usermod -aG uinput $USER
sudo systemctl enable --now keyd

sudo modprobe uninput
sudo 'echo uinput >> /etc/modules-load.d/uinput.conf'
sudo ln -sv "$DOTFILES_DIR/kmonad" "/etc/kmonad/config.kbd"
sudo systemctl enable kmonad@config

echo "TODO: change the device-file in kmonad config"
echo "TODO: change the brightness file and wlan interfact in qtile"
echo "TODO: run :nativemessenger for tridactly in firefox"

# EOSU
