#!/usr/bin/env sh

## check EFI
# ls /sys/firmware/efi/efivars
#
## check internet
# ping example.org
#
## partition disk (use GPT partitions)
##   efi partition  | 550 MB      | EFI system partition
##   root partition | remainder   | Linux root
# fdisk -l
# fdisk /dev/disk  # REPLACE `disk`
#
## format partitions
# mkfs.fat -F32 /dev/disk1  # REPLACE `disk1`
# mkfs.ext4 /dev/disk2  # REPLACE `disk2`
#
## mount root
# mount /dev/disk2 /mnt  # REPLACE `disk2`
#
## install system
# pacstrap /mnt base linux linux-firmware
#
## run install script
# curl https://raw.githubusercontent.com/nihilistkitten/dotfiles/main/arch-install.sh | sh

echo "generating fstab file"
genfstab -U /mnt >> /mnt/etc/fstab

echo "changing root"
arch-chroot /mnt

echo "setting root password"
passwd

echo "adding new user"
read -p "Enter your username: " username
useradd -m $username
passwd $username
usermod -aG wheel $username

echo "configuring sudo"
pacman -S sudo --noconfirm > /dev/null 
echo "uncomment the wheel group: `%wheel ALL=(ALL) ALL`"
read -p "Press enter to confirm."
visudo

echo "updating the system time"
timedatectl set-ntp true

echo "setting the timezone"
ln -sf /usr/share/zoneinfo/America/Los_Angeles /etc/localtime
hwclock --systohc

echo "configuring localization"
sed -i '/en_US\.UTF-8 UTF-8/s/^#//g' /etc/locale.gen
locale-gen
echo "LANG=en_US.UTF-8" >> /etc/locale.conf

echo "configuring hostname"
read -p "Enter your desired hostname: " hostname
echo $hostname >> /etc/hostname
echo "127.0.0.1\tlocalhost
::1\t\tlocalhost
127.0.1.1\t$hostname.localdomain\t$hostname" >> /etc/hosts

echo "setting up grub"
pacman -S grub efibootmgr --noconfirm > /dev/null
mkdir /boot/EFI
mount /dev/disk1 /boot/EFI
grub-install --target=x86_64-efi --efi-directory=/boot/EFI --bootloader-id=GRUB
grub-mkconfig -o /boot/grub/grub.cfg

echo "installing networkmanager"
pacman -S networkmanager git --noconfirm > /dev/null
systemctl enable NetworkManager

echo "rebooting"
exit
umount /mnt
reboot

echo "remove the ISO usb"

timedatectl status
read -p "Press enter to confirm."
