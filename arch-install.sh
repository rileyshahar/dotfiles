#!/usr/bin/env sh

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
#     # default, extend partition to end of disk
#   t # change partition type
#   1 # change for partition 1
#   1 # change to EFI type
#   t # change partition type
#   2 # change for partition 2
#   20 # linux filesystem type
#   w # write the partition table
#   q # quit fdisk
# EOF
#
# echo "formatting partitions"
# mkfs.fat -F32 ${disk}1
# mkfs.ext4 ${disk}2
#
# echo "mounting root"
# mount ${disk}2 /mnt
#
# echo "installing system packages"
# pacstrap /mnt base linux linux-firmware
#
# echo "generating fstab file"
# genfstab -U /mnt >> /mnt/etc/fstab
#
# echo "changing root"
# arch-chroot /mnt

echo "setting root password"
passwd

echo "adding new user"
read -p "Enter new username: " username
useradd -m $username
passwd $username
usermod -aG wheel $username

echo "synchronizing pacman databases"
pacman -Sy

echo "installing networkmanager"
pacman -S networkmanager git --noconfirm > /dev/null
systemctl enable NetworkManager > /dev/null

echo "configuring sudo"
pacman -S sudo --noconfirm > /dev/null
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
echo $hostname >> /etc/hostname
echo "127.0.0.1\tlocalhost
::1\t\tlocalhost
127.0.1.1\t$hostname.localdomain\t$hostname" >> /etc/hosts

echo "setting up grub"
fdisk -l
read -p "Choose the EFI partition: " efi
pacman -S grub efibootmgr --noconfirm > /dev/null
mkdir /boot/EFI
mount ${efi} /boot/EFI > /dev/null
grub-install --target=x86_64-efi --efi-directory=/boot/EFI --bootloader-id=GRUB > /dev/null
grub-mkconfig -o /boot/grub/grub.cfg > /dev/null

su $username <<'EOSU'
cd

echo "installing packages: git, base-devel"
sudo pacman -S git base-devel --noconfirm > /dev/null

echo "installing yay"
git clone https://aur.archlinux.org/yay.git > /dev/null
cd yay
makepkg -si --noconfirm > /dev/null
cd ..
rm -rf yay

echo "installing packages: xorg, xorg-xinit, i3, lightdm, kitty, rofi, neovim. this make take a while."
yay -S xorg xorg-xinit i3-gaps lightdm lightdm-webkit2-greeter lightdm-webkit-theme-litarvan kitty rofi neovim-nightly-bin --noconfirm > /dev/null

echo "installing nvim-paq"
git clone --depth=1 https://github.com/savq/paq-nvim.git "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/pack/paqs/start/paq-nvim > /dev/null

echo "downloading dotfiles"
git clone https://github.com/nihilistkitten/dotfiles > /dev/null

echo "symlinking configs"
DOTFILES_DIR="$HOME/dotfiles"
CONFIG_HOME="$HOME/.config"
mkdir $CONFIG_HOME
mkdir $CONFIG_HOME/nvim
ln -sv "$DOTFILES_DIR/git" "$CONFIG_HOME" > /dev/null
ln -sv "$DOTFILES_DIR/nvim/init.lua" "$CONFIG_HOME/nvim" > /dev/null
ln -sv "$DOTFILES_DIR/nvim/lua/" "$CONFIG_HOME/nvim" > /dev/null
ln -sv "$DOTFILES_DIR/nvim/snippets/" "$CONFIG_HOME/nvim" > /dev/null
ln -sv "$DOTFILES_DIR/nvim/ftplugin/" "$CONFIG_HOME/nvim" > /dev/null

sudo rm /etc/lightdm/lightdm.conf
sudo ln -sv "$DOTFILES_DIR/lightdm/lightdm.conf" "/etc/lightdm" > /dev/null
sudo rm /etc/lightdm/lightdm-webkit2-greeter.conf
sudo ln -sv "$DOTFILES_DIR/lightdm/lightdm-webkit2-greeter.conf" "/etc/lightdm" > /dev/null

echo "installing neovim dependencies"
nvim --headless +PaqInstall +q

echo "enabling lightdm"
echo "configuring user group"
sudo systemctl enable lightdm
# this allows lightdm to read the symlinked dotfiles
# from https://github.com/prikhi/lightdm-mini-greeter#config-file-in-home
sudo usermod -aG $(whoami) lightdm
chmod g+rx $HOME

EOSU
