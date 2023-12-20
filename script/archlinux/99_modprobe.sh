#!/usr/bin/env bash

# Intel AX101 Wi-Fi
cat << EOF > /etc/modprobe.d/iwlwifi.conf
options iwlwifi disable_11ax=true
EOF
