#!/usr/bin/env bash
### https://wiki.archlinux.org/title/Flatpak

flatpak --user remote-add --if-not-exists flathub https://mirror.sjtu.edu.cn/flathub/flathub.flatpakrepo
flatpak --user remote-modify flathub --url=https://mirror.sjtu.edu.cn/flathub
