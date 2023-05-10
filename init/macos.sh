#!/usr/bin/env bash
### macOS CLT
xcode-select --install
softwareupdate --install-rosetta --agree-to-license

### Homebrew
#bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
git clone --depth=1 https://mirrors.tuna.tsinghua.edu.cn/git/homebrew/install.git brew-install
bash brew-install/install.sh
rm -rf brew-install
/opt/homebrew/bin/brew tap --custom-remote --force-auto-update homebrew/cask-fonts https://mirrors.tuna.tsinghua.edu.cn/git/homebrew/homebrew-cask-fonts.git
/opt/homebrew/bin/brew tap --custom-remote --force-auto-update homebrew/cask-versions https://mirrors.tuna.tsinghua.edu.cn/git/homebrew/homebrew-cask-versions.git
/opt/homebrew/bin/brew tap --custom-remote --force-auto-update homebrew/services https://mirrors.tuna.tsinghua.edu.cn/git/homebrew/homebrew-services.git
/opt/homebrew/bin/brew update
/opt/homebrew/bin/brew install bash bash-completion vim git wget curl tree openssh podman podman-compose
/opt/homebrew/bin/brew install --cask appcleaner the-unarchiver iina vlc iterm2 visual-studio-code
/opt/homebrew/bin/brew install --cask font-cascadia-code font-cascadia-code-pl
/opt/homebrew/bin/brew install --cask google-chrome-dev google-chrome-canary
rm -rf /opt/homebrew/Caskroom/{google-chrome-dev,google-chrome-canary}

### SMB Sharing on macOS
sudo defaults write /Library/Preferences/com.apple.desktopservices DSDontWriteNetworkStores -bool TRUE
