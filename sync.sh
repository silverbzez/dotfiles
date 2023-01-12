#!/usr/bin/env bash

# Bash
printf "\e[36mSyncing Bash configs\e[m\n"
cp -v $HOME/.bash_profile $PWD/bash/bash_profile
cp -v $HOME/.bashrc $PWD/bash/bashrc
for cfile in $HOME/.bashrc.d/*; do
  cp -v $cfile $PWD/bash/bashrc.d/
done

printf "\e[36mSyncing Custom Binaries\e[m\n"
for cfile in $HOME/.bin/*; do
  cp -v $cfile $PWD/bin/
done

printf "\e[36mSyncing Git configs\e[m\n"
cp -v $HOME/.gitconfig $PWD/git/gitconfig

printf "\e[36mSyncing Vim configs\e[m\n"
cp -v $HOME/.vimrc $PWD/vim/vimrc
