#!/bin/bash

if ! [ -x "$(command -v fish)" ]; then
    echo "Installing fish"
    sudo apt install fish
fi

cp fishfile     $HOME/.config/fish/
cp config.fish  $HOME/.config/fish/
cp -r functions $HOME/.config/fish/ 

# Install Fisher
if ! [ -x "$(command -v fisher)" ]; then
    sudo apt-get install fonts-powerline
    set -q XDG_CONFIG_HOME; or set XDG_CONFIG_HOME ~/.config
    curl https://git.io/fisher --create-dirs -sLo $XDG_CONFIG_HOME/fish/functions/fisher.fish
    fish -c fisher

    echo "To correct visualize the font, is need to restart the terminal"
fi

chsh -s `which fish`

echo "Fish Installed!"
