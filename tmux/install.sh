#!/bin/bash

SCRIPTPATH="$( cd -- "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"
cd "$SCRIPTPATH"

if ! [ -x "$(command -v tmux)" ]; then
    echo "Installing tmux"
    sudo apt install tmux
fi

if ! [ -x "$(command -v fzf)" ]; then
    echo "Installing fzf"
    sudo apt install fzf
fi

cp tmux.conf $HOME/.tmux.conf
cp tmux-cht-languages $HOME/.tmux-cht-languages
cp tmux-cht-command $HOME/.tmux-cht-command
sudo cp tmux-cht.sh /usr/local/bin/
sudo chmod +x /usr/local/bin/tmux-cht.sh

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
