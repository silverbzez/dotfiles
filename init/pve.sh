#!/usr/bin/env bash
### Get Debian Version Codename
. /etc/os-release
read -p "Check Debian version: $VERSION_CODENAME?"

### Custom Repos
rm -rvf /etc/apt/sources.list
touch /etc/apt/sources.list
rm -rvf /etc/apt/sources.list.d/*
cat << EOF >> /etc/apt/sources.list.d/debian.list
deb https://mirrors.ustc.edu.cn/debian/ $VERSION_CODENAME main contrib non-free
deb https://mirrors.ustc.edu.cn/debian/ $VERSION_CODENAME-updates main contrib non-free
deb https://mirrors.ustc.edu.cn/debian/ $VERSION_CODENAME-backports main contrib non-free
deb https://mirrors.ustc.edu.cn/debian-security $VERSION_CODENAME-security main contrib non-free
EOF
cat << EOF >> /etc/apt/sources.list.d/pve.list
deb https://mirrors.ustc.edu.cn/proxmox/debian/pve $VERSION_CODENAME pve-no-subscription
EOF
apt update
apt install -y sudo vim gawk command-not-found pve-kernel-6.1
apt purge -y nano vim-tiny mawk
apt dist-upgrade -y
apt autoremove --purge -y

### Docker
install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/debian/gpg | gpg --dearmor -o /etc/apt/keyrings/docker.gpg
cat << EOF >> /etc/apt/sources.list.d/docker.list
deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://mirrors.ustc.edu.cn/docker-ce/linux/debian $VERSION_CODENAME stable
EOF
apt update
apt install -y docker-ce

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
resize2fs /dev/mapper/pve-root

### Add Users
sed -i "s/%sudo	ALL=(ALL:ALL) ALL/%sudo	ALL=(ALL:ALL) NOPASSWD:ALL/g" /etc/sudoers
useradd -b /home -g users -G sudo -m -N -s /bin/bash -u 1000 boom

### System Restart
reboot
