#!/usr/bin/env bash
### Manual Works Beforehand
# Change disk size before setup
#qemu-img resize {FILENAME} {FILESIZE}
# Change `root` password
#passwd
# Configure sshd to allow `root` login with password
#ssh-keygen -A && sed -i -e "s|^#PermitRootLogin.*$|PermitRootLogin yes|g" -e "s|^PasswordAuthentication no$|PasswordAuthentication yes|g" /etc/ssh/sshd_config && systemctl restart sshd.service
# Resize disk (fdisk: d 1 n 1 enter enter n w)
#swapoff -a && fdisk -u /dev/vda && resize2fs /dev/vda1

### Version Check
. /etc/os-release
if [ $VERSION_CODENAME != "bookworm" ]; then
    echo "Need 'bookworm', current version: '$VERSION_CODENAME'"
    exit -1
fi

### Customizable Variables
DEB_BASE_MIRROR_URL=mirror.sjtu.edu.cn/debian/
DEB_SECURITY_MIRROR_URL=mirror.sjtu.edu.cn/debian-security/
DEB_ENABLE_SRC=false

### Kernel Parameters
cat << EOF >> /etc/sysctl.d/net.conf
net.core.default_qdisc = fq
net.ipv4.tcp_congestion_control = bbr
EOF
systemctl restart procps.service

### Custom Repos
rm -rv /etc/apt/sources.list /etc/apt/sources.list.d/*
touch /etc/apt/sources.list
cat << EOF > /etc/apt/sources.list.d/debian.list
deb http://$DEB_BASE_MIRROR_URL $VERSION_CODENAME main contrib non-free non-free-firmware
#deb-src http://$DEB_BASE_MIRROR_URL $VERSION_CODENAME main contrib non-free non-free-firmware

deb http://$DEB_BASE_MIRROR_URL $VERSION_CODENAME-updates main contrib non-free non-free-firmware
#deb-src http://$DEB_BASE_MIRROR_URL $VERSION_CODENAME-updates main contrib non-free non-free-firmware

deb http://$DEB_BASE_MIRROR_URL $VERSION_CODENAME-backports main contrib non-free non-free-firmware
#deb-src http://$DEB_BASE_MIRROR_URL $VERSION_CODENAME-backports main contrib non-free non-free-firmware

deb http://$DEB_SECURITY_MIRROR_URL $VERSION_CODENAME-security main contrib non-free non-free-firmware
#deb-src http://$DEB_SECURITY_MIRROR_URL $VERSION_CODENAME-security main contrib non-free non-free-firmware
EOF
# Reconfigure repos to use https
apt update
apt install -y apt-transport-https ca-certificates
sed -i "s|http|https|g" /etc/apt/sources.list.d/debian.list
apt clean
# Enable deb-src
if [ $DEB_ENABLE_SRC = true ]; then
    sed -i "s|^#deb-src|deb-src|g" /etc/apt/sources.list.d/debian.list
fi
# Full system upgrade
apt update
apt full-upgrade -y
# Manage softwares
apt install -y bash-completion vim gawk wget curl
apt purge -y nano vim-tiny mawk laptop-detect dictionaries-common ispell
apt autoremove --purge -y

### System Config
# Time Zone
dpkg-reconfigure tzdata

### Manual Works Afterhand
# Install QEMU guest agent
#apt update && apt install -y qemu-guest-agent
