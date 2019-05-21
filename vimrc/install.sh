#!/bin/sh

cp .vimrc ~/

if ! [[ -f ~/.vim/bundle/Vundle.vim ]]; then
     git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
fi

vim -c 'PluginInstall' -c 'qa!'

