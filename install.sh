#!/usr/bin/env bash

# Bash
printf "\e[36mInstalling Bash configs\e[m\n"
install -v -m 644 $PWD/shell/bash/bash_profile $HOME/.bash_profile
install -v -m 644 $PWD/shell/bash/bashrc $HOME/.bashrc
mkdir -v -m 700 $HOME/.bashrc.d
for cfile in $PWD/shell/bash/bashrc.d/*; do
  install -v -m 644 $cfile $HOME/.bashrc.d
done

# Custom Binaries
printf "\e[36mInstalling Custom Binaries\e[m\n"
mkdir -v -m 700 $HOME/.bin
for cfile in $PWD/bin/*; do
  install -v -m 755 $cfile $HOME/.bin
done

# Git
printf "\e[36mInstalling Git configs\e[m\n"
install -v -m 644 $PWD/git/gitconfig $HOME/.gitconfig

# Vim
printf "\e[36mInstalling Vim configs\e[m\n"
install -v -m 644 $PWD/vim/vimrc $HOME/.vimrc
