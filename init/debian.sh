#!/usr/bin/env bash
### Limits
cat << EOF >> /etc/security/limits.conf
*                soft    nofile          51200
*                hard    nofile          51200
EOF

### Kernel Parameters
cat << EOF >> /etc/sysctl.conf
fs.file-max = 51200

net.core.default_qdisc = fq
net.ipv4.tcp_congestion_control = bbr
EOF
sysctl -p

### Configure System
localectl set-locale en_US.UTF-8
localectl set-keymap us
dpkg-reconfigure --frontend noninteractive locales
timedatectl set-timezone Asia/Shanghai
dpkg-reconfigure --frontend noninteractive tzdata
sed -i "s/#LLMNR=yes/LLMNR=no/g" /etc/systemd/resolved.conf
sed -i "s/#DNSStubListener=yes/DNSStubListener=no/g" /etc/systemd/resolved.conf
systemctl enable systemd-resolved.service
systemctl reload-or-restart systemd-resolved.service

### Get Debian Version Codename
. /etc/os-release
read -p "Check Debian version: $VERSION_CODENAME?"

### Custom Repos
rm -rvf /etc/apt/sources.list
touch /etc/apt/sources.list
rm -rvf /etc/apt/sources.list.d/*
cat << EOF >> /etc/apt/sources.list.d/debian.list
deb http://mirrors.ustc.edu.cn/debian/ $VERSION_CODENAME main contrib non-free
deb http://mirrors.ustc.edu.cn/debian/ $VERSION_CODENAME-updates main contrib non-free
deb http://mirrors.ustc.edu.cn/debian/ $VERSION_CODENAME-backports main contrib non-free
deb http://mirrors.ustc.edu.cn/debian-security $VERSION_CODENAME-security main contrib non-free
EOF
apt update
apt install -y vim gawk wget curl command-not-found gnupg net-tools
apt purge -y nano vim-tiny mawk laptop-detect dictionaries-common ispell
apt dist-upgrade -y
apt autoremove --purge -y
### Reconfigure Repos to Use HTTPS
sed -i "s/http/https/g" /etc/apt/sources.list.d/debian.list

### Docker
install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/debian/gpg | gpg --dearmor -o /etc/apt/keyrings/docker.gpg
cat << EOF >> /etc/apt/sources.list.d/docker.list
deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://mirrors.ustc.edu.cn/docker-ce/linux/debian $VERSION_CODENAME stable
EOF
apt update
apt install -y docker-ce
### Enable Docker IPv6 Support
cat << EOF >> /etc/docker/daemon.json
{
  "experimental": true,
  "ipv6": true,
  "ip6tables": true,
  "fixed-cidr-v6": "fd00:172:17::/64"
}
EOF

### System Restart
reboot
