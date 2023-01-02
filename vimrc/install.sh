#!/bin/bash
# exit when any command fails
set -e

SCRIPTPATH="$( cd -- "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"
cd "$SCRIPTPATH"

check_install(){
    echo "Checking application $1 (pkg $2)"
    if ! [ -x "$(command -v $1)" ]; then
        echo "Installing $1"
        sudo apt install $2
    fi
}

# Remove the previous nvim (if any) and install the updated version
#sudo apt remove neovim -y
echo "Checking application nvim (pkg nvim)"
if ! [ -x "$(command -v nvim)" ]; then
    sudo apt-get update
    sudo apt-get install software-properties-common build-essential # Install some dependencies (LSP) and add-apt-repository
    sudo add-apt-repository ppa:neovim-ppa/stable
    sudo apt-get update
    sudo apt-get install neovim
fi

check_install "git"    "git"        # The actual vimrc uses git to install packer
check_install "fzf"    "fzf"
check_install "rg"     "ripgrep"
check_install "curl"   "curl"

# Not need by the currect vimrc, but it is a nice tool
check_install "ag"     "silversearcher-ag"

mkdir -p $HOME/.config/nvim
cp -i  init.lua $HOME/.config/nvim/
cp -ir lua      $HOME/.config/nvim/
cp -ir after    $HOME/.config/nvim/

 echo -e "Installing all dependencies"

 nvim  --headless --noplugin \
        -c "qa!"

 echo -e "Installation complete"
