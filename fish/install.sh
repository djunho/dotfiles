#!/bin/bash

sudo apt update

if ! [ -x "$(command -v fish)" ]; then
    echo "Installing fish"
    sudo apt-add-repository ppa:fish-shell/release-3
    sudo apt update
    sudo apt install -y fish
fi

[[ -e $HOME/.config/fish ]] || mkdir -p $HOME/.config/fish
cp config.fish  $HOME/.config/fish/
cp -r functions $HOME/.config/fish/ 

# Install Fisher
if ! [ -x "$(command -v fisher)" ]; then
    sudo apt-get install -y fonts-powerline
    fish -c "set -q XDG_CONFIG_HOME; or set XDG_CONFIG_HOME ~/.config; \
             curl -sL https://git.io/fisher | source && fisher install jorgebucaran/fisher"

    echo "To correct visualize the font, is need to restart the terminal"
fi

echo "Installing the plugings"
fish -c "fisher install jethrokuan/z"
fish -c "fisher install edc/bass"
fish -c "fisher install ilancosman/tide@v5"

# Install the dependencies of fzf.fish
# Follow the doc https://github.com/PatrickF1/fzf.fish
sudo apt install fd-find bat fzf
ln -s $(which fdfind) ~/.local/bin/fd
ln -s $(which batcat) ~/.local/bin/bat
fish -c "fisher install PatrickF1/fzf.fish"

chsh -s `which fish`

echo "Fish Installed!"
echo ""
echo "run \"tide configure\" to configure the command line prompt."
