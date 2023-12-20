#!/usr/bin/env bash
### https://flathub.org/zh-Hans/apps/dev.lizardbyte.app.Sunshine

flatpak --user install flathub dev.lizardbyte.app.Sunshine
sudo chmod a+rw /dev/uinput
sudo bash -c 'cat << EOF > /etc/udev/rules.d/85-sunshine-input.rules
KERNEL=="uinput", SUBSYSTEM=="misc", OPTIONS+="static_node=uinput", TAG+="uaccess"
EOF'
mkdir -p $HOME/.config/systemd/user
cat << EOF > $HOME/.config/systemd/user/sunshine.service
[Unit]
Description=Sunshine is a self-hosted game stream host for Moonlight.
StartLimitIntervalSec=500
StartLimitBurst=5
PartOf=graphical-session.target
Wants=xdg-desktop-autostart.target
After=xdg-desktop-autostart.target

[Service]
ExecStart=flatpak run --command=sunshine dev.lizardbyte.app.Sunshine
ExecStop=flatpak kill dev.lizardbyte.app.Sunshine
Restart=on-failure
RestartSec=5s

[Install]
WantedBy=xdg-desktop-autostart.target
EOF
systemctl --user set-default graphical-session.target
systemctl --user enable --now sunshine.service
