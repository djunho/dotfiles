#!/bin/bash

sudo apt update

if ! [ -x "$(command -v fish)" ]; then
    echo "Installing fish"
    sudo apt install -y fish
fi

[[ -e $HOME/.config/fish ]] || mkdir -p $HOME/.config/fish
cp fishfile     $HOME/.config/fish/
cp config.fish  $HOME/.config/fish/
cp -r functions $HOME/.config/fish/ 

# Install Fisher
if ! [ -x "$(command -v fisher)" ]; then
    sudo apt-get install -y fonts-powerline
    fish -c "set -q XDG_CONFIG_HOME; or set XDG_CONFIG_HOME ~/.config; \
	     curl -sL https://git.io/fisher | source && fisher install jorgebucaran/fisher"

    echo "To correct visualize the font, is need to restart the terminal"
fi

chsh -s `which fish`

echo "Fish Installed!"
