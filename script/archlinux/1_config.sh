#!/usr/bin/env bash

### Mirrors
### https://wiki.archlinux.org/title/Mirrors
systemctl disable reflector.timer
systemctl disable reflector.service
cat << EOF > /etc/pacman.d/mirrorlist
Server = https://mirror.sjtu.edu.cn/archlinux/\$repo/os/\$arch
EOF
pacman -Syyu

### Kernel Modules & Parameters
### https://wiki.archlinux.org/title/Kernel_module
# Load
cat << EOF > /etc/modules-load.d/my-modules.conf
tcp_bbr
EOF
# sysctl
### https://wiki.archlinux.org/title/Sysctl
cat << EOF > /etc/sysctl.d/99-net.conf
net.core.default_qdisc = cake
net.ipv4.tcp_congestion_control = bbr
net.ipv4.tcp_fastopen = 3
net.ipv4.tcp_tw_reuse = 1
EOF

### mkinitcpio & systemd-boot
### https://wiki.archlinux.org/title/Mkinitcpio
### https://wiki.archlinux.org/title/Systemd-boot
sed -e "s|^HOOKS=.*$|HOOKS=(systemd autodetect modconf kms keyboard sd-vconsole block filesystems)|g" \
    -i /etc/mkinitcpio.conf
mkinitcpio -P
cat << EOF > /boot/loader/loader.conf
timeout      0
console-mode keep
EOF
systemctl enable --now systemd-boot-update.service

### locale
### https://wiki.archlinux.org/title/Locale
sed -e "s|#en_US.UTF-8 UTF-8|en_US.UTF-8 UTF-8|g" \
    -e "s|#zh_CN.UTF-8 UTF-8|zh_CN.UTF-8 UTF-8|g" \
    -i /etc/locale.gen
locale-gen
localectl set-locale LANG=en_US.UTF-8
localectl set-keymap us

### System Time
### https://wiki.archlinux.org/title/System_time
timedatectl set-timezone Asia/Shanghai
timedatectl set-local-rtc 0

### User
### https://wiki.archlinux.org/title/Users_and_groups
sed -e "s|# %wheel ALL=(ALL:ALL) ALL|%wheel ALL=(ALL:ALL) ALL|g" \
    -e "s|# %sudo	ALL=(ALL:ALL) ALL|%sudo	ALL=(ALL:ALL) ALL|g" \
    -i /etc/sudoers
useradd silverbz -g users -G wheel,audio,video -m -N -s /bin/bash -u 1000

### systemd default.target
systemctl set-default graphical.target
