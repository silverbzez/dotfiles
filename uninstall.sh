#!/usr/bin/env bash
### Bash
printf "\e[36mUninstalling Bash configs\e[m\n"
mv -v $HOME/.bash_profile $PWD/shell/bash/bash_profile
mv -v $HOME/.bashrc $PWD/shell/bash/bashrc
for cfile in $HOME/.bashrc.d/*; do
    mv -v $cfile $PWD/shell/bash/bashrc.d/
done
rm -rv $HOME/.bashrc.d/

### Custom Binaries
printf "\e[36mUninstalling Custom Binaries\e[m\n"
for cfile in $HOME/.bin/*; do
    mv -v $cfile $PWD/bin/
done
rm -rv $HOME/.bin/

### Git
printf "\e[36mUninstalling Git configs\e[m\n"
mv -v $HOME/.gitconfig $PWD/git/gitconfig

### Vim
printf "\e[36mUninstalling Vim configs\e[m\n"
mv -v $HOME/.vimrc $PWD/vim/vimrc
