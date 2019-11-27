#!/bin/bash

cp tmux.conf $HOME/.tmux.conf

# Install the tmux plugin manager
echo "Install tmux plugin manager"
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

if [ -z "$1" ];  then
    echo -e "Copying the tmux file."
else
    echo -e "This script copies the tmux to the correct place and installs all dependencies if necessary."
    echo -e "\nUsage: $0"
fi
