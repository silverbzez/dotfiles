#!/usr/bin/env bash
### Systemd-resolved
apt install -y systemd-resolved
DNS=223.5.5.5
FallbackDNS=223.6.6.6
sed -e "s|^#DNS=$|DNS=$DNS|g" \
    -e "s|^#FallbackDNS=$|FallbackDNS=$FallbackDNS|g" \
    -e "s|^#MulticastDNS=.*$|MulticastDNS=no|g" \
    -e "s|^#LLMNR=.*$|LLMNR=no|g" \
    -e "s|^#DNSStubListener=.*$|DNSStubListener=no|g" \
    -i /etc/systemd/resolved.conf
systemctl reload-or-restart systemd-resolved.service
