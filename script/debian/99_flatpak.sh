#!/usr/bin/env bash
### Flatpak
apt install -y flatpak
flatpak remote-add --if-not-exists flathub https://mirror.sjtu.edu.cn/flathub/flathub.flatpakrepo
flatpak remote-modify flathub --url=https://mirror.sjtu.edu.cn/flathub
# Plugin for GNOME
apt install -y gnome-software-plugin-flatpak
# Plugin for KDE
apt install -y plasma-discover-backend-flatpak

### Scripts below should be run as a normal `user`
### Sunshine
sudo flatpak install flathub dev.lizardbyte.app.Sunshine
sudo flatpak override --talk-name=org.freedesktop.Flatpak dev.lizardbyte.app.Sunshine
# Sunshine needs access to uinput to create mouse and gamepad events
sudo chmod a+rw /dev/uinput
sudo bash -c 'cat << EOF > /etc/udev/rules.d/85-sunshine-input.rules
KERNEL=="uinput", SUBSYSTEM=="misc", OPTIONS+="static_node=uinput", TAG+="uaccess"
EOF'
# Set auto-login & Enable Xorg
sudo sed -e "s|^#.*AutomaticLoginEnable =.*$|AutomaticLoginEnable = true|g" \
         -e "s|^#.*AutomaticLogin = .*$|AutomaticLogin = $USER|g" \
         -e "s|^#WaylandEnable=.*$|WaylandEnable=false|g" \
         -i /etc/gdm3/daemon.conf
# Auto-start
mkdir -v -m 700 -p $HOME/.config/systemd/user
cat << EOF > $HOME/.config/systemd/user/sunshine.service
[Unit]
Description=Sunshine self-hosted game stream host for Moonlight.
StartLimitIntervalSec=500
StartLimitBurst=5

[Service]
ExecStart=/usr/bin/flatpak run dev.lizardbyte.app.Sunshine
Restart=on-failure
RestartSec=5s
ExecStop=/usr/bin/flatpak kill dev.lizardbyte.app.Sunshine

[Install]
WantedBy=graphical-session.target
EOF
systemctl enable --user --now sunshine.service

### Firefox
sudo flatpak install flathub org.mozilla.firefox

### Steam
sudo flatpak install flathub com.valvesoftware.Steam
