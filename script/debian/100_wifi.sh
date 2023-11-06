#!/usr/bin/env bash
### Intel AX101 WiFi Fix
echo "options iwlwifi disable_11ax=true" > /etc/modprobe.d/iwlwifi.conf
update-initramfs -u -k all
