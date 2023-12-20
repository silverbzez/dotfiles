#!/usr/bin/env bash
### https://wiki.archlinux.org/title/Xorg

### Intel Graphics
### https://wiki.archlinux.org/title/Intel_graphics
pacman -Syu vulkan-intel intel-media-driver
cat << EOF > /etc/modprobe.d/i915.conf
options i915 enable_guc=3
EOF
cat << EOF > /etc/X11/xorg.conf.d/20-intel.conf
Section "Device"
    Identifier "Intel Graphics"
    Driver "modesetting"
    BusID "PCI:0:2:0"
EndSection
EOF
