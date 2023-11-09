#!/usr/bin/env bash
### Cockpit
apt install -y cockpit
sed -i "s|^root|#root|g" /etc/cockpit/disallowed-users

### Cockpit-podman
apt install -y cockpit-podman

### Cockpit-machines
apt install -y cockpit-machines
mkdir -p /opt/vm/images /opt/vm/machines
