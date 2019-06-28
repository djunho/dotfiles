#!/bin/bash

cp vimrc $HOME/.vimrc

if [ -z "$1" ];  then

    echo -e "Installing all dependencies"

    if [ ! -d "$HOME/.vim/bundle/Vundle.vim" ]; then
        echo -e "Installing Vundle plugin manager"
        git clone https://github.com/VundleVim/Vundle.vim.git $HOME/.vim/bundle/Vundle.vim
    fi

    sudo apt-get install ctags
    vim -c 'PluginInstall' -c 'qa!'

else
    if [ "$1" == "--vimrc" ]; then
        echo -e "Copying only the vimrc file."
    else
        echo -e "This script copies the vimrc to the correct place and installs all dependencies if necessary."
        echo -e "\nUsage: $0 [--vimrc]"
        echo -e "\noptions:"
        echo -e "\t--vimrc\t\tOnly copies the vimrc file. It does not install any dependencies."
    fi
fi
