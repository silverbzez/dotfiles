#!/bin/sh
### Custom Repos
sed -i "s/downloads.openwrt.org/mirrors.tuna.tsinghua.edu.cn\/openwrt/g" /etc/opkg/distfeeds.conf

### opkg-upgrade-all Script
cat << EOF >> /root/opkg-upgrade-all.sh
#!/bin/sh
opkg update
opkg list-upgradable | cut -f 1 -d ' ' | xargs -r opkg upgrade
EOF
chmod a+x /root/opkg-upgrade-all.sh
sh /root/opkgall.sh
