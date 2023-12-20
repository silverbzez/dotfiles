#!/usr/bin/env bash
### https://wiki.archlinux.org/title/KDE

pacman -Syu plasma-meta konsole kwrite dolphin
# SDDM AutoLogin
### https://wiki.archlinux.org/title/SDDM#Autologin
mkdir -p /etc/sddm.conf.d
cat << EOF > /etc/sddm.conf.d/autologin.conf
[Autologin]
User=silverbz
Session=plasma.desktop
EOF
systemctl enable --now sddm.service
