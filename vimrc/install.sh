#!/bin/sh

cp .vimrc ~/

if [ ! -d "$HOME/.vim/bundle/Vundle.vim" ]; then
    echo "Installing Vundle plugin"
    git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
else
    echo "Vundle plugin already exist"
fi

vim -c 'PluginInstall' -c 'qa!'

