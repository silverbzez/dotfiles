#!/usr/bin/env bash
### Get Debian Version Codename
. /etc/os-release
read -p "Check Debian version: $(echo "$VERSION_CODENAME")?"

### Custom Repos
rm -rvf /etc/apt/sources.list
touch /etc/apt/sources.list
rm -rvf /etc/apt/sources.list.d/*
cat << EOF >> /etc/apt/sources.list.d/debian.list
deb https://mirrors.tuna.tsinghua.edu.cn/debian/ $(echo "$VERSION_CODENAME") main contrib non-free
deb https://mirrors.tuna.tsinghua.edu.cn/debian/ $(echo "$VERSION_CODENAME")-updates main contrib non-free
deb https://mirrors.tuna.tsinghua.edu.cn/debian/ $(echo "$VERSION_CODENAME")-backports main contrib non-free
deb https://mirrors.tuna.tsinghua.edu.cn/debian-security $(echo "$VERSION_CODENAME")-security main contrib non-free
EOF
cat << EOF >> /etc/apt/sources.list.d/pve.list
deb https://mirrors.tuna.tsinghua.edu.cn/proxmox/debian/pve $(echo "$VERSION_CODENAME") pve-no-subscription
EOF
apt update
apt install -y vim gawk
apt purge -y nano vim-tiny mawk
apt dist-upgrade -y

### Kernel Modules for PCI Passthrough
cat << EOF >> /etc/modules
vfio
vfio_iommu_type1
vfio_pci
vfio_virqfd
EOF
update-initramfs -u -k all

### Enable IOMMU
sed -i 's/GRUB_CMDLINE_LINUX_DEFAULT="quiet"/GRUB_CMDLINE_LINUX_DEFAULT="quiet intel_iommu=on iommu=pt"/g' /etc/default/grub
sed -i 's/GRUB_CMDLINE_LINUX=""/GRUB_CMDLINE_LINUX="intel_iommu=on iommu=pt"/g' /etc/default/grub
update-grub

### Remove and Resize LVM Groups
lvremove -f pve/data
lvextend -l +100%free pve/root

### System Restart
reboot
