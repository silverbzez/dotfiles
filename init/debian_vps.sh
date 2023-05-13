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

net.ipv4.tcp_fastopen = 3
net.ipv4.tcp_slow_start_after_idle = 0
net.ipv4.tcp_tw_reuse = 1
net.ipv4.tcp_fin_timeout = 16
net.ipv4.tcp_keepalive_time = 60
net.ipv4.tcp_keepalive_intvl = 10
net.ipv4.tcp_keepalive_probes = 6
net.ipv4.tcp_mtu_probing = 1
net.ipv4.tcp_timestamps = 0
net.ipv4.tcp_syncookies = 1
net.ipv4.tcp_rfc1337 = 1
net.ipv4.conf.default.rp_filter = 1
net.ipv4.conf.all.rp_filter = 1
net.ipv4.conf.default.send_redirects = 0
net.ipv4.conf.all.send_redirects = 0
net.ipv4.conf.default.accept_redirects = 0
net.ipv4.conf.all.accept_redirects = 0
net.ipv6.conf.default.accept_redirects = 0
net.ipv6.conf.all.accept_redirects = 0
EOF
sysctl -p

### Configure System
localectl set-locale en_US.UTF-8
localectl set-keymap us
dpkg-reconfigure --frontend noninteractive locales
timedatectl set-timezone Asia/Shanghai
dpkg-reconfigure --frontend noninteractive tzdata

### Get Debian Version Codename
. /etc/os-release
read -p "Check Debian version: $VERSION_CODENAME?"

### Custom Repos
rm -rvf /etc/apt/sources.list
touch /etc/apt/sources.list
rm -rvf /etc/apt/sources.list.d/*
cat << EOF >> /etc/apt/sources.list.d/debian.list
deb http://deb.debian.org/debian/ $VERSION_CODENAME main contrib non-free
deb http://deb.debian.org/debian/ $VERSION_CODENAME-updates main contrib non-free
deb http://deb.debian.org/debian/ $VERSION_CODENAME-backports main contrib non-free
deb http://deb.debian.org/debian-security/ $VERSION_CODENAME-security main contrib non-free
EOF
apt update
apt install -y vim gawk wget curl
apt purge -y nano vim-tiny mawk
apt dist-upgrade -y
apt autoremove --purge -y
### Reconfigure Repos to Use HTTPS
sed -i "s/http/https/g" /etc/apt/sources.list.d/debian.list

### System Restart
reboot
