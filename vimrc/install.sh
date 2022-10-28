#!/bin/bash

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
    sudo add-apt-repository ppa:neovim-ppa/stable
    sudo apt-get update
    sudo apt-get install neovim
fi

check_install "fzf"    "fzf"
check_install "ag"     "silversearcher-ag"
check_install "rg"     "ripgrep"
check_install "curl"   "curl"
check_install "npm"    "npm"
check_install "ctags"  "ctags"
check_install "cscope" "cscope"

# Install lsp to use lsp server vim plugin
# Some of the serevr uses node, so install a recent version
echo "Checking application node (pkg node)"
if ! [ -x "$(command -v node)" ]; then
    curl -sL install-node.now.sh | sudo bash
fi
check_install "clangd-12" "clangd-12"
sudo npm i -g pyright bash-language-server


mkdir -p $HOME/.config/nvim
cp -i init.vim $HOME/.config/nvim/
cp -ir after $HOME/.config/nvim/

if [ -z "$1" ];  then
    echo -e "Installing all dependencies"

    if [ ! -f "${XDG_DATA_HOME:-$HOME/.local/share}/nvim/site/autoload/plug.vim" ]; then
        echo -e "Installing plugin manager"
        sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs \
                            https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
    fi

    nvim -c "echo 'Running some commands in background. Sorry, but it could take a while'" \
         -c "sleep 3" \
         -c "PlugInstall" \
         -c "qa!"

    echo -e "Installation complete"
else
    if [[ "$1" == "--vimrc" ]]; then
        echo -e "Copying only the vim config files."
    else
        echo -e "This script copies the vimrc to the correct place and installs all dependencies if necessary."
        echo -e "\nUsage: $0 [--vimrc]"
        echo -e "\noptions:"
        echo -e "\t--vimrc\t\tOnly copies the vimrc file. It does not install any dependencies."
    fi
fi
