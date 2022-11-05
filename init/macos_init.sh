#!/usr/bin/env bash
/usr/bin/xcode-select --install
/usr/sbin/softwareupdate --install-rosetta --agree-to-license

printf "\e[36mInstalling MacPorts\e[m\n"

printf "Please manually download MacPorts in the following link:\n"
/usr/bin/open https://github.com/macports/macports-base/releases/latest/
/usr/bin/read -p "Press enter to continue"

sudo /opt/local/bin/port selfupdate
sudo /opt/local/bin/port -N install bash bash-completion vim git wget curl tree openssh podman
sudo /opt/local/bin/port -N install python310 py310-pip py310-setuptools py310-autopep8 py310-codestyle
sudo /opt/local/bin/port -N install python311 py311-pip py311-setuptools py311-autopep8 py311-codestyle

sudo /opt/local/bin/port select --set python python311
sudo /opt/local/bin/port select --set python3 python311
sudo /opt/local/bin/port select --set pip pip311
sudo /opt/local/bin/port select --set pip3 pip311
sudo /opt/local/bin/port select --set autopep8 autopep8-311
sudo /opt/local/bin/port select --set pycodestyle pycodestyle-py311

printf "\e[36mInstalling Homebrew\e[m\n"

/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

/opt/homebrew/bin/brew update
/opt/homebrew/bin/brew install --cask appcleaner the-unarchiver visual-studio-code iterm2 google-chrome microsoft-edge steam-plus-plus steam mactex-no-gui

### SMB Sharing on macOS
sudo defaults write /Library/Preferences/com.apple.desktopservices DSDontWriteNetworkStores -bool TRUE
