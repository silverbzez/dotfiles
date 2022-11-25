#!/usr/bin/env bash
/usr/bin/xcode-select --install
/usr/sbin/softwareupdate --install-rosetta --agree-to-license

printf "\e[36mInstalling MacPorts\e[m\n"

printf "Please manually download MacPorts in the following link:\n"
/usr/bin/open https://github.com/macports/macports-base/releases/latest/
/usr/bin/read -p "Press enter to continue"

sudo /opt/local/bin/port selfupdate
sudo /opt/local/bin/port -N install bash bash-completion vim git wget curl tree openssh podman
sudo /opt/local/bin/port -N install python38 py38-pip py38-setuptools py38-autopep8 py38-codestyle
sudo /opt/local/bin/port -N install python39 py39-pip py39-setuptools py39-autopep8 py39-codestyle
sudo /opt/local/bin/port -N install python310 py310-pip py310-setuptools py310-autopep8 py310-codestyle

sudo /opt/local/bin/port select --set python python310
sudo /opt/local/bin/port select --set python3 python310
sudo /opt/local/bin/port select --set pip pip310
sudo /opt/local/bin/port select --set pip3 pip310
sudo /opt/local/bin/port select --set autopep8 autopep8-310
sudo /opt/local/bin/port select --set pycodestyle pycodestyle-py310

printf "\e[36mInstalling Homebrew\e[m\n"

/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

/opt/homebrew/bin/brew tap homebrew/cask-fonts
/opt/homebrew/bin/brew update
/opt/homebrew/bin/brew install --cask google-chrome microsoft-edge
/opt/homebrew/bin/brew install --cask appcleaner the-unarchiver iina
/opt/homebrew/bin/brew install --cask visual-studio-code iterm2 github mactex-no-gui
/opt/homebrew/bin/brew install --cask steam-plus-plus steam
/opt/homebrew/bin/brew install --cask font-cascadia-code font-cascadia-code-pl

### SMB Sharing on macOS
sudo defaults write /Library/Preferences/com.apple.desktopservices DSDontWriteNetworkStores -bool TRUE
