#!/bin/bash

if ! [ -x "$(command -v tmux)" ]; then
    echo "Installing tmux"
    sudo apt install tmux
fi

cp tmux.conf $HOME/.tmux.conf

# Install the tmux plugin manager
if [ ! -d "$HOME/.tmux/plugins/tpm" ]; then
    echo "Installing tmux plugin manager"
    git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
    ~/.tmux/plugins/tpm/bindings/install_plugins
fi

if [ -z "$1" ];  then
    echo -e "Copying the tmux file."
else
    echo -e "This script copies the tmux to the correct place and installs all dependencies if necessary."
    echo -e "\nUsage: $0"
fi
